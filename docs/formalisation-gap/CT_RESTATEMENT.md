# The formalisation gap: the 22 laws restated in constructor theory

> "Ok research papers around re-stating laws in constructor theory and try to re-state the above
> one as well" (Ben)

Sources are in [`CT_LITERATURE.md`](CT_LITERATURE.md). The q-number restatements of the same 22
laws are in [`QNUMBER.md`](QNUMBER.md), and the argument they serve is in [`THESIS.md`](THESIS.md).

## What a constructor-theoretic restatement is

A classical law says "the state evolves like *this*". A constructor-theoretic (CT) law says
"the task *T* on substrate *S* is possible" or "is impossible". The restatement of each broken
law below has three parts:

- **substrate**: the physical system;
- **task**: the input → output attributes;
- **principle**: the CT principle or result that makes the task impossible (or possible).

The pattern from `PATTERN.md` carries over directly. **Every classical breakdown is a law that
silently assumed some task was possible.** Examples are resolving an energy ever more finely,
preparing q and p both sharp, copying any state, or labelling identical particles. The CT
restatement turns that hidden assumption into an explicit impossibility.

## Tags

- **Published**: the restatement, or its core, is in a cited CT paper.
- **Derived**: not stated in a CT paper, but follows in a few lines from a published CT result.
  The reasoning is given in the row.
- **Conjecture**: our proposal. It is a plausible CT statement, but nobody has proved it from CT
  principles. It is quantum-theory-backed but not CT-derived.
- **Not expressible yet**: current CT has no vocabulary that captures the law's content (rates,
  spectra, transport coefficients, PDEs).

**Quantitative content.** In every row, the CT statement keeps the *impossibility core*. It loses
the number (Planck's spectrum, Tsirelson's 2√2, the Casimir force, κ, η). Numbers come back only
when a specific dynamical theory (quantum theory, with the q-number forms in `QNUMBER.md`) is
plugged in. **No row keeps its full quantitative law inside CT alone.**

## The table

