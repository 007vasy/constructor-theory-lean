#!/usr/bin/env bash
# Grok Build swarm pilot for constructor-theory-lean.
# ⚠️ UNTESTED WITH A REAL MODEL: the plumbing (setup, worktrees, board, build lock, steward merge,
# kill switch) was dry-run on the box with a stub agent (GROK_BIN=stub). No `grok` session has run.
# Do NOT start it without Ben's explicit OK (docs/swarm/PILOT.md §8): it draws on his shared plan
# pool, which also powers his Grok Bot agents.
#
#   swarm/grok/launch.sh setup            # make $SWARM_HOME, clone, worktrees, board (no model calls)
#   swarm/grok/launch.sh start            # run the swarm in the background (model calls!)
#   swarm/grok/launch.sh status           # rounds, tokens, merges so far
#   swarm/grok/launch.sh stop             # KILL SWITCH: touch STOP and kill every process group
#
# Hard caps (env, clamped to the ceilings below whatever you pass):
#   AGENTS        default 1, ceiling 3   (box: 8 vCPU, 15 GB, ~2.5 GB free; one Lean build ≈ 2.5 GB)
#   HOURS         default 0.33, ceiling 24  wall clock for the whole swarm
#   MAX_TURNS     default 30, ceiling 80    agent turns per round (grok --max-turns)
#   ROUND_MIN     default 20, ceiling 60    wall clock per round (timeout)
#   TOKEN_BUDGET  default 3000000           total tokens (input+cached+output) for the whole swarm;
#                                           checked after every round, STOP when reached
#   MODEL         default empty (the CLI's default); e.g. grok-4.7
#   BASE_REF      default origin/next-steps (PR #6; not merged, so the pilot builds on its branch)
#   SWARM_HOME    default /workspace/ctl-swarm  (not a build/dist/out/target name: survives box resets)
set -euo pipefail

SWARM_HOME="${SWARM_HOME:-/workspace/ctl-swarm}"
REPO_URL="${REPO_URL:-https://github.com/007vasy/constructor-theory-lean}"
BASE_REF="${BASE_REF:-origin/next-steps}"
# Prebuilt Mathlib v4.36.0 (7.3 GB), shared read-only. Box: /workspace/ctl; elsewhere: run `lake exe cache get` in $SWARM_HOME/repo first.
if [ -z "${PKGS:-}" ]; then [ -d /workspace/ctl/.lake/packages ] && PKGS=/workspace/ctl/.lake/packages || PKGS="$SWARM_HOME/repo/.lake/packages"; fi
GROK_BIN="${GROK_BIN:-$HOME/.grok/bin/grok}"
SRC="$(cd "$(dirname "$0")" && pwd)"

clamp() { python3 -c "import sys; v=min(float(sys.argv[1]), float(sys.argv[2])); print(int(v) if v.is_integer() else v)" "$1" "$2"; }
AGENTS_CEILING=$(clamp "${AGENTS_CEILING:-3}" 8)   # 3 on the box; up to 8 on Ben's 128-core / 61 GB workstation
AGENTS=$(clamp "${AGENTS:-1}" "$AGENTS_CEILING")
HOURS=$(clamp "${HOURS:-0.33}" 24)
MAX_TURNS=$(clamp "${MAX_TURNS:-30}" 80)
ROUND_MIN=$(clamp "${ROUND_MIN:-20}" 60)
TOKEN_BUDGET="${TOKEN_BUDGET:-3000000}"
MODEL="${MODEL:-}"
ROUND_FILE="${ROUND_FILE:-$SRC/round.md}"; ROUND_FILE="$(cd "$(dirname "$ROUND_FILE")" && pwd)/$(basename "$ROUND_FILE")"
LANES=(derive redteam derive)                     # agent i gets LANES[i]; the steward is this script

R="$SWARM_HOME/repo"; WT="$SWARM_HOME/wt"; BOARD="$SWARM_HOME/board"; LOGS="$SWARM_HOME/logs"
LEDGER="$SWARM_HOME/ledger.tsv"; STOP="$SWARM_HOME/STOP"; LOCK="$SWARM_HOME/build.lock"; BIN="$SWARM_HOME/bin"

stopped() { [ -e "$STOP" ]; }
log() { echo "$(date '+%F %T %Z') $*" | tee -a "$SWARM_HOME/swarm.log" >&2; }

