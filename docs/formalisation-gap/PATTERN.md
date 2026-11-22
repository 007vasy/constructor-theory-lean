# The formalisation gap — the common pattern: why classical laws break down

**Short answer.** Classical laws don't fail because their *dynamics* are wrong in some ad hoc
way. They fail because they all share one hidden model of **what a physical state is**: a point
in a continuum, where every quantity has a sharp value, everything is labelled, and any state
can be read and copied. Quantum theory rejects that model, and each classical law fails exactly
where its answer depended on it. The dynamics that survive are the parts that never used it:
symmetries, conservation laws, and Maxwell/Hamilton *as operator equations*.

Counts below come from the tags in `CATALOGUE.md` and are checked by `decide` in
`ConstructorTheory/FormalisationGap.lean`. There are 22 laws, and most carry more than one tag.

## P1. Continuum: energy and modes are infinitely divisible (14 of 22)

*Rayleigh–Jeans, equipartition, Dulong–Petit, Larmor atom, photoelectric, Drude C_V,
magnetism, third law, Casimir, Stern–Gerlach, Fourier, Navier–Stokes, GR.*

**Why it breaks.** If a degree of freedom can hold *any* amount of energy, equilibrium gives it
k_BT/2 whatever its frequency. With infinitely many modes you get infinities (UV catastrophe,
radiative collapse). Quantization puts a minimum excitation ħω on each mode. Modes with
ħω ≫ k_BT can't be excited, so they freeze out and the sums converge. One mechanism fixes
Planck, Einstein–Debye heat capacities, the third law and atomic stability. The classical
answer is right only where ħω ≪ k_BT, or more generally where action ≫ ħ.

## P2. Joint sharpness: every observable has a definite value at once (9 of 22)

*Newton/Hamilton, Liouville, tunnelling, Larmor atom, magnetism, Stern–Gerlach, vacuum,
measurement, Bell.*

**Why it breaks.** Classical mechanics assumes a state is a point (q, p). [q̂, p̂] = iħ means
no state gives both sharp values. "Trajectory", "particle sits at the bottom of the well" and
"field exactly zero" are all such points. So the ground state has zero-point motion (atoms don't
collapse, the vacuum has Casimir energy), and barriers leak.

## P3. Local realism: correlations come from local, pre-set values (1 of 22, but foundational)

*Bell–CHSH.*

**Why it breaks.** Combine P2 with locality and you get |S| ≤ 2. Nature reaches 2√2. This row
counts once, but it is the one that rules out "fix it with hidden sharp values". You can't
repair P2 classically without giving up locality.

## P4. Universal distinguishability and copying (2 of 22, and the constructor-theory core)

*Classical measurement, universal copying.*

**Why it breaks.** Classically every pair of states is distinguishable, so every set of states
is an information variable that can be cloned. Quantum theory has non-orthogonal states, which
no measurement tells apart perfectly, and no-cloning. Deutsch–Marletto restate this as a
**task-level law**: a quantum system has a *superinformation* variable, a union of information
variables that can't be cloned as a whole. In constructor-theory terms, "copy any state" is
an **impossible task**. Lean section 3 proves the classical skeleton: in a deterministic
theory, distinguishing two attributes is possible only if they are disjoint.

## P5. Labelled identity (3 of 22)

*Maxwell–Boltzmann, Gibbs paradox, Drude.*

**Why it breaks.** Classical counting treats swapping two identical particles as a new state.
Quantum states are symmetric or antisymmetric, which gives Bose/Fermi statistics, degeneracy
pressure and the 1/N! factor. This is P4 applied to particles: there is *no attribute* that
tells which electron is which.

## P6. Smooth at all scales (4 of 22)

*Fourier, Navier–Stokes, Einstein equations, UV-divergent QFT.*

**Why it breaks.** A differential equation assumes the field exists at every point. Below some
length (mean free path, atomic spacing, Planck length) the field picture stops. The theory then
predicts **divergences**, and those divergences are its own signal of failure.

## How the patterns reduce

