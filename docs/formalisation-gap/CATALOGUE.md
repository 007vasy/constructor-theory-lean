# The formalisation gap — catalogue: classical laws that break down at the quantum level

22 entries. Each is run like one row of an [ecdsa.fail](https://ecdsa.fail) `results.tsv`
(see `METHOD.md`): the classical law is the *candidate*, the experiment that refutes it is
the *validator*, and the row records **OK/FAIL**, the regime, the replacement, and a note
naming the classical assumption that failed. Tags use the six codes in `PATTERN.md`:

`CONT` continuum / infinite divisibility · `SHARP` joint sharpness of all observables ·
`LOCAL` local realism · `DIST` universal distinguishability and copying ·
`LABEL` labelled identical particles · `SMOOTH` smooth description at all scales.

The same tags are encoded as data in `ConstructorTheory/FormalisationGap.lean`
(`catalogue`), where the counts are checked by `decide`. Sources are in `SOURCES.md`
(numbers in brackets).

## A. Mechanics and phase space

| # | Classical law | Fails when | Replaced by | Assumption that fails | Tags |
|---|---|---|---|---|---|
| 1 | **Newton / Hamilton**: $m\ddot{\mathbf x} = -\nabla V$; $\dot q = \partial H/\partial p,\ \dot p = -\partial H/\partial q$ | Action $S \sim \hbar$: atoms, electrons, double slit | Schrödinger $i\hbar\,\partial_t\psi = \hat H\psi$; Heisenberg $\dot{\hat A} = \tfrac{i}{\hbar}[\hat H,\hat A]$ | A particle has a sharp $(q,p)$ at every instant; $[\hat q,\hat p] = i\hbar \ne 0$ forbids it [1] | SHARP, CONT |
| 2 | **Liouville**: $\partial_t\rho = \{H,\rho\}$ with $\rho(q,p)\ge 0$ | Same regime; states with interference | von Neumann $i\hbar\,\dot{\hat\rho} = [\hat H,\hat\rho]$; Wigner function can go negative | Phase-space points exist as states; $\Delta q\,\Delta p \ge \hbar/2$ [1] | SHARP |
| 3 | **Classical barrier**: particle with $E < V_0$ is reflected with certainty | Thin barriers, light particles (alpha decay, tunnel diodes, STM) | Tunnelling amplitude $\sim e^{-\int \sqrt{2m(V-E)}\,dx/\hbar}$ (Gamow) [2] | Position and momentum jointly sharp, so $E < V$ means "not there" | SHARP |

## B. Radiation and the old quantum problems

| # | Classical law | Fails when | Replaced by | Assumption that fails | Tags |
|---|---|---|---|---|---|
| 4 | **Rayleigh–Jeans**: $u(\nu,T) = \dfrac{8\pi\nu^2}{c^3}k_BT$ ⇒ $\int u\,d\nu = \infty$ (UV catastrophe) | $h\nu \gtrsim k_BT$ | Planck: $u = \dfrac{8\pi h\nu^3}{c^3}\dfrac{1}{e^{h\nu/k_BT}-1}$ [3] | Each field mode's energy is continuous, so every mode gets $k_BT$ | CONT |
| 5 | **Equipartition**: $\tfrac12 k_BT$ per quadratic degree of freedom | Any mode with $\hbar\omega \gg k_BT$ (frozen out) | Bose–Einstein mean energy $\hbar\omega/(e^{\hbar\omega/k_BT}-1)$ | Continuous energy, so arbitrarily small excitations are available | CONT |
| 6 | **Larmor**: $P = \dfrac{q^2a^2}{6\pi\varepsilon_0c^3}$ ⇒ orbiting electron spirals in | Atoms | Bohr (1913), then Schrödinger bound states with a ground state [4] | Orbits form a continuum, and the electron has a sharp trajectory | CONT, SHARP |
| 7 | **Classical photoelectric expectation**: electron energy grows with intensity, after a delay | Light on metals | $E_{\max} = h\nu - \phi$ (Einstein 1905) [5] | Field energy is continuously divisible and spreads over the wavefront | CONT |
| 8 | **Classical vacuum**: empty space with $E=B=0$ exerts no force | Plates ~µm apart | Zero-point energy $\sum_k \tfrac12\hbar\omega_k$, Casimir force $F/A = -\pi^2\hbar c/240a^4$ [6] | The field can sit at exactly zero with zero spread; quantum $\Delta E\,\Delta B > 0$ | CONT, SHARP |

## C. Thermal and statistical physics

| # | Classical law | Fails when | Replaced by | Assumption that fails | Tags |
|---|---|---|---|---|---|
| 9 | **Dulong–Petit**: $C_V = 3R$ per mole of solid | Low $T$ (diamond already at room $T$) | Einstein (1907), Debye (1912): $C_V \propto T^3$ [7] | Lattice vibrations take continuous energies | CONT |
| 10 | **Maxwell–Boltzmann**: $\bar n_i = e^{-(\varepsilon_i-\mu)/k_BT}$ | Degenerate gases: $n\lambda_{dB}^3 \gtrsim 1$ (electrons in metals, white dwarfs, BEC) | Fermi–Dirac $1/(e^{x}+1)$, Bose–Einstein $1/(e^{x}-1)$ | Identical particles carry labels, so swapping two gives a new state | LABEL |
| 11 | **Gibbs entropy without $1/N!$** (Gibbs paradox) | Mixing identical gases | Symmetrized states; indistinguishability built into Hilbert space | Same: labelled identical particles | LABEL |
| 12 | **Drude**: $\sigma = ne^2\tau/m$, electronic $C_V = \tfrac32 nk_B$ | Metals at all $T$ for $C_V$; low-$T$ resistivity, superconductivity | Sommerfeld/Bloch band theory; BCS [8] | Electrons are a classical labelled gas with continuous energies | LABEL, CONT |
| 13 | **Classical magnetism**: Bohr–van Leeuwen theorem ⇒ no equilibrium magnetization | Every real paramagnet, ferromagnet, diamagnet | Quantized spin and orbital angular momentum; Curie law from discrete levels [9] | Continuous classical orbits/moments in phase space | CONT, SHARP |
| 14 | **Classical entropy and the third law**: $S = C\ln T + \text{const}$ diverges as $T \to 0$ | $T \to 0$ | Discrete spectrum with a ground-state gap gives $S \to$ constant (Nernst) [10] | Continuous energy spectrum down to zero | CONT |
| 15 | **Fourier heat law**: $\mathbf q = -\kappa\nabla T$ | Length scales below the phonon mean free path (nanostructures, thin films) | Boltzmann transport for phonons; ballistic heat conduction [11] | A local temperature field exists at every scale | SMOOTH, CONT |

## D. Continua, fields and spacetime

| # | Classical law | Fails when | Replaced by | Assumption that fails | Tags |
|---|---|---|---|---|---|
| 16 | **Navier–Stokes**: $\rho(\partial_t\mathbf u + \mathbf u\cdot\nabla\mathbf u) = -\nabla p + \mu\nabla^2\mathbf u$ | Droplet pinch-off (neck → nm), nanojets; superfluid He-II | Molecular dynamics / stochastic hydrodynamics at the neck [12]; quantized vortices with circulation $h/m$ in He-II [13] | The fluid is a differentiable continuum at all scales | SMOOTH, CONT |
| 17 | **Einstein field equations** $G_{\mu\nu} = 8\pi G T_{\mu\nu}/c^4$ with classical $T_{\mu\nu}$ | Singularities; Planck length $\ell_P = \sqrt{\hbar G/c^3}$; superposed sources (what BMV tests) | Unknown: quantum gravity. BMV probes whether gravity can entangle masses [14] | Smooth metric sourced by sharp classical matter at all scales | SMOOTH, CONT |
| 18 | **Unregulated QFT**: loop integrals $\int^\infty d^4k$ diverge | Short distances | Renormalization with a cutoff; effective field theory [15] | The field is defined down to arbitrarily small scales | SMOOTH |
| 19 | **Classical spin**: magnetic moment points in any direction; Stern–Gerlach should give a smear | Silver atoms in an inhomogeneous field | Two discrete spots; spin-½ with $S_z = \pm\hbar/2$ [16] | Angular momentum direction is continuous and all components jointly sharp | CONT, SHARP |

## E. Information, measurement and correlation

| # | Classical law | Fails when | Replaced by | Assumption that fails | Tags |
|---|---|---|---|---|---|
| 20 | **Local hidden variables / Bell–CHSH**: $\lvert S\rvert \le 2$ | Entangled pairs, measured with space-like separation | Quantum value up to $2\sqrt2$ (Tsirelson); seen loophole-free [17] | Outcomes are pre-existing and local (counterfactual definiteness plus locality) | LOCAL, SHARP |
| 21 | **Classical measurement**: any state can be measured without disturbance | Non-commuting observables; non-orthogonal states | Measurement back-action; Heisenberg/Ozawa relations | All attributes are sharp and perfectly distinguishable | DIST, SHARP |
| 22 | **Universal copying**: any state can be cloned, $\lvert\psi\rangle\lvert 0\rangle \mapsto \lvert\psi\rangle\lvert\psi\rangle$ | Any unknown quantum state | No-cloning theorem (Wootters–Zurek; Dieks) [18]; in constructor theory, cloning a superinformation variable is impossible [19] | Every set of states is an information variable | DIST |

### What is *not* in the list, and why

- **Maxwell's equations** themselves survive quantization as operator equations. What fails is
  the *classical field state* (rows 4, 7, 8).
- **Conservation laws** (energy, momentum, charge) survive; they become operator statements.
- **Special relativity** survives and constrains QFT.

This is consistent with the pattern: what breaks is the *state space* and its assumptions, not
the symmetry and conservation structure.