setup() {
  mkdir -p "$SWARM_HOME" "$WT" "$BOARD" "$LOGS" "$BIN"
  [ -d "$R/.git" ] || git clone -q "$REPO_URL" "$R"
  git -C "$R" remote set-url --push origin DISABLED-no-push-from-swarm   # agents can never push to GitHub
  git -C "$R" fetch -q origin
  git -C "$R" rev-parse -q --verify swarm-run >/dev/null || git -C "$R" branch --no-track swarm-run "$BASE_REF"   # integration branch; kept across restarts
  # Board: one append-only markdown file per channel, plus each agent's notes.
  for ch in general derive redteam steward; do [ -f "$BOARD/$ch.md" ] || echo "# #$ch" > "$BOARD/$ch.md"; done
  [ -f "$BOARD/DEAD_ENDS.md" ] || cp "$SRC/../../docs/swarm/DEAD_ENDS.md" "$BOARD/DEAD_ENDS.md" 2>/dev/null || echo "# Dead ends" > "$BOARD/DEAD_ENDS.md"
  # Frozen copy of the judge, outside every path an agent can write.
  rm -f "$BIN/judge.sh"; install -m 555 "$SRC/../judge.sh" "$BIN/judge.sh"
  # Wrappers: every Lean build and judge run is serialised through one lock (memory).
  cat > "$BIN/ctl-build" <<W
#!/usr/bin/env bash
exec flock "$LOCK" nice -n 10 lake build "\$@"
W
  cat > "$BIN/ctl-judge" <<W
#!/usr/bin/env bash
# Judge your worktree against the integration branch, under the build lock.
exec flock "$LOCK" nice -n 10 "$BIN/judge.sh" swarm-run
W
  chmod +x "$BIN/ctl-build" "$BIN/ctl-judge"
  # Kernel sandbox profile (Landlock): write only the worktree, the board, the repo's .git, /tmp;
  # no network for child processes; deny GitHub/SSH credentials and the bot's data.
  mkdir -p "$HOME/.grok"; touch "$HOME/.grok/sandbox.toml"
  python3 - "$HOME/.grok/sandbox.toml" "$BOARD" "$R/.git" "$LOCK" <<'PY'
import re, sys
p, board, gitdir, lock = sys.argv[1:]
s = open(p).read()
s = re.sub(r"\n?\[profiles\.ctlswarm\].*?(?=\n\[|\Z)", "", s, flags=re.S)   # replace our own block only
s = s.rstrip("\n") + f"""

[profiles.ctlswarm]
extends = "workspace"
restrict_network = true
read_write = ["{board}", "{gitdir}", "{lock}"]
deny = ["~/.config/gh", "~/.ssh", "~/.gnupg", "~/.aws", "~/.docker", "~/.kube", "~/.netrc", "~/.git-credentials", "~/.config/google-chrome", "~/.mozilla", "~/.local/share/keyrings", "/home/box/agent-data", "**/.env"]
"""
open(p, "w").write(s.lstrip("\n"))
PY
  touch "$LOCK"
  for i in $(seq 0 $((AGENTS-1))); do
    name="a$i-${LANES[$i]}"
    if [ ! -d "$WT/$name" ]; then
      git -C "$R" worktree add -q -B "agent/$name" "$WT/$name" swarm-run
      mkdir -p "$WT/$name/.lake" && ln -sfn "$PKGS" "$WT/$name/.lake/packages"
    fi
    [ -f "$BOARD/notes-$name.md" ] || echo "# Notes of $name (lane ${LANES[$i]})" > "$BOARD/notes-$name.md"
  done
  [ -f "$LEDGER" ] || printf 'time\tagent\tround\tstop\tturns\ttotal_tokens\tinput\tcache_read\toutput\tcost_usd\n' > "$LEDGER"
  log "setup ok: $AGENTS agent(s), base $BASE_REF ($(git -C "$R" rev-parse --short swarm-run))"
}

tokens_used() { awk -F'\t' 'NR>1{s+=$6} END{print s+0}' "$LEDGER"; }

