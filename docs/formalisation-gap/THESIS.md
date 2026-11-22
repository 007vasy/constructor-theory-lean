# The formalisation gap — Ben's thesis

> "The fact that there are mathematical description of phenomenon breaking down at the quantum
> level suggests that the mathematical description is incorrect." (Ben)

In the map this is `k.ben-thesis`, a T5 conjecture with a test. Each claim below is labelled
**[fact]** (established physics or mathematics), **[Lean]** (proved in this repository) or
**[interpretation]** (argued, not established).

## 1. Classical laws are false, not just incomplete

- **[fact]** Each of the 22 laws in `CATALOGUE.md` gives wrong numbers in a regime nature
  actually reaches: black-body spectra, heat capacities, Stern–Gerlach, Bell tests, droplet
  pinch-off. Several predict infinities where nature is finite.
- **[fact]** In their own regime they are excellent. They come back as limits of the
  replacement theory (ħ → 0, large N, ħω ≪ k_BT).
- **[interpretation]** So they are **false but emergent**: good explanations at one level,
  strictly false as fundamental laws. This is Popper and Deutsch's fallibilism. Kuypers, in
  ["Seeing Isn't Believing"](https://samuelkuypers.substack.com/p/seeing-isnt-believing), makes
  the same point with a drop of water: classical fluid theory "is false, but we still use it",
  and predictive success is not truth.

## 2. The error is in what the mathematics assumes exists, not in the calculus

- **[fact]** Calculus, linear algebra and probability survive. Quantum theory uses all of them.
  So do the symmetry and conservation structure (`CATALOGUE.md`, "What is not in the list").
- **[interpretation]** What fails is the **ontology encoded in the choice of mathematics**:
  - a state is a point in a continuum (P1, P6);
  - all observables are jointly sharp (P2);
  - states are unlimitedly distinguishable and copyable (P4, P5);
  - correlations come from local pre-set values (P3).

  Choosing ℝ-valued phase-space coordinates *is* the physical claim that these properties hold.
- **[Lean]** A finite substrate can't carry a continuum-valued sharp variable
  (`no_continuum_info_variable_of_finite`). A real quantity on finitely many states misses every
  interval (`finite_substrate_misses_interval`, Kuypers' droplet). In a deterministic theory,
  attributes can be told apart only if they are disjoint (`distinguish_impossible_of_overlap`).
  These are toy results. They show the **assumption itself** has formal content that can be
  checked, separately from any dynamics.
- **[interpretation]** Divergences are where this is visible: the mathematics reports that its
  own ontology has run out. That is the Rayleigh–Jeans infinity, the radiative collapse of
  atoms, and the singular neck at pinch-off.

## 3. The same argument applies to quantum theory

- **[fact]** Quantum field theory needs regularisation and renormalisation. The unregulated
  theory diverges at short distances, as Kuypers notes, citing Wallace,
  ["The quantum theory of fields"](https://philsci-archive.pitt.edu/15296/1/qm-continuum%20revised.pdf).
  General relativity predicts singularities. No accepted theory combines the two at the Planck
  scale.
- **[fact]** Standard quantum theory still uses continuous structure: complex amplitudes in a
  continuous Hilbert space, continuous time, and a smooth background spacetime in QFT.
- **[interpretation]** By Ben's argument, the divergences of QFT and GR suggest that *their*
  encoded assumptions are wrong too: continuum spacetime, perhaps exact complex amplitudes,
  perhaps more. This is the T6 hunch `h.quantum-also` in the map. It is a direction, not a claim.
- **[fact]** No experiment so far contradicts quantum theory's predictions. So this is an
  argument from explanatory defects (infinities, cutoffs), not from failed predictions. That is
  exactly Kuypers' distinction.
- **[interpretation]** BMV matters here because it tests one encoded assumption directly:
  whether gravity can mediate entanglement, i.e. whether it shares P2/P4 non-classicality.

## 4. Constructor theory is one attempt at laws without these assumptions

- **[fact]** Constructor theory (Deutsch 2013; Deutsch & Marletto 2015) states laws as which
  tasks are possible or impossible. Its principles of information (interoperability,
  distinguishability, impossibility of cloning superinformation) don't presuppose a continuum,
  phase-space points or a Hilbert space.
- **[interpretation]** That makes it a natural language for Ben's thesis. Each classical
  breakdown becomes a law that **assumed a task was possible** when it isn't: resolve energy
  ever more finely, read q and p together, copy any state, label identical particles. The Lean
  library's `Impossible` is the formal home for those statements.
- **[fact]** Constructor theory hasn't yet derived ħ, Planck's law or the Hilbert-space
  formalism. Marletto & Vedral's 2026 dynamical-consistency paper (ROADMAP item 3) is one step
  in that direction.

## How to break this thesis (the T5 test)

Find a classical law whose quantum-level failure can't be traced to any of P1–P6, or one where
a better mathematical *technique* alone, with no ontology changed, fixes the prediction. Either
would refute the claim that "the error is in the encoded assumptions". The map records the
attempt as an event, whatever the outcome.
