# The formalisation gap — method: Bartosz Naskręcki's harness, applied to physics

Ben asked to run the catalogue through the setup of one ecdsa.fail participant: Bartosz, the
leaderboard regular who also appeared on Zero Knowledge. This file says who he is, what his setup
is (as far as public sources show), and how the 22-law catalogue is run through it here.

## Who

**Bartosz Naskręcki**: mathematician at Adam Mickiewicz University, Poznań (Vice-Dean, per his X
bio) and researcher at the Centre for Credible AI.
- X: [@nasqret](https://x.com/nasqret)
- GitHub: [nasqret](https://github.com/nasqret). ecdsa.fail's own API links his submissions to this profile.
- Podcast: [Zero Knowledge episode 416, "When Math Meets Auto Research"](https://zeroknowledge.fm/podcast/416/)
  (11 Nov 2026, with Anna Rose and Tarun Chitra). Eigen Labs' post about the episode tags @nasqret.

**On the ecdsa.fail leaderboard** (`api.ecdsa.fail`, benchmark `1ffb695a…`, read 22 Nov 2026):
- 145 submissions under `nasqret`, the first on 11 Jun 2026.
- 10 of them were accepted as improving the board's best Q×T score, all between 11 and 20 Jun 2026.
  The first was Q=1218, T=1,402,192 (Q×T 1.708×10⁹). The last was Q=1159, T=1,388,180 (Q×T 1.609×10⁹;
  submission `6c1a65d4`).
- From 7 Nov 2026 he worked the low-width line: Q=660 on 7 Nov, then one qubit at a time down to
  Q=646 by 13–14 Nov (e.g. `dbf9f8d7`: Q=646, T=458,940,063). Those runs were officially scored
  but did not beat the product-score best.
- Another team's public harness (Storm, MIT) credits his Q660/Q659 rows of 7–8 Nov for three of
  its skills.

## His setup: what is public

He hasn't published the code of his ecdsa.fail agent loop; I didn't find it. Three public
sources show its shape.

**1. His submission notes** (for example
[#2470](https://github.com/Layr-Labs/ecdsafail-challenge/pull/2470) and
[#3215](https://github.com/Layr-Labs/ecdsafail-challenge/pull/3215)):
- Each note opens with `Model:`. Across his 145 notes the labels are GPT-5 Codex, GPT-5,
  GPT-5.3 Codex, GPT-Codex and `gpt-astra`.
- The notes follow a fixed structure:
  1. **Why this run**: the target and the prior failure.
  2. **Lineage**: the parent submission, with links and credit to the other participants whose work it builds on.
  3. **The mechanism**: the exact identity or pass.
  4. **Boundaries**: what the pass will not touch.
  5. **Evidence and reproduction**: local tests, field-by-field comparison against the parent
     (e.g. "all 1,998,654 output records matched"), basis-state comparisons, and the command to rerun them.
- He also submits **diagnostic runs he expects to fail**. Example: a Q637 circuit "produced the
  wrong point… on shot 925", with the failing input reproduced independently in Python.
- The protected evaluator always decides the score: "the complete official run determines the score".

**2. His public research harness,
[labyrinth-exploration](https://github.com/nasqret/labyrinth-exploration)** (MIT, Oct 2026). It is
an agent skill for Codex and Claude Code that he built on a pure-mathematics programme in
Sep–Oct 2026, not on ecdsa.fail. Its core:
- **A map**:
  - `knowledge.json` (results, conjectures, hunches, open doors, dead ends)
  - `events.jsonl` (an append-only log)
  - `sota.json` (best known results, with their history)
  - a dashboard built by `lab.py`
- **Tiers T1–T6**, from proved in the literature down to hunch. "Nothing below T3 is ever cited as a fact."
- **The loop**: read the frontier → explore → predict boldly, with the test → test and log at once
  → referee → update the map → look for shortcuts.
- **Dead ends**: a refutation becomes a dead end with a one-line lesson. It counts as progress.
- **Independent referees** with their own code.
- **An escalation ladder** for when the map stops changing.
- **Campaigns** of attack, referee and writer agents.

His 9 Oct 2026 post adds that "numerical evidence goes into separate part of the knowledge base
and another subagent generates and curates conjectures to prove".

**3. How others describe him.** The [Storm skills](https://github.com/odinfree/storm-ecdsa-harness)
credit "nasqret (Bartosz Naskręcki)" with "broad qubit sweeps and memory-mechanism
recombination". Its `nasqret-playbook` is written as inspired by his public behaviour, not as
copied code. That playbook:
- diffs adjacent public winners;
- names their mechanisms and builds a route slate;
- runs equal-size pilots and sorts each route as tail-sensitive, structurally dirty, score-dead
  or validation-ready;
- spends compute only on validation-ready routes;
- writes negative evidence back to memory so that dead lanes stay dead.

## The catalogue, run through his setup

| His setup | Here (files) |
|---|---|
| The protected evaluator decides, not the agent | `lake build` in CI plus `harness/run_checks.py`. For each cited Lean result, the axiom audit must show only `propext`, `Classical.choice` and `Quot.sound` |
| Two independent implementations must agree | `build_map.py` holds the 22-law table in Python. It is cross-checked row by row against the Lean `catalogue`, and Lean proves the counts by `decide` |
| `results.tsv` row: timestamp, commit, OK/FAIL, metrics, note | `harness/results.tsv`: timestamp, commit, item, OK/FAIL, axioms, note |
| Dead end + one-line lesson | Each classical law is a `deadend` node (`x.<law>`) whose lesson names the failed assumption |
| Bold conjecture, with its test | Each pattern P1–P6 and Ben's thesis is a T5 `conjecture`. Its test is "find a law whose failure is not explained by P1–P6" |
| Tiers; nothing below T3 cited as fact | Lean results are T2 (kernel-checked, no human referee yet). Patterns are T5. "Quantum theory has the same flaw" is a T6 hunch |
| Lineage and credit in every note | Every node links its source. `SOURCES.md` lists them. Vendored code keeps its licence |
| Diagnostic failures published honestly | The "Not formalised" list in `PATTERN.md` and the open doors in the map (`q.nocloning-hilbert`, `q.bell`, `q.planck`) |
| Route slate, then spend only on validation-ready routes | The doors are ranked by how cheaply Lean can check them. CHSH ≤ 2 is finite and decidable, so it comes first |
| `lab.py check` / `build` / `event` | `labyrinth/lab.py`, vendored unmodified from labyrinth-exploration (MIT, © 2026 Bartosz Naskręcki) |

To run it: `lake build && python3 harness/run_checks.py --note "what I tried"`. That appends
`results.tsv` rows, logs a `monitor` event and rebuilds `labyrinth/STATUS.md` and the dashboard.
CI currently runs `lake build` only. Adding the verifier to CI means editing the workflow, which the box's GitHub token can't do (no `workflow` scope). The two-step snippet is in `harness/README.md`.

## What this does and doesn't claim

The harness checks the **formal** claims and the consistency of the classification. It can't
check the physics of a row: for that, the evidence is the cited experiment (tier T1, standard).
The patterns stay conjectures (T5). His method's rule applies: a pattern gets promoted only when
it survives an attempt to break it.

The earlier ecdsa.fail-only framing (frozen harness, Fiat–Shamir test inputs, reversibility
gates) still holds as background. ecdsa.fail's reversibility gate is itself a quantum law, see P4.