prompt_for() {  # $1 name, $2 lane, $3 round
  cat "$SRC/../../docs/swarm/SYSTEM_PROMPT.md" "$SRC/../../docs/swarm/lanes/$2.md" "$SRC/board-rules.md"
  printf '\n\n## This round\nYou are %s, lane %s, round %s. Your worktree is the current directory (branch agent/%s).\nBoard: %s. Your notes: %s/notes-%s.md.\n' "$1" "$2" "$3" "$1" "$BOARD" "$BOARD" "$1"
  cat "${ROUND_FILE:-$SRC/round.md}"
}

agent_loop() {  # $1 index
  local name="a$1-${LANES[$1]}" lane="${LANES[$1]}" round=0 dir="$WT/a$1-${LANES[$1]}"
  while ! stopped; do
    round=$((round+1)); local out="$LOGS/$name-r$round.json" pf="$LOGS/$name-r$round.prompt.md"
    prompt_for "$name" "$lane" "$round" > "$pf"
    log "$name round $round start"
    # A fresh session every round keeps prompts under 200k tokens (long-context pricing doubles);
    # continuity is the notes file and the board.
    ( cd "$dir" && PATH="$BIN:$PATH" timeout --kill-after=30 "$((ROUND_MIN*60))" \
        "$GROK_BIN" --no-auto-update -p --prompt-file "$pf" --output-format json \
        ${MODEL:+-m "$MODEL"} --max-turns "$MAX_TURNS" --sandbox ctlswarm \
        --always-approve --no-subagents --no-memory --disable-web-search \
        --deny 'Bash(git push*)' --deny 'Bash(gh *)' --deny 'Bash(curl *)' --deny 'Bash(wget *)' \
        --deny 'Bash(lake *)' --deny 'Bash(rm -rf *)' --deny 'Bash(sudo *)' \
        --deny 'Edit(swarm/judge.sh)' --deny 'Edit(harness/run_checks.py)' --deny 'Edit(lakefile.toml)' \
        --deny 'Edit(lean-toolchain)' --deny 'Edit(lake-manifest.json)' --deny 'Edit(.github/**)' \
        --deny 'Read(~/.config/gh/**)' --deny 'Read(~/.ssh/**)' --deny 'Read(/home/box/agent-data/**)' \
        > "$out" 2> "$out.err" ) || log "$name round $round exited $?"
    python3 - "$out" "$name" "$round" >> "$LEDGER" <<'PY' || true
import json, sys, time
try: d = json.load(open(sys.argv[1]))
except Exception: d = {}
u = d.get("usage", {})
print("\t".join(map(str, [time.strftime("%FT%T"), sys.argv[2], sys.argv[3], d.get("stopReason", "none"),
      d.get("num_turns", 0), u.get("total_tokens", 0), u.get("input_tokens", 0),
      u.get("cache_read_input_tokens", 0), u.get("output_tokens", 0), d.get("total_cost_usd", "")])))
PY
    steward_merge "$name"
    local used; used=$(tokens_used)
    if [ "$used" -ge "$TOKEN_BUDGET" ]; then log "TOKEN_BUDGET reached ($used >= $TOKEN_BUDGET): STOP"; touch "$STOP"; fi
  done
  log "$name stopped after $round round(s)"
}

steward_merge() {  # Deterministic steward: merge an agent branch into swarm-run only if the judge passes.
  local name="$1" dir="$WT/$1"
  ( cd "$dir"
    git diff --quiet swarm-run...HEAD 2>/dev/null && exit 0                  # nothing new
    git status --porcelain | grep -q . && git add -A && git -c user.name="$name" -c user.email="$name@swarm.local" commit -qm "$name: uncommitted work at end of round" || true
    if flock "$LOCK" "$BIN/judge.sh" swarm-run > "$LOGS/$name-judge.txt" 2>&1; then
      local line; line=$(tail -1 "$LOGS/$name-judge.txt")
      if git -C "$R" merge-base --is-ancestor swarm-run "agent/$name"; then
        git -C "$R" branch -f swarm-run "agent/$name"
      else
        local tmp="$SWARM_HOME/merge-tmp"; rm -rf "$tmp"; git -C "$R" worktree add -q "$tmp" swarm-run
        if (cd "$tmp" && git -c user.name=steward -c user.email=steward@swarm.local merge -q --no-edit "agent/$name"); then
          git -C "$tmp" checkout -q --detach; git -C "$R" branch -f swarm-run "$(git -C "$tmp" rev-parse HEAD)"
        else
          (cd "$tmp" && git merge --abort); echo "- $(date -u +%FT%TZ) steward: @$name merge conflict with swarm-run; rebase onto swarm-run" >> "$BOARD/steward.md"
        fi
        git -C "$R" worktree remove --force "$tmp"
      fi
      echo "- $(date -u +%FT%TZ) steward: merged $name ($line)" >> "$BOARD/general.md"
    else
      echo "- $(date -u +%FT%TZ) steward: @$name not merged: $(tail -1 "$LOGS/$name-judge.txt")" >> "$BOARD/steward.md"
    fi )
}

