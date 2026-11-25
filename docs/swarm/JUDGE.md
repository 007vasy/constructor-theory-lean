# The judge

`swarm/judge.sh [BASE_REF]` (default `origin/main`) is the fixed evaluator. A PR merges only if
it prints `JUDGE PASS` on the PR's head. It is the Lean analogue of PyBot's "beat main on the deck".

## Checks, in order

1. **Frozen files.** The diff against the base must not touch `swarm/judge.sh`,
   `harness/run_checks.py`, `lakefile.toml`, `lean-toolchain`, `lake-manifest.json` or `.github/`.
   (So the toolchain and Mathlib pin cannot be changed by an agent, and the judge cannot be edited.)
2. **No escape hatches.** No `sorry`, `admit` or `axiom` declaration anywhere in
   `ConstructorTheory.lean` or `ConstructorTheory/**` (comments and docstrings are ignored).
3. **Build.** `lake build` succeeds with no "declaration uses 'sorry'" warning.
4. **Axiom audit.** `python3 harness/run_checks.py --no-log` exits 0: every theorem cited in
   `harness/build_map.py` exists and depends only on `propext`, `Classical.choice`, `Quot.sound`;
   and the Python catalogue table equals the Lean `catalogue`.
5. **No regression.** Compared with the base: no catalogue row and no cited theorem is removed, and
   no row changes its name or tags unless its slug is explained in `docs/swarm/CHANGES.md`.

Output on success, to paste into the PR description:

```
JUDGE PASS: build ok, run_checks 46/46 OK, base 9a191bb, head 0c9adf2
```

## Tested on the box (26 Nov 2026)

- `main` (9a191bb) against itself: `JUDGE PASS`, 28/28 OK, about 43 s with the Mathlib cache.
- PR #6's branch `next-steps` (0c9adf2) against main: `JUDGE PASS`, rows 22 → 23, cited
  theorems 27 → 45, 46/46 OK, about 42 s.
- A theorem proved `by sorry`: `JUDGE FAIL` at check 2.
- A branch that edits `swarm/judge.sh`: `JUDGE FAIL` at check 1.

## What the judge does not catch

- **Vacuous or circular theorems.** A theorem can be true because the definitions make it true.
  That is what the red-team lane and Ben's review are for.
- **Uncited theorems.** Check 4 audits only theorems listed in `LEAN_THEOREMS`; check 2 still bans
  `sorry` and `axiom` everywhere, and the steward adds new theorems to the list hourly.
- **`native_decide` / `maxHeartbeats 0`.** Banned by the prompt, not yet by the judge. `native_decide`
  shows up in the axiom audit as `Lean.ofReduceBool`, so cited uses fail check 4.
