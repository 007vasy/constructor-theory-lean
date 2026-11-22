# Labyrinth status

Generated 2026-11-22T03:45:22Z by `labyrinth/lab.py build`. Do not edit by hand.


## Conjectures (8)

- **P1 Continuum** [`k.cont`, open] Energy and modes are infinitely divisible. Fails where hbar*omega >~ k_B T, or action ~ hbar.
- **P2 Joint sharpness** [`k.sharp`, open] Every observable has a sharp value at once (phase-space points). Fails because [q,p] = i*hbar.
- **P3 Local realism** [`k.local`, open] Correlations come from local pre-set values. Fails because CHSH reaches 2*sqrt(2) > 2.
- **P4 Universal distinguishability and copying** [`k.dist`, open] Every state can be perfectly distinguished and copied. Fails: non-orthogonal states, no-cloning.
- **P5 Labelled identity** [`k.label`, open] Identical particles carry labels. Fails: (anti)symmetrised states, Bose/Fermi statistics.
- **P6 Smooth at all scales** [`k.smooth`, open] A differential (field) description holds down to arbitrarily small scales. Fails: divergences.
- **Ben's thesis: the breakdown shows the description is incorrect** [`k.ben-thesis`, open] Classical laws are false-but-emergent approximations; the error lives in ontological assumptions encoded in the mathematics (continuum, joint sharpness, unlimited distinguishability), not in the calculus.
- **q-number form: Einstein field equations at Planck scale [Speculative, SC]** [`qn.einstein`, open] semiclassical G = 8 pi G <T> vs quantised metric; BMV decides

## Open doors (questions) (6)

- **Formalise quantum no-cloning in the task vocabulary** [`q.nocloning-hilbert`, open] Prove 'clone every state of a qubit' impossible in a Hilbert-space Theory model (Mathlib inner-product spaces).
- **CHSH <= 2 for local models, Tsirelson for quantum** [`q.bell`, open] Formalise the classical CHSH bound (finite, decidable) and state the quantum violation.
- **Equipartition vs discrete modes** [`q.planck`, open] Prove that a discrete mode spectrum gives a finite total mean energy where equipartition diverges (Rayleigh-Jeans vs Planck).
- **q-number form: Fourier heat law at nanoscale [Partial, SC]** [`qn.fourier`, partial] Green-Kubo exact, phonon Boltzmann SC; local law not derived
- **q-number form: Navier-Stokes at pinch-off/superfluid [Partial, SC]** [`qn.navier-stokes`, partial] operator conservation laws exact; NS closure not derived; GP mean-field
- **q-number form: QFT without cutoff (UV divergences) [Partial, FQ]** [`qn.qft-uv`, partial] renormalised EFT; UV completion unknown

## Hunches (speculation, not claims) (1)

- **Quantum theory carries the same kind of assumptions** [`h.quantum-also`, live] Continuous Hilbert space, complex amplitudes and smooth spacetime are themselves encoded ontological assumptions; QFT/GR divergences are their failure signal.

## Dead ends (refuted) (22)

