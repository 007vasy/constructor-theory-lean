# Labyrinth status

Generated 2026-11-22T06:58:54Z by `labyrinth/lab.py build`. Do not edit by hand.


## Conjectures (21)

- **P1 Continuum** [`k.cont`, open] Energy and modes are infinitely divisible. Fails where hbar*omega >~ k_B T, or action ~ hbar.
- **P2 Joint sharpness** [`k.sharp`, open] Every observable has a sharp value at once (phase-space points). Fails because [q,p] = i*hbar.
- **P3 Local realism** [`k.local`, open] Correlations come from local pre-set values. Fails because CHSH reaches 2*sqrt(2) > 2.
- **P4 Universal distinguishability and copying** [`k.dist`, open] Every state can be perfectly distinguished and copied. Fails: non-orthogonal states, no-cloning.
- **P5 Labelled identity** [`k.label`, open] Identical particles carry labels. Fails: (anti)symmetrised states, Bose/Fermi statistics.
- **P6 Smooth at all scales** [`k.smooth`, open] A differential (field) description holds down to arbitrarily small scales. Fails: divergences.
- **Ben's thesis: the breakdown shows the description is incorrect** [`k.ben-thesis`, open] Classical laws are false-but-emergent approximations; the error lives in ontological assumptions encoded in the mathematics (continuum, joint sharpness, unlimited distinguishability), not in the calculus.
- **C1 Finite distinguishability per action (FD)** [`k.c1-fd`, open] A substrate with energy <= E evolving for time t passes through at most ~2Et/(pi*hbar) perfectly distinguishable states (Margolus-Levitin) and, within radius R, holds at most ~2*pi*R*E/(hbar*c*ln2) bits (Bekenstein). Proposed as a constructor-theoretic principle, not a dynamical theorem.
- **C2 Superinformation + interoperability generate the q-number algebra** [`k.c2-si`, open] Deutsch-Marletto superinformation plus the reconstruction axioms (Hardy; Chiribella-D'Ariano-Perinotti; Masanes-Mueller) single out complex Hilbert space, hence the q-number forms of the 18 'established' rows.
- **C3 Quantitative possibility: possible to accuracy eps at cost >= f(eps)** [`k.c3-cost`, open] Attach resource costs to tasks (time, energy, steps) so that rates and coefficients become lower bounds on cost (third law: Masanes-Oppenheim).
- **C4 Classical law = quantum law + possibility assumption X** [`k.c4-schema`, open] Every catalogue law rests on a class X of tasks that classical physics assumes possible; it fails exactly where X contains an impossible task.
- **Chosen model: C4 frame with C1 + C2 as the two forbidden-task principles** [`k.chosen`, open] Classical laws assume two classes of tasks possible: copying arbitrary states (forbidden by superinformation) and distinguishing unboundedly many states with bounded action (forbidden by FD). Breakdown happens exactly at those tasks.
- **q-number form: Einstein field equations at Planck scale [Speculative, SC]** [`qn.einstein`, open] semiclassical G = 8 pi G <T> vs quantised metric; BMV decides
- **CT form: Rayleigh-Jeans law [Conjecture]** [`ct.rayleigh-jeans`, open] Changing a mode's energy by less than hbar w is impossible. Quantitative content of the law is lost in the CT form.
- **CT form: Equipartition theorem [Conjecture]** [`ct.equipartition`, open] A mode with hbar w >> kT cannot be thermally excited by sub-quantum transfers. Quantitative content of the law is lost in the CT form.
- **CT form: Dulong-Petit law [Conjecture]** [`ct.dulong-petit`, open] As equipartition, for phonon modes. Quantitative content of the law is lost in the CT form.
- **CT form: Larmor radiation / classical atom [Conjecture]** [`ct.larmor`, open] Lowering a bound electron below its ground state is impossible. Quantitative content of the law is lost in the CT form.
- **CT form: Wien/Lenard photoelectric expectation [Conjecture]** [`ct.photoelectric`, open] Ejecting an electron with h nu < phi is impossible at any intensity. Quantitative content of the law is lost in the CT form.
- **CT form: Maxwell-Boltzmann statistics [Conjecture]** [`ct.maxwell-boltzmann`, open] Distinguishing a configuration of identical particles from its swap is impossible. Quantitative content of the law is lost in the CT form.
- **CT form: Gibbs entropy without 1/N! [Conjecture]** [`ct.gibbs`, open] No work can be extracted from mixing identical gases (identity task). Quantitative content of the law is lost in the CT form.
- **CT form: Third law vs classical entropy [Conjecture]** [`ct.third-law`, open] Cooling to the ground state in finitely many steps is impossible. Quantitative content of the law is lost in the CT form.

## Open doors (questions) (11)

- **Formalise quantum no-cloning in the task vocabulary** [`q.nocloning-hilbert`, answered] Prove 'clone every state of a qubit' impossible in a Hilbert-space Theory model (Mathlib inner-product spaces).
- **Derive FD from the Margolus-Levitin bound in Lean** [`q.fd-from-ml`, open] In a finite-dimensional Hilbert-space Theory, prove that orthogonalisation takes time >= pi*hbar/(2E), so a bounded-energy, bounded-time task distinguishes finitely many states.
- **CHSH <= 2 for local models, Tsirelson for quantum** [`q.bell`, open] Formalise the classical CHSH bound (finite, decidable) and state the quantum violation.
- **Equipartition vs discrete modes** [`q.planck`, open] Prove that a discrete mode spectrum gives a finite total mean energy where equipartition diverges (Rayleigh-Jeans vs Planck).
- **q-number form: Fourier heat law at nanoscale [Partial, SC]** [`qn.fourier`, partial] Green-Kubo exact, phonon Boltzmann SC; local law not derived
- **q-number form: Navier-Stokes at pinch-off/superfluid [Partial, SC]** [`qn.navier-stokes`, partial] operator conservation laws exact; NS closure not derived; GP mean-field
- **q-number form: QFT without cutoff (UV divergences) [Partial, FQ]** [`qn.qft-uv`, partial] renormalised EFT; UV completion unknown
- **CT form: Drude conductivity at low T [Not expressible]** [`ct.drude`, open] Conductivity is a coefficient, not a task. Quantitative content of the law is lost in the CT form.
- **CT form: Curie law / Bohr-van Leeuwen [Not expressible]** [`ct.magnetism`, open] No CT restatement of magnetisation. Quantitative content of the law is lost in the CT form.
- **CT form: Classical tunnelling barrier [Not expressible]** [`ct.tunnelling`, open] No CT task statement for finite-probability transmission. Quantitative content of the law is lost in the CT form.
- **CT form: QFT without cutoff (UV divergences) [Not expressible]** [`ct.qft-uv`, open] No CT restatement of UV divergences. Quantitative content of the law is lost in the CT form.

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

## Recent events (12 total)

- 2026-11-22T03:10 · documented · Catalogue of 22 classical laws that fail at the quantum level, each with its failed assumption (backfilled)
- 2026-11-22T03:12 · proposed · Six breakdown patterns P1-P6 proposed as the common cause (backfilled)
- 2026-11-22T03:15 · literature · Kuypers, Seeing Isn't Believing: continuum fluid theory fails at droplet pinch-off; same class as QFT divergences (backfilled)
- 2026-11-22T03:20 · proved · Lean: finite substrate has no continuum information variable; droplet toy; distinguishable iff disjoint (kernel-checked, no human referee) (backfilled)
- 2026-11-22T03:28 · proposed · Ben's thesis: the breakdown shows the mathematical description is incorrect; error lives in encoded ontological assumptions
- 2026-11-22T03:29 · question · Open doors: Hilbert-space no-cloning, CHSH/Tsirelson, discrete-mode energy vs equipartition
- 2026-11-22T03:31 · monitor · run_checks at local: 6/6 OK (first run of the harness, box)
- 2026-11-22T03:45 · monitor · run_checks at local: 8/8 OK (q-number restatements + QNumber.lean, box)
- 2026-11-22T04:27 · literature · Constructor-theory restatement literature: 19 papers verified on arXiv/journals; 22 laws tagged 7 Published, 3 Derived, 8 Conjecture, 4 Not expressible (CT_LITERATURE.md, CT_RESTATEMENT.md)
- 2026-11-22T04:27 · proved · CTRestatement.lean: no superinformation in the deterministic theory; toy principle VIII and law of impotence; constructor-based irreversibility with a two-state example
- 2026-11-22T04:27 · monitor · run_checks at local: 14/14 OK (CT restatements + CTRestatement.lean, box)
- 2026-11-22T06:58 · monitor · run_checks at 6321c67fe6d6: 28/28 OK (closing the gap: FD, breakdown schema, qubit superinformation, Planck factor)