P1, P2, P4 and P5 are four faces of a single fact: **the space of physically distinguishable
states is not a continuum of sharp points.** It is discrete in what can be *excited* (P1),
non-commutative in what can be *jointly sharp* (P2), and restricted in what can be
*distinguished or copied* (P4, P5). P3 says this can't be undone by hiding a continuum
underneath without giving up locality. P6 is the same failure seen from the continuum side.
The classical equation assumed infinite resolution and blows up where resolution runs out.

Put in Ben's ecdsa.fail language: every classical law skipped the same validity gate. It
assumed **unlimited distinguishability** (sharp, copyable, infinitely divisible states), and
nature's harness rejects that.

## Constructor-theory reading (honest scope)

Deutsch–Marletto's constructor theory of information takes *which tasks are possible* as
primary. Classical information means that distinguishing and copying are possible on some set
of attributes. Quantum theory adds the impossibility of cloning a superinformation variable.
This catalogue fits that well: each breakdown is a classical law that **assumed a task was
possible** (resolve the energy more finely, read q and p together, copy a state, label a
particle) when that task is in fact impossible. This is an interpretive frame, not a derivation.
Constructor theory doesn't yet *derive* ħ or Planck's law.

## Worked example: Sam Kuypers' drop of water

Kuypers, ["Seeing Isn't Believing"](https://samuelkuypers.substack.com/p/seeing-isnt-believing)
(13 Jul 2025), uses a forming droplet to argue that predictive success isn't truth.
Classical fluid theory treats water as a smooth, differentiable continuum. It predicts pressure,
turbulence and waves very well, but at pinch-off "the neck becomes so thin that atomic effects
dominate and the assumption of continuity breaks down". The classical theory "says the droplet
cannot form", yet rain exists. He then makes the same point about QFT's short-distance
infinities and cutoffs ("just as atomic theory fixes the divergences in classical fluids, a
future theory may resolve those in quantum field theory"), citing David Wallace's
["The quantum theory of fields"](https://philsci-archive.pitt.edu/15296/1/qm-continuum%20revised.pdf).

Running it through the method:

- **Candidate:** Navier–Stokes with surface tension. **Gate failed:** finiteness. The similarity
  solution for the thinning neck reaches a finite-time singularity (neck radius → 0, velocity
  → ∞; see Eggers 1997). **Regime:** neck ~ nm, where molecular dynamics shows thermal
  fluctuations take over (Moseler & Landman 2000).
- **Failed assumption:** P6/P1. The neck radius is treated as a real number that can sweep
  continuously to 0, when the neck is made of a finite number of molecules.
- **Lean:** `finite_substrate_misses_interval`. Any real-valued quantity on a substrate with
  finitely many states misses every open interval, so a finite-atom neck *cannot* pass through
  the continuum of radii the PDE assumes. That's the toy content of Kuypers' point. The droplet
  is the cleanest everyday instance of the general pattern: the divergence is the continuum
  model reporting its own failure.
- **Why it matters for QG/BMV:** Kuypers puts QFT's divergences, and by extension GR's
  singularities, in the same class. That is the pattern P6 ⇒ "a theory with finer resolution
  is needed". BMV is one experimental handle on whether the gravitational field shares P2/P4,
  i.e. whether it can carry quantum (non-classical) information.

## Formalisation gap: what is and isn't in Lean

| Claim | Status |
|---|---|
| Table and tag counts | `decide`, in `FormalisationGap.lean` |
| Finite substrate ⇒ no ℝ-valued information variable | Proved (`no_continuum_info_variable_of_finite`) |
| Finite substrate ⇒ a real quantity misses every interval (droplet) | Proved (`finite_substrate_misses_interval`) |
| Deterministic theory: distinguishable ⇒ disjoint; overlap ⇒ impossible | Proved (`disjoint_of_distinguish`, `distinguish_impossible_of_overlap`), plus the converse sanity check |
| Quantum no-cloning, Bell/Tsirelson, Planck's law, [q,p]=iħ | **Not formalised.** Needs Hilbert-space models. Candidate for M3+ |
