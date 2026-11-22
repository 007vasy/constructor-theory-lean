# Constructor theory in Lean

A Lean 4 formalization of constructor theory, the programme of David Deutsch and
Chiara Marletto in which physical laws are statements about which tasks are
possible and which are impossible, rather than dynamical laws plus initial
conditions.

Sources for the vocabulary:

- David Deutsch, “Constructor theory”, *Synthese* 190 (2013), 4331–4359.
  [arXiv:1210.7439](https://arxiv.org/abs/1210.7439).
- David Deutsch and Chiara Marletto, “Constructor theory of information”,
  *Proceedings of the Royal Society A* 471 (2015), 20140540.
  [arXiv:1405.5563](https://arxiv.org/abs/1405.5563).

This repository is milestone 1: the core vocabulary, the algebra of tasks, and
the first theorems about possibility. It is not a reconstruction of quantum
theory, and it does not yet treat information, locality, or no-signalling.
Modelling choices, the split between theorems and hypotheses, and a proposal
for milestone 2 are in [`NOTES.md`](NOTES.md).

## Milestone 1

- A substrate is a type of states. An attribute is a set of states. A task is a
  set of input-attribute to output-attribute pairs.
- A constructor is a reusable witness that performs a task in the exact limit
  of arbitrarily high accuracy. A task is possible when some constructor
  performs it, and impossible otherwise.
- Serial and parallel composition of tasks are defined. Associativity, units,
  transpose, subtasks, disjoint inputs, and the interchange law are proved.
- “Possible tasks compose” is not a theorem. It is stated as two hypotheses
  (the serial and parallel composition principles). Under those hypotheses,
  chains of tasks and both schedules of a parallel-serial composite are
  possible. Countermodels show that neither principle follows from the
  definitions, and that the transpose of a possible task need not be possible.

There is no `sorry` and no Lean `axiom`. The composition principles are
`Prop`s, assumed in the theorems that need them.

## Requirements

- [elan](https://github.com/leanprover/elan), the Lean version manager.
- The repository pins the toolchain in `lean-toolchain`
  (`leanprover/lean4:v4.36.0`) and Mathlib at `v4.36.0`.

Install elan (Linux or macOS):

```sh
curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh
```

Restart the shell, or `source "$HOME/.elan/env"`, so that `lake` is on `PATH`.
Windows builds can use the [elan installer](https://github.com/leanprover/elan).

## Build

From a clone of this repository:

```sh
lake exe cache get   # download Mathlib’s precompiled .olean files
lake build
```

`lake exe cache get` needs network access the first time. It fetches the
dependencies recorded in `lake-manifest.json` and the Mathlib build cache.
`lake build` then compiles this project. The cache step is what makes the
Mathlib dependency practical; building Mathlib from source is unnecessary.

Continuous integration (`.github/workflows/ci.yml`) runs the same build with
[`leanprover/lean-action`](https://github.com/leanprover/lean-action).

## Layout

| Path | Contents |
| --- | --- |
| `ConstructorTheory.lean` | Root import. |
| `ConstructorTheory/Basic.lean` | Substrates, attributes, tasks, serial and parallel composition, transpose, subtasks. |
| `ConstructorTheory/Algebra.lean` | Theorems about that algebra. No notion of possibility. |
| `ConstructorTheory/Possibility.lean` | Constructors, `Possible` / `Impossible`, composition principles, and the theorems that use them. |
| `ConstructorTheory/Models.lean` | Consistency and independence models. |
| `ConstructorTheory/FormalisationGap.lean` | The formalisation gap: breakdown-assumption table, finite substrate vs continuum (Kuypers' droplet), distinguishability needs disjointness. |
| `docs/formalisation-gap/` | The formalisation gap: Ben's thesis, catalogue of 22 classical laws that fail at the quantum level, the common pattern, method (Bartosz Naskręcki's harness), sources. |
| `harness/` | Verifier for the formalisation gap: `run_checks.py` (Lean axiom audit, OK/FAIL rows to `results.tsv`) and `build_map.py` (table cross-checked against Lean). |
| `labyrinth/` | The labyrinth map (Naskręcki's labyrinth-exploration, MIT): `knowledge.json`, `events.jsonl`, `sota.json`, `STATUS.md`, `lab.py`. |
| `NOTES.md` | Modelling choices and the milestone 2 proposal. |
| `MAPPING.md` | Each definition and theorem against a sentence from the source papers. |

Names live in the `ConstructorTheory` namespace (`Task`, `Attribute`, `Theory`),
because Lean 4 already uses `Task` for futures. Open `ConstructorTheory` and
`ConstructorTheory.Task` to use the notation:

| Notation | Meaning |
| --- | --- |
| `A ⊑ B` | `A` is a subtask of `B`. |
| `A ⊚ B` | Perform `A`, then `B`. |
| `A ⊗ B` | Perform `A` and `B` on the product substrate. |
| `Aᵀ` | Transpose: swap input and output. |

## License

Apache License 2.0. See [`LICENSE`](LICENSE).
