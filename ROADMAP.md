# Roadmap

Lean 4 formalization of Constructor Theory (Deutsch–Marletto), repo
[`007vasy/constructor-theory-lean`](https://github.com/007vasy/constructor-theory-lean).

This file records milestone 1 and the paper queue after it. Order is by how well
each paper fits a Lean formalization of constructor theory itself, not by
scientific importance alone. Sources were checked on 21 November 2026
(Australia/Melbourne).

## Milestone 1 — Core vocabulary (in progress)

Define the basic language of constructor theory in Lean 4, with a mapping table
from each definition and axiom to the sentence in the Deutsch–Marletto papers
it encodes:

- substrate, attribute, task, constructor
- possible versus impossible
- a composition theorem for possible tasks
- README, NOTES, and the mapping table

A coding agent is working on this on a branch. It has not yet been merged to
`main`.

## After milestone 1 — paper queue

### M2 (next): Constructor Theory as Process Theory

- Stefano Gogioso, Vincent Wang-Maścianica, Muhammad Hamza Waseem, Carlo Maria
  Scandolo, and Bob Coecke
- [arXiv:2401.05364](https://arxiv.org/abs/2401.05364) (14 December 2023);
  also [EPTCS 397 (2023), pp. 137–151](https://doi.org/10.4204/EPTCS.397.9)
  (Applied Category Theory 2023)
- **Note.** Closest existing bridge to Lean. Conceivable tasks live in `Rel`,
  the symmetric monoidal category of sets and relations; possible tasks are
  those implemented by a catalytic constructor in a process theory (a strict
  SMC). Mathlib already has symmetric monoidal categories, so this is the
  natural place to give milestone 1 a concrete, compositionally sound model.
- **Lean targets.** Encode a choice of substrates `(C, Σ, Γ)` and the paper's
  definition of a possible task (constructor object, preserved attribute,
  task-inducing process). Prove that sequential and parallel composition of
  possible tasks remain possible, in the sense of the paper. Formalize
  attributes as antichains and the coarse-graining results (Proposition 4.3
  and the embeddings in Remarks 4.4–4.5): coarse-grained tasks form an SMC,
  and state-based tasks embed into them.

### M3: Universal quantum theory from dynamical consistency

- Chiara Marletto and Vlatko Vedral
- [arXiv:2608.17688](https://arxiv.org/abs/2608.17688) (18 August 2026)
- **Note.** A Hamiltonian consistency argument, not a constructor-theoretic
  reconstruction. If one sector is quantum, joint unitary dynamics that
  preserve the canonical algebra rule out treating the other sector as
  classical. Applied to linear gravity coupled to quantized electromagnetism
  or matter. Scientifically close to the quantum-gravity programme, but it
  needs quantum kinematics (CCRs, Heisenberg evolution) more than the
  milestone 1 vocabulary, so it comes after the process-theory model.
- **Lean targets.** Start with a finite-dimensional or Weyl-algebra toy of two
  coupled oscillators, not unbounded operators on infinite-dimensional Hilbert
  space. Prove a schematic no-go: if oscillator 1 has a non-commuting
  `[x, p]`, and the joint dynamics are of the paper's first coupling form,
  then oscillator 2 cannot be represented by commuting c-numbers if the
  equal-time CCR of oscillator 1 is to be preserved. Leave the continuum and
  field cases as later stretch goals.

### M4 (conditional): The Boundary of the Possible

- The Institute for Applied Ontological Mathematics (IAOM). A July 2026
  ResearchGate posting also lists Richard Goodman. Self-published preprint;
  not peer reviewed.
- [Zenodo record 23303926](https://zenodo.org/records/23303926),
  DOI [10.5281/zenodo.23303926](https://doi.org/10.5281/zenodo.23303926),
  posted 11 October 2026 (PDF dated July 2026)
- **Note.** Technically closest in spirit to an executable Lean model: tasks
  are demanded transformations of Lafont interaction nets; possible iff local
  rewrites realize the demand; impossible iff a conserved quantity forbids
  it. It cites Deutsch–Marletto and the 2026 survey *Tests of constructor
  theory* (arXiv:2606.07352), and claims Lean-checked theorems for the
  "ultimate law", no-cloning, duration, a universality threshold, and Born-rule
  necessity. Treat these claims as unverified until the Lean sources are
  public. The paper withholds the proofs and asks the reader to trust a
  cryptographic hash; IAOM is a new Michigan institute (incorporated May 2026)
  and its reports are not journal-refereed. Do not start this milestone until
  the formalization can be inspected independently.
- **Lean targets (only after sources are public).** Interaction-net substrate
  and rewrite relation; impossibility criterion (conserved invariant);
  task distance as a pseudometric; co-Heyting boundary operator; the adjacency
  form of the ultimate law (every possible task has an impossible neighbour at
  distance one). Compare each definition with the Deutsch–Marletto mapping
  table from milestone 1 before taking any theorem as a theorem of constructor
  theory.

## Closing the gap (side track, opened 22 Nov 2026)

See `docs/formalisation-gap/CLOSING_THE_GAP.md`. Done: breakdown schema, finite
distinguishability ⇔ discreteness for deterministic theories, two-qubit superinformation,
Planck factor (`ConstructorTheory/ClosingTheGap.lean`). Next:

- Derive finite distinguishability from a quantum speed limit (Mandelstam–Tamm /
  Margolus–Levitin) in a finite-dimensional Hilbert-space `Theory`, so the chosen model rests
  on one principle.
- Try to refute the model on the identical-particle rows (Maxwell–Boltzmann, Gibbs).
- A cost-valued (quantitative) possibility predicate, for rates and coefficients.

## Candidate law from gravity: finite distinguishability of a bounded causal diamond (opened 27 Nov 2026)

Source: Venkatesa Chandrasekaran, *An algebraic quantization of gravity from the null cone*,
[arXiv:2611.34924](https://arxiv.org/abs/2611.34924) (23 Nov 2026). Full CT restatement:
[`docs/reformulations/null-cone-quantization-CT.md`](docs/reformulations/null-cone-quantization-CT.md).
**Depends on PR #6** (branch `next-steps`: `SpeedLimit.lean`, `orthogonal_family_finite`), which is
not yet on `main`.

- **Candidate law L-NC1.** For a macroscopic causal diamond `D` whose gravitational clock reading
  is at most `ℓ` (in D&M terms: whose light-ray timer has halted by a timer of class `C_ℓ`),
  perfectly distinguishing infinitely many attributes is impossible.
  - Paper: `H_D = 1[0,ℓ(D)](ū*) H_ω` ((5.1)–(5.2)) is finite-dimensional ((5.38)–(5.39c), §5.2,
    App. D.2). The area spectrum is discrete (5.40) and bounded by `A ≤ 4πℓ(D)²/(1−ε)²` (5.21d).
  - Scope: only around a smooth background, with `ℓ_P ≪ Δu ≪ d ≪ b ≪ R_c` (5.26). Footnote 22
    extends this only to shorter clock intervals.
- **Ties to forbidden task (b) / `SpeedLimit.lean`.** `orthogonal_family_finite` proves FD *given*
  a finite-dimensional bounded subspace, and flags that proviso as an assumption about the
  Hamiltonian. L-NC1 **would conditionally discharge** the proviso, with size (a duration) as the
  resource instead of energy. The conditions: the one-loop input (5.27)–(5.29), the heuristic step
  (footnote 18), and a fixed `ω` (footnote 20).
- **Assumed by the paper (not proved).**
  - Diffeomorphism invariance of the path integral: amplitudes must not depend on where, or
    whether, a cut is made (abstract, Fig. 28, (4.29), App. E axiom 1). This is the most
    CT-friendly input: a timeless consistency condition on composition.
  - 4D vacuum GR only (3.19), so no matter.
  - A chosen Gaussian state (4.7) and a chosen pure extension `ω` (4.16). This is a question of
    reference-state / representation dependence.
- **Not proved in general.** An explicit bound `dim H_D ≲ exp(πℓ²/((1−ε)²ℓ_P²))`. The paper has it
  only asymptotically, for large black-hole interiors ((5.64), footnote 24), plus a one-loop
  per-area bound (D.46c). It stays a conjecture: L-NC2.
- **Variation test.** In 2D JT gravity, a bounded diamond has infinitely many orthogonal states
  ((2.14)–(2.17)). FD therefore needs 4D shear–focusing.
- **Lean target.** The statements are written out in the doc (§7). They were type-checked without
  `sorry` in a scratch build, against verbatim copies of `FDOn` and `orthogonal_family_finite`:
  - `NullConeDiamond.fd`, i.e. `FDOn` from a `finiteDim` hypothesis;
  - `jt_not_fd`, i.e. FD fails for an ℓ²(ℕ) stand-in.

  Move them into the repo once PR #6 merges. All the physics sits in the `finiteDim` hypothesis.

### Retry with a future model (null-cone CT reformulation)

Redo the CT reformulation and the Lean formalization above with a stronger model. This pass could
not do the following:
- re-verify every equation reference against the typeset PDF (the review spot-checked about 30
  and found them correct);
- derive §5.2 finiteness from CT principles instead of translating it. The natural starting point
  is the paper's axiomatic Lorentzian formulation (App. E: E.1–E.5, the Euclidean equivalence in
  E.2, and the realisation in E.3, which uses `d_D < ∞` (E.17));
- find a non-asymptotic explicit bound on `dim H_D`. (5.21d) bounds only the area;
- replace the ℓ²(ℕ) stand-in with the actual JT space `L²([0,ℓ]) ⊗ H_φ` (2.13c);
- connect L-NC1 to the timer vocabulary below (a light-ray timer as a `Timer` instance);
- extend to matter, to test whether anything follows for the Marletto–Vedral witness or BMV rates.

## Candidate milestone: constructor theory of time (timers, null constructors)

David Deutsch and Chiara Marletto, *Constructor theory of time*,
[arXiv:2505.08692](https://arxiv.org/abs/2505.08692) (v1 13 May 2025; v3 June 2026), published 11
November 2026 as [J. Phys. Commun. 10 115003](https://doi.org/10.1088/2399-6528/aebd39). Read in
full (arXiv v3, §§1–9).

This replaces the earlier one-paragraph mention under "Related". It is a better constructor-theoretic
sequel than M3 or M4, because it uses only the milestone 1 vocabulary. It is also the bridge that
lets L-NC1 measure diamond size as a *duration*: see §5 of the null-cone doc, which maps the
light-ray clock (3.27), with `Ξ ≥ 0` (3.26c), onto D&M timers.

- **Provable now from the repo** (the null-task lemma was checked in a scratch build).**
  - D&M §5's argument that the null task is possible. Under `SerialCompositionPrinciple`, if
    `{a → b}` and `{c → d}` are possible with `b ≠ c`, then their serial composite is
    `Task.empty S` and is possible. The repo's `serial` matches on attribute *equality*, so
    `b ≠ c` suffices. This is weaker than D&M's `b ∩ c = ∅`.
  - Note that `Possible.empty_of_nonempty` already makes the empty task trivially possible on any
    substrate that has a constructor. The repo's empty task is per substrate, whereas D&M's null
    task "has no substrate". Record the mismatch.
- **Definitions to add.**
  - `Timer`: a substrate with attributes `zero`, `run`, `one` and a halt flag, with
    `zero, run, one` pairwise disjoint and the halt flag distinguishable (via `readout` /
    `PerfectlyDistinguishes`).
  - The composite `[C_t ⊕ C_t']_t` on the product substrate.
  - "Same duration" as the relation given by D&M (9).
- **Assumed (hypotheses, as `Prop`s like the composition principles).**
  - Isolation: the possibility of tasks on `S` depends only on `S`'s attributes. This needs a
    notion of environment that the repo lacks.
  - Staticity of `one`.
  - D&M conditions (8) and (9) for a family `C_t`.
  - The synchrony of isolated identical timers, which D&M derive informally from isolation.
- **Provable from those hypotheses.**
  - "Same duration" is an equivalence relation.
  - Durations are labels of its classes.
  - Synchrony gives `(x,x) → (y,z)` impossible for `y ≠ z` on `C ⊕ C`.
  - A toy model, such as a counter with Poincaré-style recurrence (D&M footnote 3), that satisfies
    the conditions only approximately. This would show they are not vacuous.
- **Not formalizable yet.** Dynamics as a limit of timer-relative increments (D&M (10)–(11)) needs
  the cost-valued possibility predicate from "Closing the gap" and a metric on attributes.
