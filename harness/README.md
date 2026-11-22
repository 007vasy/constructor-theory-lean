# Harness for the formalisation gap

This follows Bartosz Naskręcki's setup (see `docs/formalisation-gap/METHOD.md`).

- `build_map.py` holds the 22-law table and the list of cited Lean results. It cross-checks the
  table against the Lean `catalogue` and writes `labyrinth/knowledge.json` and `labyrinth/sota.json`.
- `run_checks.py` is the verifier. It audits the axioms of every cited Lean theorem (only
  `propext`, `Classical.choice` and `Quot.sound` are allowed) and re-runs the cross-check. It then
  appends OK/FAIL rows to `results.tsv`, logs a `monitor` event and rebuilds the map.
- `../labyrinth/lab.py` is vendored unmodified from
  [nasqret/labyrinth-exploration](https://github.com/nasqret/labyrinth-exploration) (MIT,
  © 2026 Bartosz Naskręcki; see `LICENSE-labyrinth-exploration`).

Run:

```bash
lake build
python3 harness/build_map.py          # only after editing the table
python3 harness/run_checks.py --note "what I tried"
python3 labyrinth/lab.py check
```

To add the verifier to CI, append to `.github/workflows/ci.yml` (this needs a token with
`workflow` scope):

```yaml
      - name: Labyrinth map check
        run: python3 labyrinth/lab.py check
      - name: Formalisation-gap verifier
        run: |
          export PATH="$HOME/.elan/bin:$PATH"
          python3 harness/run_checks.py --no-log
```
