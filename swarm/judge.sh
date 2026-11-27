#!/usr/bin/env bash
# Swarm judge for constructor-theory-lean. A PR may merge only if this exits 0.
# Usage: swarm/judge.sh [BASE_REF]   (default: origin/main)
# It is a fixed evaluator: agents must not edit it, harness/, lakefile.toml, lean-toolchain
# or lake-manifest.json (check 1 enforces that). See docs/swarm/JUDGE.md.
set -uo pipefail
BASE="${1:-origin/main}"
ROOT="$(git rev-parse --show-toplevel)"; cd "$ROOT"
export PATH="$HOME/.elan/bin:$PATH"
fail() { echo "JUDGE FAIL: $*"; exit 1; }
git rev-parse --verify -q "$BASE" >/dev/null || fail "base ref $BASE not found (git fetch origin first)"

# 1. Protected files: the judge, the verifier, the toolchain and the dependency pins.
PROTECTED='^(swarm/judge\.sh|harness/run_checks\.py|lakefile\.toml|lean-toolchain|lake-manifest\.json|\.github/)'
CHANGED="$(git diff --name-only "$BASE"...HEAD | grep -E "$PROTECTED" || true)"
# Bootstrapping: when the base predates the judge, adding the judge itself is allowed.
git cat-file -e "$BASE:swarm/judge.sh" 2>/dev/null || CHANGED="$(echo "$CHANGED" | grep -v '^swarm/judge\.sh$' || true)"
[ -z "$CHANGED" ] || fail "protected files changed: $(echo $CHANGED)"

# 2. No sorry / admit / new axioms in the Lean sources (comments and docstrings stripped).
python3 - <<'PY' || fail "sorry, admit or a new axiom in ConstructorTheory/"
import re, glob, sys
bad = []
for f in ["ConstructorTheory.lean"] + sorted(glob.glob("ConstructorTheory/**/*.lean", recursive=True)):
    src = open(f, encoding="utf-8").read()
    src = re.sub(r"/-.*?-/", lambda m: "\n" * m.group(0).count("\n"), src, flags=re.S)  # block comments, docstrings
    for i, line in enumerate(src.splitlines(), 1):
        code = line.split("--", 1)[0]
        if re.search(r"(^|[^A-Za-z0-9_.'])(sorry|admit)([^A-Za-z0-9_']|$)", code) or re.match(r"\s*((private|protected|unsafe|noncomputable)\s+)*axiom\s", code):
            bad.append(f"{f}:{i}: {line.strip()}")
print("\n".join(bad)); sys.exit(1 if bad else 0)
PY

# 3. The library builds, with no sorry warnings.
LOG="$(mktemp)"
lake build >"$LOG" 2>&1 || { tail -30 "$LOG"; fail "lake build failed"; }
grep -q "declaration uses 'sorry'" "$LOG" && fail "build reports a declaration using sorry"
# 3b. `lake build` only builds what the root module imports. Build every changed .lean module too,
#     so a new file that is not yet imported is still compiled (and cannot pass vacuously).
for f in $(git diff --name-only --diff-filter=AM "$BASE"...HEAD -- 'ConstructorTheory/*.lean'; \
           git ls-files --others --exclude-standard -- 'ConstructorTheory/*.lean'); do
  [ -f "$f" ] || continue
  mod="$(echo "${f%.lean}" | tr '/' '.')"
  lake build "$mod" >"$LOG.mod" 2>&1 || { tail -30 "$LOG.mod"; fail "lake build $mod failed"; }
  grep -q "declaration uses 'sorry'" "$LOG.mod" && fail "$mod: declaration uses sorry"
done

# 4. Verifier: every cited theorem uses only propext, Classical.choice, Quot.sound,
#    and the Python table matches the Lean catalogue.
python3 harness/run_checks.py --no-log >"$LOG.checks" 2>&1
RC=$?
OK=$(grep -cP '\tOK\t' "$LOG.checks"); ALL=$(grep -cP '\t(OK|FAIL)\t' "$LOG.checks")
[ $RC -eq 0 ] || { grep -P '\tFAIL\t' "$LOG.checks"; fail "run_checks: $OK/$ALL OK"; }

# 5. No regression against BASE: no catalogue row and no cited theorem may disappear,
#    and no row may change its name or tags unless docs/swarm/CHANGES.md says why.
BASEDIR="$(mktemp -d)"
git show "$BASE:harness/build_map.py" >"$BASEDIR/build_map.py" || fail "cannot read base build_map.py"
python3 - "$BASEDIR" <<'PY' || exit 1
import importlib.util, sys, pathlib
def load(path, name):
    spec = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(spec)
    try:
        spec.loader.exec_module(m)
    except SystemExit:
        pass
    return m
base = load(pathlib.Path(sys.argv[1]) / "build_map.py", "base_map")
head = load(pathlib.Path("harness/build_map.py"), "head_map")
bl = {l[0]: (l[1], sorted(l[5])) for l in base.LAWS}
hl = {l[0]: (l[1], sorted(l[5])) for l in head.LAWS}
bt = {t[0] for t in base.LEAN_THEOREMS}; ht = {t[0] for t in head.LEAN_THEOREMS}
gone = sorted(set(bl) - set(hl)); lost = sorted(bt - ht)
changed = sorted(k for k in set(bl) & set(hl) if bl[k] != hl[k])
justified = pathlib.Path("docs/swarm/CHANGES.md").read_text() if pathlib.Path("docs/swarm/CHANGES.md").exists() else ""
unjust = [k for k in changed if k not in justified]
if gone or lost or unjust:
    print(f"JUDGE FAIL: regression: rows removed {gone}, theorems removed {lost}, rows changed without a CHANGES.md entry {unjust}")
    sys.exit(1)
print(f"rows {len(bl)} -> {len(hl)}, cited theorems {len(bt)} -> {len(ht)}, rows changed (justified) {changed}")
PY
echo "JUDGE PASS: build ok, run_checks $OK/$ALL OK, base $(git rev-parse --short "$BASE"), head $(git rev-parse --short HEAD)"
