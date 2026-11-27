# Swarm pilot: a small Lean-judged agent swarm on Grok Build

**Status (updated 27 Nov 2026, Australia/Sydney):** draft launcher and plan. A 1-agent
calibration run already happened on Ben's workstation on 26 Nov (`CALIBRATION.md`); no
multi-agent run has started. A 3-agent × 2 h Grok Build run still needs Ben's OK and must
not be launched from this merge. Costs: `COSTS.md`. Judge: `JUDGE.md`. Prompts: `SYSTEM_PROMPT.md`, `lanes/`,
`swarm/grok/board-rules.md`, `swarm/grok/round.md`. Launcher: `swarm/grok/launch.sh`.

## 1. Why, and why Grok Build

Hugging Face's PyBot report ("Scaling Swarms to Thousands of Agents", 25 Nov 2026) showed that many
agents can push one codebase forward when there is a shared prompt, lanes, a board, and a rule that every
change must beat main. Our judge is stricter than theirs: Lean accepts a proof or it does not.

Ben chose **Grok Build** (xAI's `grok` CLI, "Just use Grok build", 26 Nov). It is included in his X
subscription, runs headless (`grok -p`), and has the controls a swarm needs: `--max-turns`,
`--output-format json` with token usage, `--always-approve` with `--deny` rules, and a kernel sandbox
(`--sandbox`, Landlock on Linux) with per-profile write paths and no child network.

**Legion cannot drive it.** The report calls Legion harness-agnostic, but the code at commit `e04645b`
registers one harness (`harbor`), whose agent is hard-wired to Pi (`harbor/config.py`:
`harness: Literal["pi"]`). Legion's model calls also go to OpenAI-compatible endpoints, not to a CLI.
Adding a Grok Build adapter (`worker/adapters/`) would be real engineering. **msgboard** runs standalone
(`python -m msgboard serve`) with an HTTP API, but our agents run with child networking blocked, so
the pilot uses a **folder of markdown files as the board** instead. msgboard can come later.

## 2. Goal

One open problem from `docs/formalisation-gap/CLOSING_THE_GAP.md` (§6, on main since PR #6 merged 27 Nov as `88898c6`):
the two-forbidden-tasks model was **refuted as complete** by Maxwell–Boltzmann and Gibbs. The revised
model adds a third forbidden task after the failure, which costs it a point (8/10).

**The pilot tries to derive that third task instead of postulating it:**
- (T3) *Distinguishing a configuration of identical particles from its permutation is impossible*,
  i.e. the symmetrisation postulate, from constructor-theoretic principles (interoperability,
  superinformation, locality / no-signalling, and the composition of substrates).
- Stretch goal: the boson/fermion sign (±1 under exchange) from locality plus rotation, i.e. a
  constructor-theoretic route to spin–statistics. Known routes need relativistic QFT, or the
  topology of configuration space in 3 dimensions (Leinaas–Myrheim 1977; Berry–Robbins 1997).
  The agents must cite which route they follow.

## 3. Lanes and sizes

| Lane | Who | Owns |
|---|---|---|
| derive | `grok` agents (a0, a2) | Lean statements and proofs of T3 in `ConstructorTheory/Swarm/` |
| red-team | `grok` agent (a1) | counter-models, circularity and vacuity checks, refutations in Lean |
| steward | **the launch script, not a model** | runs the judge on each agent branch after every round, merges into `swarm-run` if it passes, posts the result on the board. A deterministic steward spends no pool. |

**Box limits (measured 26 Nov):** 8 vCPU, 15 GB RAM with 13 GB already used by other processes (about
2.5 GB free). One judge run (rebuild one file, then axiom audit) peaks at **2.5 GB RSS** and takes
**31–43 s** with the shared Mathlib cache. So **only one Lean build can run at a time**: the script
routes every build and judge through one lock (`flock`). Each `grok` process adds its own memory
(not measured; the CLI has not run a session here).

**Recommendation: 1 agent for the calibration run, then at most 2–3.** Above 3, agents mostly wait for
the build lock. 5 or more needs a bigger machine.

## 4. How it runs (swarm/grok/launch.sh)

- `$SWARM_HOME` = `/workspace/ctl-swarm` (a name the box keeps across resets). It holds a fresh clone of
  the public repo with **push disabled**, the integration branch `swarm-run` (created from
  `origin/main`; until 27 Nov the default was `origin/next-steps` because PR #6 was still open), one git worktree per agent
  (`wt/a0-derive`, ...) on branch `agent/<name>`, the board, logs, a token ledger and a frozen copy of
  the judge that no agent can write.
- Each round is one headless session:
  `grok -p --prompt-file <round prompt> --output-format json --max-turns N --sandbox ctlswarm
  --always-approve --no-subagents --no-memory --disable-web-search --deny ...`, under `timeout`.
  A fresh session per round keeps prompts under 200k tokens; the agent's notes file carries state.
- **Sandbox profile `ctlswarm`** (written into `~/.grok/sandbox.toml`): based on `workspace` (write only
  the worktree and /tmp), plus the board, the repo's `.git` and the lock; **no network for child
  processes**; kernel-denied `~/.config/gh`, `~/.ssh`, `~/.git-credentials`, `/home/box/agent-data`.
  Deny rules also block `git push`, `gh`, `curl`, `wget`, plain `lake` (builds go through the lock
  wrapper `ctl-build`), `rm -rf`, `sudo`, and edits to the judge, harness, toolchain pins and CI.
- After each round the script records `usage` from the JSON in `ledger.tsv`, runs the judge on the agent's
  branch, merges into `swarm-run` if it passes, and stops everything once `TOKEN_BUDGET` is reached.
- Nothing reaches GitHub automatically. At the end, Ben reviews `swarm-run` and, if he wants, his
  assistant opens **one** PR from it.

Dry run on the box (26 Nov, stub agent in place of `grok`): setup, worktrees, the build lock, two steward
merges per agent with `JUDGE PASS 46/46`, the token-budget stop and the kill switch all worked. A later
1-agent calibration on Ben's workstation (`CALIBRATION.md`) ran a real `grok` session under the
`ctlswarm` sandbox; the deny rules and preflight checks held there.

## 5. Rules for agents

From PyBot, adapted: one focused step per round; read the board first; commit only after `ctl-judge`
prints `JUDGE PASS`; abandoned approaches go in `DEAD_ENDS.md`; posts are one line, at most 1,200
characters; every claim carries a tier (T1–T6); never invent a citation; no network, no GitHub.

## 6. Success criteria

Measured by Ben, not by the swarm:
1. **Win**: a merged Lean theorem deriving T3 from named principles that are *not* T3 in disguise,
   with no `sorry` and standard axioms only, which the red team failed to break within the run.
   The model's score goes back up (F/V not lowered by an after-the-fact principle).
2. **Useful partial**: a precise statement of which extra principle is needed (and a Lean proof that
   it is sufficient), or a Lean counter-model showing T3 is independent of the existing principles.
   A clean refutation counts as a result.
3. **Fail**: no merged theorem beyond restatements, or only vacuous/circular ones (the red team or
   Ben's review decides).
Health metrics (what Legion and the board show): merges per hour, judge pass rate, dead-ends logged,
tokens per agent-hour, cache hit rate.

## 7. Stop rules

- **Tokens:** `TOKEN_BUDGET` (default 3M for the calibration run), checked after every round.
- **Time:** `HOURS` (default 20 min, ceiling 24 h) for the swarm; `ROUND_MIN` (default 20, ceiling 60)
  per round; `--max-turns` (default 30, ceiling 80) per round.
- **Kill switch:** `swarm/grok/launch.sh stop` (touches `STOP`, kills every agent process group).
  Tested with a stub.
- **Stop at once** if an agent tries to reach the network, GitHub or credentials (look in `logs/*.err`),
  if Ben's own bots report running out of usage, or on judge gaming (trivially true theorems).

## 8. What Ben must decide or do

1. **Sign in, himself.** On the box desktop terminal: `grok login --device-auth` (or `grok login` with
   the desktop browser), with the X account whose plan should pay. I must not sign in for him. The
   alternative is an `XAI_API_KEY` from console.x.ai entered through a secret form, which bills per
   token outside the pool.
2. **Accept the pool risk**, or choose the API key instead: the swarm shares the weekly pool with his
   Grok Bot agents, Grok chat and Cursor (`COSTS.md` §4).
3. **Calibration run:** already done, 26 Nov, on the workstation (`CALIBRATION.md`). 1 agent, 17 min,
   `TOKEN_BUDGET=3000000`, produced `ConstructorTheory/Swarm/ThirdTask.lean` (PR #8).
4. **Caps for a real run** (still needs Ben's OK; do not launch from this merge): agents (≤3), hours,
   `TOKEN_BUDGET`. The recommendation from the calibration is 3 agents × 2 h, `TOKEN_BUDGET=70000000`,
   `MAX_TURNS=40`.
5. **PR #6** is now merged into main (`88898c6`, 27 Nov). The launcher's default `BASE_REF` is `origin/main`.

## 9. Risks

| Risk | Mitigation |
|---|---|
| Draining the shared pool and starving Ben's Grok Bot agents | token cap, wall-clock cap, 1-agent calibration with `/usage` before and after, deterministic steward (no model), no subagents, no web search |
| Prompts over 200k tokens (double price on the API) | a fresh session each round; notes file for continuity |
| Box memory (≈2.5 GB free; one build ≈2.5 GB) | one build at a time through `flock`; `nice`; ≤3 agents |
| Agents probing credentials or the network (the PyBot report saw a port scan and token reuse) | Landlock profile with kernel denies and no child network; deny rules; push disabled in the clone; no GitHub token reachable |
| Sandbox silently not applied | Grok prints a warning and records it in the session's `summary.json`; check `logs/*.err` after the first round, and stop if it appears. Custom profiles with `deny` refuse to start without bubblewrap (present on the box) |
| Merge conflicts | new work in `ConstructorTheory/Swarm/<Topic>.lean`; the steward reports conflicts on the board |
| Vacuous or circular theorems that pass the judge | red-team lane; Ben reviews `swarm-run` before anything goes to GitHub |
| CLI changes (Grok Build is updated often) | `--no-auto-update`; installed version 1.0.92 (no model session run yet) |