- **Newton/Hamilton trajectories** [`x.newton`, refuted] Classical law, taken as exact. Fails in regime: action ~ hbar. Replaced by: Schrodinger / Heisenberg.
- **Liouville phase-space density** [`x.liouville`, refuted] Classical law, taken as exact. Fails in regime: interference states. Replaced by: von Neumann; Wigner can go negative.
- **Rayleigh-Jeans law** [`x.rayleigh-jeans`, refuted] Classical law, taken as exact. Fails in regime: h nu >~ k_B T. Replaced by: Planck law.
- **Equipartition theorem** [`x.equipartition`, refuted] Classical law, taken as exact. Fails in regime: hbar omega >> k_B T. Replaced by: Bose-Einstein mode energy.
- **Dulong-Petit law** [`x.dulong-petit`, refuted] Classical law, taken as exact. Fails in regime: low T. Replaced by: Einstein 1907, Debye T^3.
- **Larmor radiation / classical atom** [`x.larmor`, refuted] Classical law, taken as exact. Fails in regime: atoms. Replaced by: Bohr, then Schrodinger bound states.
- **Wien/Lenard photoelectric expectation** [`x.photoelectric`, refuted] Classical law, taken as exact. Fails in regime: light on metals. Replaced by: E_max = h nu - phi.
- **Maxwell-Boltzmann statistics** [`x.maxwell-boltzmann`, refuted] Classical law, taken as exact. Fails in regime: n lambda^3 >~ 1. Replaced by: Fermi-Dirac, Bose-Einstein.
- **Gibbs entropy without 1/N!** [`x.gibbs`, refuted] Classical law, taken as exact. Fails in regime: mixing identical gases. Replaced by: symmetrised states.
- **Drude conductivity at low T** [`x.drude`, refuted] Classical law, taken as exact. Fails in regime: metals. Replaced by: Sommerfeld/Bloch, BCS.
- **Curie law / Bohr-van Leeuwen** [`x.magnetism`, refuted] Classical law, taken as exact. Fails in regime: every magnet. Replaced by: quantised spin and orbital momentum.
- **Classical spin (Stern-Gerlach)** [`x.spin`, refuted] Classical law, taken as exact. Fails in regime: inhomogeneous B field. Replaced by: spin-1/2.
- **Classical vacuum (no Casimir)** [`x.vacuum`, refuted] Classical law, taken as exact. Fails in regime: plates ~ um apart. Replaced by: zero-point energy.
- **Fourier heat law at nanoscale** [`x.fourier`, refuted] Classical law, taken as exact. Fails in regime: below phonon mean free path. Replaced by: phonon Boltzmann transport.
- **Navier-Stokes at pinch-off/superfluid** [`x.navier-stokes`, refuted] Classical law, taken as exact. Fails in regime: neck ~ nm; He-II. Replaced by: molecular dynamics; quantised vortices.
- **Third law vs classical entropy** [`x.third-law`, refuted] Classical law, taken as exact. Fails in regime: T -> 0. Replaced by: gapped discrete spectrum.
- **Bell local hidden variables** [`x.bell`, refuted] Classical law, taken as exact. Fails in regime: space-like separated entangled pairs. Replaced by: Tsirelson 2 sqrt 2.
- **Classical measurement (no disturbance)** [`x.measurement`, refuted] Classical law, taken as exact. Fails in regime: non-commuting observables. Replaced by: measurement back-action.
- **Universal copying of information** [`x.copying`, refuted] Classical law, taken as exact. Fails in regime: unknown quantum states. Replaced by: no-cloning; superinformation.
- **Classical tunnelling barrier** [`x.tunnelling`, refuted] Classical law, taken as exact. Fails in regime: thin barriers, light particles. Replaced by: Gamow tunnelling.
- **Einstein field equations at Planck scale** [`x.einstein`, refuted] Classical law, taken as exact. Fails in regime: singularities; l_P. Replaced by: unknown (quantum gravity); BMV tests.
- **QFT without cutoff (UV divergences)** [`x.qft-uv`, refuted] Classical law, taken as exact. Fails in regime: short distances. Replaced by: renormalisation; EFT.

## Recent events (8 total)

- 2026-11-22T03:10 · documented · Catalogue of 22 classical laws that fail at the quantum level, each with its failed assumption (backfilled)
- 2026-11-22T03:12 · proposed · Six breakdown patterns P1-P6 proposed as the common cause (backfilled)
- 2026-11-22T03:15 · literature · Kuypers, Seeing Isn't Believing: continuum fluid theory fails at droplet pinch-off; same class as QFT divergences (backfilled)
- 2026-11-22T03:20 · proved · Lean: finite substrate has no continuum information variable; droplet toy; distinguishable iff disjoint (kernel-checked, no human referee) (backfilled)
- 2026-11-22T03:28 · proposed · Ben's thesis: the breakdown shows the mathematical description is incorrect; error lives in encoded ontological assumptions
- 2026-11-22T03:29 · question · Open doors: Hilbert-space no-cloning, CHSH/Tsirelson, discrete-mode energy vs equipartition
- 2026-11-22T03:31 · monitor · run_checks at local: 6/6 OK (first run of the harness, box)
- 2026-11-22T03:45 · monitor · run_checks at local: 8/8 OK (q-number restatements + QNumber.lean, box)