| # | Law (classical) | CT restatement: substrate · task · principle | Tag | Quantitative content lost |
|---|---|---|---|---|
| 1 | Newton/Hamilton | Particle · prepare a state with position *and* momentum both sharp: **impossible** · these are two information variables whose union is not one (superinformation; Deutsch–Marletto 2015: "pairs of variables that cannot simultaneously have sharp values") | **Published** (the impossibility core) | The trajectory and F = ma itself. CT has no equation of motion. The CT time paper (2505.08692) gives dynamics a CT meaning but does not re-derive Newton |
| 2 | Liouville | Particle ensemble · prepare or measure a "phase-space point" attribute: **impossible** · follows from row 1. A phase-space point is an attribute sharp in both q and p, and a superinformation medium has none. Marletto–Vedral (1703.04325) show that a sector obeying Liouville dynamics cannot consistently couple to a quantum one | **Derived** (from D–M 2015; hybrid argument published) | The flow equation ∂ₜρ = {H, ρ} and its Moyal ħ² corrections |
| 3 | Classical barrier (no tunnelling) | Particle with E < V · "left of barrier → right of barrier" · in CT a task is possible only if it can be done to arbitrary accuracy. Tunnelling is a finite-probability, not deterministic, transition, and CT has no published rule that maps it onto a possible/impossible task | **Not expressible yet** | The transmission T ≈ e^(−2∫κdx). The probability CT paper (1507.03287) explains why outcomes are unpredictable, but gives no rates |
| 4 | Rayleigh–Jeans | Field mode of frequency ω · change the mode's energy by less than ħω: **impossible** · proposal: principle VIII (energy conservation as an impossible task) plus is-like classes of the mode labelled by ħω·ℕ (Marletto 2016 gives the classes, not the spacing) | **Conjecture** | Planck's spectrum. ħ is not derived in CT |
| 5 | Equipartition | Same substrate and task as 4. A mode with ħω ≫ k_BT cannot be thermally excited by a task that transfers less than ħω | **Conjecture** | ⟨E⟩ = (ħω/2) coth(ħω/2k_BT) |
| 6 | Larmor / classical atom | Bound electron · lower the atom's energy below the ground state: **impossible** · proposal: principle VIII plus a lowest is-like class (a discrete ground state) | **Conjecture** | The spectrum, spontaneous emission rates, and the Rydberg constant |
| 7 | Photoelectric | Metal + field of frequency ν < φ/h · eject an electron, at any intensity: **impossible** · proposal: energy conservation (principle VIII) applied to quantised energy exchange. Semiclassical theory already gives this (Lamb–Scully), so field quantisation is not needed | **Conjecture** | E_max = hν − φ, as a number |
| 8 | Classical vacuum | Field mode · prepare a state with E and B both sharp (in particular, both zero): **impossible** · the same superinformation argument as row 1, applied to the non-commuting field-quadrature variables | **Derived** (from D–M 2015 and the quantised-field commutator) | The Casimir force −π²ħc/240a⁴ and its interpretation (Jaffe 2005) |
| 9 | Dulong–Petit | Lattice phonon modes · as row 5, applied to phonons | **Conjecture** | Debye T³ and Θ_D |
| 10 | Maxwell–Boltzmann | Two identical particles · distinguish "particle 1 here, particle 2 there" from the swap: **impossible**, because there is no information variable that labels them · proposal. It is the CT form of indistinguishability. No CT paper derives bosons/fermions | **Conjecture** | The Bose–Einstein and Fermi–Dirac occupation functions |
| 11 | Gibbs (no 1/N!) | Same as 10. Mixing two samples of the same gas is the identity task, so no work can be extracted from it · the work-extraction link is published (Marletto 2009.04588: deterministic work extraction needs distinguishable inputs). Applying it to identical particles is our step | **Conjecture** (with a published ingredient) | Sackur–Tetrode, as a number |
| 12 | Drude / Ohm | Electron gas · no clear task statement. Conductivity is a linear-response *coefficient*, not a possible/impossible task | **Not expressible yet** | σ = ne²τ/m*, Kubo, Landauer |
| 13 | Classical magnetism | Charges in thermal equilibrium · Bohr–van Leeuwen says classical charges give zero magnetisation. The quantum fix needs spin and orbital q-numbers (row 19), but no CT paper restates the magnetisation itself | **Not expressible yet** | Curie χ = C/T, the Brillouin function |
| 14 | Classical entropy / third law | Any substrate · cool to the ground state in a finite number of steps: **impossible** (the Nernst unattainability form) · proposal: a law of impotence in Marletto's style. Marletto 2016 restates the zeroth, first and second laws, not the third | **Conjecture** | S → k_B ln g₀ and the low-T scaling of heat capacities |
| 15 | Fourier | Two bodies · move heat from colder to hotter with no other change: **impossible**. The direction of conduction is a second-law law of impotence (Marletto 2016; irreversibility as "a task is possible, while its inverse is not", PRL 128, 080401) | **Published** (the second-law core only) | The local law q = −κ∇T and κ itself. Even classically, deriving them from microdynamics is open (Bonetto–Lebowitz–Rey-Bellet 2000) |
| 16 | Navier–Stokes | Finite droplet · encode a continuum-valued attribute (e.g. a neck radius resolvable at every scale): **impossible** · our Lean theorem: a finite substrate has no continuum information variable (`no_continuum_info_variable_of_finite`, `finite_substrate_misses_interval`) | **Derived** (toy, in Lean; from the CT definition of information variables) | The PDE, the pinch-off similarity solutions, and η. Pinch-off is atomistic, not quantum (Moseler & Landman 2000) |
| 17 | Einstein field equations (c-number metric) | Gravitational field as a mediator between two masses · locally create entanglement between them: **possible** ⇒ gravity has non-commuting variables (it is a superinformation medium, non-classical) · Marletto–Vedral witness theorem | **Published** (PRL 119, 240402; PRD 102, 086012) | The field equations themselves. The witness only decides classical vs non-classical |
| 18 | Unregulated QFT (UV) | No CT restatement. The problem is divergent integrals in a dynamical theory that is already quantum | **Not expressible yet** | Renormalised couplings and running |
| 19 | Classical spin | Spin-½ · prepare S_x and S_z both sharp: **impossible** · superinformation (D–M 2015). Lean, in the quantum model: `pauliX_mul_pauliZ_ne`, `no_common_eigenvector` | **Published** | g-factor, ±ħ/2 |
| 20 | Bell local hidden variables | Two separated substrates · information that is locally inaccessible (entanglement) exists · D–M 2015 abstract derives "locally inaccessible information" from superinformation. Locality principle: Deutsch 2013 | **Published** (qualitative core) | The CHSH bound 2√2 (Tsirelson). CT does not fix it |
| 21 | Classical measurement (no disturbance) | System + meter · measure a variable without perturbing a complementary one: **impossible** · D–M 2015 ("irreducible perturbation caused by measurement"). Deterministic yet unpredictable outcomes: Marletto 2016 (probability) | **Published** | The error–disturbance trade-off (Ozawa) as an inequality |
| 22 | Universal copying | Superinformation medium · clone the union of two complementary variables: **impossible**. Copying *is* possible for any single information variable · D–M 2015 (no-cloning of superinformation). Lean: in the deterministic theory every variable is an information variable, so there is no superinformation (`functional_no_superinformation`) | **Published** (Lean: the classical half) | Optimal approximate cloning fidelities |

