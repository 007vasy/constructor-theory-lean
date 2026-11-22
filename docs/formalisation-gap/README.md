# The formalisation gap

Ben's question: *which physics equations break down at the quantum level, and why?* This
answers it with the harness of Bartosz Naskręcki (@nasqret, an ecdsa.fail leaderboard
participant), with Sam Kuypers' drop-of-water essay as the worked example.

- `THESIS.md`: Ben's thesis, that the breakdown shows the mathematical description is incorrect, developed with fact/interpretation labels
- `QNUMBER.md`: q-number (operator) restatement of all 22 laws: 18 established, 3 partial/open, 1 speculative (gravity)
- `CT_LITERATURE.md`: constructor-theory papers that restate laws (verified links) and the common restatement pattern
- `CT_RESTATEMENT.md`: constructor-theoretic restatement of all 22 laws: 7 published, 3 derived, 8 conjecture, 4 not expressible yet; quantitative content is lost in every row
- `METHOD.md`: who Bartosz is, his setup (submission notes, labyrinth-exploration, sweeps), and how the catalogue is run through it
- `CATALOGUE.md`: 22 classical laws, each with regime, replacement, failed assumption and tags
- `PATTERN.md`: the six breakdown patterns, the single underlying reason, Kuypers' droplet, and the constructor-theory reading
- `SOURCES.md`: links and references
- Lean: `ConstructorTheory/FormalisationGap.lean`, `ConstructorTheory/QNumber.lean` and `ConstructorTheory/CTRestatement.lean` (no `sorry`, no new axioms)
- Harness: `harness/` (`build_map.py`, `run_checks.py`, `results.tsv`) and the map in `labyrinth/` (`knowledge.json`, `events.jsonl`, `sota.json`, `STATUS.md`)

Run it with `lake build && python3 harness/run_checks.py --note "what I tried"`.
