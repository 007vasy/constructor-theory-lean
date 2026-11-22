# The formalisation gap — q-number restatements

> "Vedral says everything is q-number, could we re-state the equations so they are correct where
> the current ones fail?" (Ben)

**Vedral's stance, sourced.** In
[*The Everything-is-a-Quantum-Wave Interpretation of Quantum Physics*](https://arxiv.org/abs/2303.00831)
(arXiv:2303.00831), V. Vedral writes that "the entities that are doing the waving are what Dirac
called q–numbers (as opposed to the ordinary c-numbers…)": generally non-commuting operators at
every point of space and time, obeying wave equations. On this view the classical c-numbers
"emerge" when our q-waves become entangled with the system's.

Related work:
- Marletto, Tibau Vidal & Vedral, *Interference in the Heisenberg picture of quantum field theory…*,
  [Phys. Rev. D 104, 065013 (2021)](https://doi.org/10.1103/PhysRevD.104.065013) (arXiv:2011.14003).
  Its abstract says local elements of reality are q-numbers.
- Vedral's newsletter, ["What is a Q-Field?"](https://vlatkovedral.substack.com/p/what-is-a-q-field)
  (7 Nov 2024). He also lists the open *problems* of the picture there: the infinite matrices and
  the divergences that renormalisation removes.

**Recipe.** Replace each c-number by an operator (the Heisenberg picture). Keep the equation of
motion, i.e. Heisenberg's dÂ/dt = (i/ħ)[Ĥ, Â] + ∂Â/∂t. Then recover the classical law as a limit:
- **Ehrenfest**: equations for ⟨Â⟩ that close when fluctuations are small;
- **ħ → 0**: WKB/Hamilton–Jacobi, Moyal → Poisson;
- **large occupation**: n̄ ≫ 1, so that ħω ≪ k_BT;
- **decoherence**: interference terms between pointer states are suppressed.

**Tags.**
- **Status**: **Established** (textbook), **Partial/open** (the q-number equations exist but the
  route to the law is not derived, or not complete), **Speculative** (no accepted q-number theory).
- **Form**: **FQ** means fully quantum, with every degree of freedom an operator. **SC** means
  semiclassical, with some c-numbers kept or a mean-field closure. The SC form is noted where it
  is what's actually used.

Each row is also a node `qn.<law>` in `labyrinth/knowledge.json`. Established rows are T1
theorems; Partial rows are open questions; the Speculative row is a T5 conjecture with an
experimental test.

## Summary

| # | Classical law | q-number restatement (holds where the classical law fails) | Classical law recovered by | Status | Form |
|---|---|---|---|---|---|
| 1 | Newton/Hamilton | $\dot{\hat x} = \hat p/m,\ \dot{\hat p} = -\nabla V(\hat x)$, with $[\hat x,\hat p]=i\hbar$ | Ehrenfest $\tfrac{d}{dt}\langle\hat p\rangle = -\langle\nabla V(\hat x)\rangle \approx -\nabla V(\langle\hat x\rangle)$ for narrow packets; ħ→0 (WKB) | Established | FQ |
| 2 | Liouville | von Neumann $i\hbar\,\dot{\hat\rho} = [\hat H,\hat\rho]$; in Wigner form $\partial_t W = \{\!\{H,W\}\!\}_{\text{Moyal}} = \{H,W\} + O(\hbar^2)$ | Moyal bracket → Poisson bracket as ħ→0 | Established | FQ |
| 3 | Classical barrier | $\hat H = \hat p^2/2m + V(\hat x)$; transmission $T \approx e^{-2\int\kappa\,dx}$, $\kappa = \sqrt{2m(V-E)}/\hbar$ | T → 0 as mass·width/ħ → ∞ | Established | FQ (WKB form is SC) |
| 4 | Rayleigh–Jeans | Quantised field $\hat{\mathbf E},\hat{\mathbf B}$ obey Maxwell's equations as operator equations; $\hat H = \sum_k \hbar\omega_k(\hat a_k^\dagger \hat a_k + \tfrac12)$; Planck from Bose–Einstein occupation | hν ≪ k_BT (n̄ ≫ 1) gives $u = 8\pi\nu^2 k_BT/c^3$ | Established | FQ |
| 5 | Equipartition | $\langle \hat H_\omega\rangle = \tfrac{\hbar\omega}{2}\coth\tfrac{\hbar\omega}{2k_BT}$ per oscillator mode | k_BT ≫ ħω gives k_BT | Established | FQ |
| 6 | Larmor / classical atom | QED: bound-electron spectrum with a ground state; spontaneous emission at rate $\Gamma = \omega^3\lvert\mathbf d\rvert^2/3\pi\varepsilon_0\hbar c^3$ (Wigner–Weisskopf) | Correspondence: large-n states and coherent field states radiate like Larmor | Established | FQ |
| 7 | Photoelectric | Electron as q-number coupled to the field: $E_{\max} = \hbar\omega - \phi$ | n/a (no classical success to recover) | Established | **SC suffices**: quantised electrons in a *classical* field give the threshold law (Lamb & Scully 1969). Field quantisation isn't needed for this row |
| 8 | Classical vacuum | $\langle 0\lvert\hat{\mathbf E}^2\rvert 0\rangle \neq 0$; Casimir $F/A = -\pi^2\hbar c/240a^4$ | ħ→0 gives F→0 | Established | FQ (Jaffe 2005: the same force follows from relativistic van der Waals forces between the plates, without invoking vacuum energy) |
| 9 | Dulong–Petit | Phonons $\hat a_{k}$; Debye $C_V \propto T^3$ at low T | T ≫ Θ_D gives 3R | Established | FQ |
| 10 | Maxwell–Boltzmann | $\hat\rho = e^{-\beta(\hat H-\mu\hat N)}/Z$ on Fock space; $\bar n = 1/(e^{\beta(\varepsilon-\mu)}\pm1)$ | $e^{\beta(\varepsilon-\mu)} \gg 1$ (non-degenerate) | Established | FQ |
| 11 | Gibbs without 1/N! | $S = -k_B\,\mathrm{Tr}\,\hat\rho\ln\hat\rho$ on the (anti)symmetrised space; the 1/N! comes out of the formalism | Dilute limit gives Sackur–Tetrode | Established | FQ |
| 12 | Drude / Ohm | Kubo: σ from the current–current correlator $\langle[\hat J(t),\hat J(0)]\rangle$; Landauer $G = \tfrac{2e^2}{h}\sum_n T_n$ | Bloch–Boltzmann (SC) with relaxation time gives $\sigma = ne^2\tau/m^*$ | Established | FQ (Kubo, Landauer); SC (Bloch–Boltzmann) |
| 13 | Classical magnetism | Spin and orbital operators $\hat{\mathbf S},\hat{\mathbf L}$; Brillouin function; Curie $\chi = C/T$ | J→∞ gives Langevin; Bohr–van Leeuwen holds only for classical charges | Established | FQ |
| 14 | Classical entropy / third law | $S(T) = -k_B\,\mathrm{Tr}\,\hat\rho\ln\hat\rho \to k_B\ln g_0$ as T→0 (discrete spectrum, gap) | High T: classical S up to a constant | Established | FQ |
| 15 | Fourier | Green–Kubo $\kappa = \tfrac{1}{Vk_BT^2}\int_0^\infty\langle\hat J_E(t)\hat J_E(0)\rangle\,dt$; phonon Boltzmann transport | Diffusive limit (size ≫ mean free path) | **Partial/open** | Green–Kubo FQ; phonon Boltzmann SC. Deriving the local law from microscopic dynamics is open even classically (Bonetto–Lebowitz–Rey-Bellet 2000) |
| 16 | Navier–Stokes | Heisenberg EoM for field operators $\hat\psi(\mathbf x)$ give *exact* operator continuity and momentum-flux equations; superfluid: circulation $\oint \mathbf v\cdot d\mathbf l = nh/m$, Gross–Pitaevskii (mean-field) | Long-wavelength expectation values plus local equilibrium give hydrodynamics | **Partial/open** | Conservation laws FQ; closure to NS not derived; GP is SC. **Caveat:** droplet pinch-off is *atomistic*, not quantum. Fluctuating hydrodynamics/MD fixes it without q-numbers (Moseler & Landman 2000; Eggers 2002) |
| 17 | Einstein field equations | (a) Semiclassical $G_{\mu\nu} = \tfrac{8\pi G}{c^4}\langle\hat T_{\mu\nu}\rangle$ (Møller 1962, Rosenfeld 1963). (b) Fully quantised metric $\hat g_{\mu\nu}$: no accepted theory; perturbative quantum gravity works as an effective field theory at low energy (Donoghue 1994) | GR when $\hat T$ has small fluctuations | **Speculative** | (a) SC, (b) FQ. BMV decides between them: gravity-induced entanglement rules out (a) as a complete description (Bose et al. 2017; Marletto & Vedral 2017, 2021) |
| 18 | Unregulated QFT | Already q-number. Renormalised/Wilsonian effective field theory with a cutoff Λ | Λ-independent low-energy predictions | **Partial/open** | FQ as EFT; the UV completion is unknown. This is Vedral's own "Q-field" worry |
| 19 | Classical spin | $\hat S_z$ eigenvalues ±ħ/2, $[\hat S_x,\hat S_y] = i\hbar\hat S_z$; Heisenberg $\dot{\hat{\mathbf S}} = \gamma\,\hat{\mathbf S}\times\mathbf B$ | Ehrenfest is *exact* here: ⟨Ŝ⟩ precesses classically (Bloch); large spin gives a continuous direction | Established | FQ. **Lean:** `pauliX_mul_pauliZ_ne`, `no_common_eigenvector` |
| 20 | Bell local hidden variables | Observables on $\mathcal H_A\otimes\mathcal H_B$; $\lvert\langle\hat{\mathcal B}_{\text{CHSH}}\rangle\rvert \le 2\sqrt2$ (Tsirelson 1980); local in the Heisenberg picture (Deutsch & Hayden 2000) | Commuting (c-number) observables give ≤ 2 | Established | FQ |
| 21 | Classical measurement | Measurement as unitary coupling $\hat U = e^{-i\lambda\hat A\otimes\hat P_{\text{meter}}/\hbar}$ (von Neumann); Ozawa's error–disturbance relation | Decoherence of the meter; commuting observables gave the classical idealisation | Established | FQ |
| 22 | Universal copying | Unitarity forbids $\hat U\lvert\psi\rangle\lvert 0\rangle = \lvert\psi\rangle\lvert\psi\rangle$ for non-orthogonal states; orthogonal sets can be copied | Copying is restored on any orthogonal basis (classical information) | Established | FQ. In constructor theory: superinformation can't be cloned |

**Count:** 18 Established, 3 Partial/open (15, 16, 18), 1 Speculative (17). Of the Established
rows, two (7, 12) are usually used in semiclassical form, and one (8) has a known alternative
derivation.

## Bottom line (honest)

1. **Yes, for 18 of 22.** For these, a q-number restatement exists, is textbook, and is correct
   exactly where the classical law fails. In each case the classical law comes back as a limit
   (Ehrenfest, ħ→0, n̄ ≫ 1, decoherence). The equation of motion mostly *survives*. What changes
   is the type of the quantities, c-number → q-number, and so their commutation relations. That
   supports THESIS.md: the error was the encoded assumption (P2 joint sharpness, P1 continuum
   of excitations), not the dynamics.
2. **Not yet, for three.** Hydrodynamics (16) and Fourier (15) have exact operator conservation
   laws, but the closure to the continuum law isn't derived, even classically. Note also that
   Kuypers' droplet fails because matter is *atomic*, not because it is quantum. QFT (18) is
   already q-number, and its open problem is what lies above the cutoff.
3. **No accepted restatement for gravity (17).** Semiclassical gravity keeps the metric a
   c-number. A fully quantised metric has no complete theory. Marletto–Vedral and Bose et al.
   argue that observing gravity-induced entanglement would show gravity can't be a classical
   (c-number) mediator. That is BMV.
4. **"Everything is a q-number" is itself an interpretation.** The interpretation is Vedral's
   (Everettian, Heisenberg picture). The *equations* in the table are standard whichever
   interpretation you hold, and Vedral himself flags the infinities of the q-field picture.

## Lean (`ConstructorTheory/QNumber.lean`)

- `pauliX_mul_pauliZ_ne`: σx σz ≠ σz σx over ℂ. Spin components are q-numbers.
- `no_common_eigenvector`: no non-zero vector is an eigenvector of both, so no state gives both
  sharp values.

This is the smallest formal instance of row 19 and pattern P2. No `sorry`, no new axioms.

## Sources (opened 22 Nov 2026 unless marked)

- V. Vedral, arXiv:2303.00831 (2023): https://arxiv.org/abs/2303.00831
- C. Marletto, N. Tibau Vidal, V. Vedral, Phys. Rev. D 104, 065013 (2021), arXiv:2011.14003
- V. Vedral, "What is a Q-Field?" (7 Nov 2024): https://vlatkovedral.substack.com/p/what-is-a-q-field
- C. Marletto & V. Vedral, PRL 119, 240402 (2017), arXiv:1707.06036; S. Bose et al., PRL 119, 240401 (2017)
- C. Marletto & V. Vedral, "Sagnac interferometer and the quantum nature of gravity", J. Phys. Commun. 5, 051001 (2021), doi:10.1088/2399-6528/abfd43
- Standard references, not re-opened this session (check before citing externally):
  - W. E. Lamb & M. O. Scully, "The photoelectric effect without photons" (1969)
  - R. L. Jaffe, Phys. Rev. D 72, 021301 (2005)
  - F. Bonetto, J. L. Lebowitz, L. Rey-Bellet, "Fourier's law: a challenge to theorists" (2000)
  - J. Eggers, PRL 89, 084502 (2002)
  - C. Møller (1962); L. Rosenfeld, Nucl. Phys. 40, 353 (1963)
  - J. F. Donoghue, PRD 50, 3874 (1994)
  - B. S. Cirel'son, Lett. Math. Phys. 4, 93 (1980)
  - D. Deutsch & P. Hayden, Proc. R. Soc. A 456, 1759 (2000)
  - M. Ozawa, PRA 67, 042105 (2003)
  - R. Kubo, J. Phys. Soc. Jpn. 12, 570 (1957)
  - R. Landauer, IBM J. Res. Dev. 1, 223 (1957)
