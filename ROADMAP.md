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

## Related, not in this three-paper queue

Constructor theory of time — David Deutsch and Chiara Marletto,
[arXiv:2505.08692](https://arxiv.org/abs/2505.08692) (v1 13 May 2025; current
v3 5 June 2026); published 11 November 2026 as
[J. Phys. Commun. 10 115003](https://doi.org/10.1088/2399-6528/aebd39).

This is a better constructor-theoretic sequel than M3 or M4. It uses the
milestone 1 vocabulary (tasks, possibility, the composition principle,
attributes, isolated substrates) to show how timers and then dynamics can
emerge from timeless laws. A natural later milestone, after M2: formalize the
null task, prove it possible from composition, define timers via start /
running / halt attributes, and state the equal-duration conditions.