**Counts**: **Published 7** (1, 15, 17, 19, 20, 21, 22), **Derived 3** (2, 8, 16),
**Conjecture 8** (4, 5, 6, 7, 9, 10, 11, 14), **Not expressible yet 4** (3, 12, 13, 18).

## The honest bottom line

1. **CT restates the qualitative core of 10 of the 22 laws** (7 Published + 3 Derived). These are
   exactly the rows whose breakdown pattern is *joint sharpness*, *universal
   distinguishability/copying* or *local realism* (P2, P4, P3 in `PATTERN.md`), plus row 16 via
   the toy P6 droplet theorem. In those rows the
   classical law assumed a task was possible, and CT's superinformation principle says it is not.
2. **The continuum/quantisation rows (4, 5, 6, 7, 9) are only conjectures.** CT has no published
   derivation of discrete energy exchange or of ħ. Marletto's thermodynamics gives conservation
   (principle VIII) and is-like classes, but not their spacing. This is the biggest gap. It is
   also where Ben's thesis most needs CT, since P1 ("continuum") is the most common breakdown tag
   (14 of 22).
3. **Rate, spectrum and transport laws (3, 12, 13, 18) are not expressible yet.** CT talks about
   possible/impossible tasks. A coefficient like σ or κ is not a task. The CT time paper and the
   2026 dynamical-consistency paper are steps towards that, not a solution.
4. **Every row loses its numbers.** The CT form is the robust core. The q-number form
   (`QNUMBER.md`) is what gives back the quantitative law and the classical limit. The two are
   complementary, not rivals: CT says *which tasks are impossible*, and q-number dynamics says
   *by how much*.

## Link to Ben's thesis

Ben's thesis (`THESIS.md`): "The fact that there are mathematical description of phenomenon
breaking down at the quantum level suggests that the mathematical description is incorrect."

- The CT restatement **separates** each law into (a) a statement about impossible tasks and
  (b) a dynamical description. Across the 10 rows CT can express, it is always (b), the
  continuum-valued or jointly-sharp description, that fails at the quantum level. The
  impossible-task statement (a) is what survives, unchanged, across the classical → quantum
  transition.
- That is the thesis in a sharper form. **The mathematics broke because it encoded possible tasks
  that are physically impossible.** The impossible-task core is the robust part that survives.
- The rows CT cannot yet express (Conjecture or Not expressible) are an honest limit. For them
  the thesis rests on the q-number evidence in `QNUMBER.md`, not on CT.

## Lean

`ConstructorTheory/CTRestatement.lean` (toy; no `sorry`, no new axioms):

| Theorem | Row(s) | Statement |
|---|---|---|
| `functional_every_variable_info` | 22 | In the deterministic (classical) theory, every variable is an information variable: copying is always possible |
| `functional_no_superinformation` | 1, 19, 21, 22 | The deterministic theory has no superinformation medium. Superinformation, and so no-cloning and complementarity, needs non-classical constructors |
| `conserved_change_impossible`, `conserved_change_impossible_both` | 4–7 (principle VIII ingredient) | In a toy thermodynamic theory whose constructors conserve U, changing U is impossible in both directions (perpetual motion of the first kind) |
| `monotone_decrease_impossible` | 14, 15 | Decreasing an entropy-like monotone is impossible (a law of impotence) |
| `irreversible_of`, `thermo_irreversible_example` | 15 | A task can be possible while its transpose is impossible. A two-state example shows this is not vacuous |

Earlier modules used here: `no_continuum_info_variable_of_finite` and
`finite_substrate_misses_interval` (row 16); `pauliX_mul_pauliZ_ne` and `no_common_eigenvector`
(row 19).

**Not proved in Lean.** We don't prove that quantum theory *is* a superinformation theory, which
needs a Hilbert-space constructor model. That would be the natural next milestone.