start() {
  [ -x "$GROK_BIN" ] || { echo "grok not installed at $GROK_BIN"; exit 1; }
  if [ "${GROK_BIN##*/}" = grok ] && [ -z "${XAI_API_KEY:-}" ] && "$GROK_BIN" --no-auto-update models 2>&1 | grep -q 'not authenticated'; then
    echo "grok is not signed in. Ben must run 'grok login --device-auth' himself (or provide XAI_API_KEY via a secret)."; exit 1
  fi
  rm -f "$STOP"; setup
  local deadline; deadline=$(python3 -c "import time; print(int(time.time()+float('$HOURS')*3600))")
  log "start: AGENTS=$AGENTS HOURS=$HOURS MAX_TURNS=$MAX_TURNS ROUND_MIN=$ROUND_MIN TOKEN_BUDGET=$TOKEN_BUDGET MODEL=${MODEL:-default}"
  ( while ! stopped; do [ "$(date +%s)" -ge "$deadline" ] && { log "HOURS reached: STOP"; touch "$STOP"; }; sleep 20; done ) &
  echo $! > "$SWARM_HOME/pids"
  # Memory sampler: total RSS (MB) of grok, lean and lake processes every 10 s.
  ( echo -e "time\tgrok_mb\tlean_lake_mb\tavail_mb" > "$SWARM_HOME/mem.tsv"
    while ! stopped; do
      printf '%s\t%s\t%s\t%s\n' "$(date +%T)" \
        "$(ps -eo rss=,comm= | awk '$2 ~ /^grok/ {s+=$1} END{print int(s/1024)}')" \
        "$(ps -eo rss=,comm= | awk '$2 ~ /^(lean|lake)/ {s+=$1} END{print int(s/1024)}')" \
        "$(awk '/MemAvailable/ {print int($2/1024)}' /proc/meminfo)" >> "$SWARM_HOME/mem.tsv"; sleep 10; done ) &
  echo $! >> "$SWARM_HOME/pids"
  for i in $(seq 0 $((AGENTS-1))); do
    setsid bash -c "$(declare -f log stopped tokens_used prompt_for agent_loop steward_merge); $(declare -p SWARM_HOME R WT ROUND_FILE BOARD LOGS LEDGER STOP LOCK BIN SRC GROK_BIN MODEL MAX_TURNS ROUND_MIN TOKEN_BUDGET LANES); agent_loop $i" &
    echo $! >> "$SWARM_HOME/pids"; sleep 5
  done
  log "started; kill switch: $0 stop"
}

stop() {  # Kill switch.
  touch "$STOP"
  if [ -f "$SWARM_HOME/pids" ]; then
    while read -r p; do kill -TERM -- "-$p" 2>/dev/null || kill -TERM "$p" 2>/dev/null || true; done < "$SWARM_HOME/pids"
    sleep 5
    while read -r p; do kill -KILL -- "-$p" 2>/dev/null || kill -KILL "$p" 2>/dev/null || true; done < "$SWARM_HOME/pids"
  fi
  pkill -f -- "--sandbox ctlswarm" 2>/dev/null || true
  log "stopped (kill switch)"
}

status() {
  echo "tokens used: $(tokens_used) / $TOKEN_BUDGET"; tail -20 "$LEDGER"
  echo "swarm-run: $(git -C "$R" log --oneline -1 swarm-run)"; [ -e "$STOP" ] && echo "STOP is set"
  pgrep -fa -- "--sandbox ctlswarm" || echo "no grok session running"
}

case "${1:-}" in setup) setup ;; start) start ;; stop) stop ;; status) status ;;
  *) sed -n '2,25p' "$0"; exit 1 ;; esac
