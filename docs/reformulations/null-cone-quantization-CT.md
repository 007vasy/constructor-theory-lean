# Chandrasekaran's null-cone quantization of gravity, restated in constructor theory

Source: Venkatesa Chandrasekaran, *An algebraic quantization of gravity from the null cone*,
[arXiv:2611.34924](https://arxiv.org/abs/2611.34924) (23 November 2026), 83 pp. All section,
equation and footnote numbers below refer to that paper. Read in full (§§1–6, Appendices A–E) on
27 November 2026 (Australia/Sydney). The section on time (§5 below) also uses David Deutsch and
Chiara Marletto, *Constructor theory of time*,
[arXiv:2505.08692](https://arxiv.org/abs/2505.08692) (v3, June 2026), published as
[J. Phys. Commun. 10 (2026) 115003](https://doi.org/10.1088/2399-6528/aebd39). Its numbered
conditions (8), (9) and (10) are cited as "D&M (8)" and so on. Read in full (§§1–9) from the arXiv
version.

**Dependency.** §6 and §7 use `SpeedLimit.orthogonal_family_finite` from `SpeedLimit.lean`. That
file is on branch `next-steps` ([PR #6](https://github.com/007vasy/constructor-theory-lean/pull/6))
and is **not yet on `main`**. They also use `FDOn` and `PerfectlyDistinguishes` from
`ClosingTheGap.lean` (on `main`).

> **Retry with a future model.** This is a first pass. It *reframes* the paper's results in
> constructor-theoretic (CT) language. It does not derive those results from CT principles, and it
> adds no `.lean` file to the repo. Equation references were taken from a text extraction of the
> PDF. An independent review spot-checked about 30 of them and found them correct, but they should
> still be checked against the typeset PDF. A later pass with a stronger model should:
> (1) try to derive §5.2 finite-dimensionality from CT principles, starting from the paper's own
> axioms for Lorentzian amplitudes (App. E, E.1–E.5), rather than translate it;
> (2) look for a non-asymptotic explicit bound on `dim H_D`. The paper bounds the *area*, not the
> dimension, in (5.21d). Its dimension counts are asymptotic (5.64) or one-loop (D.46c);
> (3) move the Lean sketch in §7 into the repo once PR #6 lands, and connect it to the timer
> vocabulary of D&M (§5 below);
> (4) check whether adding matter, which the paper leaves out in 4D, gives a CT statement about
> the Marletto–Vedral witness or BMV rates.

## 0. What the paper actually is (for orientation)

- **Vacuum general relativity only.** The 4D reduced phase space (3.19) is defined by
  `R_ab = Λ g_ab`. The only matter is a scalar in the 2D JT warm-up (§2, (2.2)).
- **Construction.** First-order (Plebański) gravity (3.2)–(3.5). The null constraints
  (Raychaudhuri (3.25), (3.57)) are solved on the two null cones of a capped causal diamond. The
  free data are the conformal metric (two graviton polarisations) and the corner edge modes: area
  density `K(y) = ϱ_S²/8πG`, which is conjugate to the relative boost ((3.42)–(3.43),
  (3.63)–(3.66)), plus angular data (A.15). These are quantized at finite `G_N` (§4.1–4.2). The
  Hilbert space comes from a **chosen** Gaussian state (4.7) and a **chosen** pure extension `ω`
  (4.16). The algebra is a type I factor ((4.11), (4.17)).
- **Diffeomorphism invariance.** The amplitude must not depend on where, or whether, an
  intermediate cut is made (abstract; Fig. 28; the composition law (4.29); App. E axiom 1). The
  §5.2 finiteness proof turns on exactly this requirement.
- **Results.** Unitary, absolutely convergent composition ((4.18), (4.29)–(4.31)). Finite graviton
  pair creation (4.33), versus a `log N` divergence when expanded in `G_N` (4.34). A
  finite-dimensional causal-diamond Hilbert space `H_D = 1[0,ℓ(D)](ū*) H_ω` ((5.1)–(5.2),
  (5.38)–(5.39c)). A discrete area spectrum (5.40). The entropy (5.50), (5.65) with `q = 257/302`
  (5.68), which reproduces Sen's 106/45 at fixed mass (5.69). Connected-topology states are
  null-equivalent to sums of product states ((5.73)–(5.74)). The semiclassical Einstein equations
  through one loop ((6.4), (6.13), (D.12)). An axiomatic Lorentzian formulation equivalent to the
  Euclidean axioms (App. E).

## 1. Substrates and attributes

| CT notion | In the paper |
| --- | --- |
| Substrate `D` | A capped causal diamond `D : Σ₀ → Σ₁` (Fig. 7), with reduced phase space `P(D)` (3.19). It is glued into larger regions by (3.29)–(3.31). |
| Sub-substrates | The incoming null cone `H_p` and its cap. The corner `S`. The edge modes: frame `e_Σ`, boost angle `Γ`, angular map `Y`. |
| States | Vectors of `H_ω` (4.16). The diamond's state space is `H_D` (5.1). |
| Attribute "clock ≤ ℓ" | The spectral projector `P_D = 1[0,ℓ(D)](ū*)` (5.2). |
| Attribute "area in J" | `1_J(Â)` ((4.12)–(4.14)). It commutes with `P_D` (5.21). |
| Variables / observables | The C*-algebra `A` built from deformations of the reduced action ((4.1)–(4.2e)), defined before any state is chosen. |
| Composition | Spatial gluing is the entangling product (§4.4, (3.64)). Temporal gluing is (4.29). |

## 2. Tasks: what each result becomes

**Scope of L-NC1.** The finiteness result is proved for **macroscopic** diamonds, using a one-loop
two-point function around a smooth classical background. The scale hierarchy is
`ℓ_P ≪ Δu ≪ d ≪ b ≪ R_c` (5.26): smearing width, insertion distance, corner radius, curvature
radius. Footnote 22 extends the conclusion only to *shorter* clock intervals inside such a
diamond. It does not cover Planck-scale or strongly curved diamonds.

| # | Result (paper) | CT restatement | Status |
| --- | --- | --- | --- |
| T1 | `dim H_D < ∞` for finite `ℓ(D)` ((5.38)–(5.39c)). | **Impossible:** perfectly distinguishing infinitely many attributes of a macroscopic diamond whose clock attribute is `≤ ℓ`. | Reframing. The proof is the paper's. It rests on diffeomorphism invariance of the amplitude (Fig. 28, (4.29)), a one-loop two-point function ((5.27)–(5.29), App. D.2), a fixed `ω` (footnote 20), and a state-existence step that is "strong evidence" with a heuristic (5.19, footnote 18). |
| T1′ | In JT gravity, a bounded diamond has infinitely many orthogonal states ((2.14)–(2.15)), and `Tr W = ∞` (2.17). | The same task is **possible** in JT. T1 depends on 4D shear–focusing (opening of §3, Fig. 9). | Genuine "hard to vary" evidence. |
| T2 | Area bound `0 ≤ P_D Â P_D ≤ 4πℓ(D)²/(1−ε)² P_D` (5.21d). There are at most `d_D` distinct areas (5.40). | No state has both the attribute "clock ≤ ℓ" and the attribute "area > 4πℓ²/(1−ε)²". | Reframing. The bound itself is classical: Cauchy–Schwarz and `Ξ ≥ 0` ((5.21a–c)). |
| T3 | Explicit counting. For large black-hole interiors only: `dim 1[0,a s*](ŝ) H_D = exp[a s* + o(s*)]`, `s* = πℓ²/((1−ε)²ℓ_P²)` ((5.64), footnote 24). One-loop, per area value: `log d(s) ≲ 1 + (sQ*)^{3/4}` (D.46c). | Conjectured quantitative law L-NC2: at most `≈ exp(πℓ²/((1−ε)²ℓ_P²))` distinguishable attributes. | **Not proved in general.** At the start of §5 the paper says only that the covariant entropy bound "suggests" it. |
| T4 | Graviton pair creation and annihilation is finite at every `G_N > 0`: `Li₂(e^{−2i/s})/(2s²)` with `s = A/4Għ` (4.33). | A finite-amplitude transformation of the null-cone substrate. | Weak as CT. The annihilation phase `e^{−2ik/s}` is **chosen** through a boundary unitary (Fig. 20, footnote 17). |
| T5 | Unitary composition: absolute convergence (4.30), independence from subdivision (4.31). | A concrete realisation of the serial composition principle. | Supportive. Mathematically this is Cauchy–Schwarz. |
| T6 | `S(ρ_D) = ⟨Â⟩/4Għ + log Z_{D,1}` (5.50), log coefficient `q/(2(1−q))` (5.65), `q = 257/302` (5.68), 106/45 at fixed `M` (5.69). | `S(ρ_D) ≤ log d_D`, so `e^{S(ρ_D)}` is a **lower bound** on the number of distinguishable attributes, not a count. The only count is the (5.64) asymptotics in T3. | Reframing. The log coefficient uses the same trace-anomaly / Gauss–Bonnet coefficient as Sen (5.67c, ref. [71]). The Lorentzian trace route and the conversion through `q` are new. |
| T7 | Semiclassical limit ((6.1)–(6.4), (6.13)). | Classical dynamics emerges in the `ħ → 0` limit. | Standard. Neutral for CT. |
| T8 | A connected filling equals a sum of products up to null states (5.73). `K_Σ ≅ H_Σ ⊗ H_Σ*` (5.74). | Composite states are compositions of the parts' states. | Supports locality. |
| T9 | App. E: Lorentzian axioms for amplitudes (E.1–E.5), equivalent to the Euclidean ones when the cylinder has finite trace (E.2). Realised in first-order gravity (E.3), using `d_D < ∞` (E.17). | Laws stated as conditions on amplitudes of closed configurations. This is the most axiomatic, least dynamical part of the paper. | The natural input for a CT derivation (see the retry note). Not yet translated. |

## 3. Which CT principles each result uses

| Principle | Where it shows up | Verdict |
| --- | --- | --- |
| Interoperability of information | Not addressed. | Neutral. |
| Superinformation (information variables whose union is not an information variable) | The type I factor `B(H_D)` (5.20). Non-commuting insertions connect different area eigenspaces (5.41). | Consistent, because it is quantum. Not derived. |
| Locality (Deutsch–Hayden; D&M §3 form) | The type I factor and factorisation (5.74) **support** it. But gluing is an entangling product that keeps only charge-matched states (§4.4), observables are dressed to corner frames (§3.5), and deformations "may be nonlocal" across a boundary (§4.1). | Mixed. |
| Counterfactuals | The algebra comes before the state (§4 intro). Conditional probabilities appear in (5.3). | Neutral. Defining the algebra first is a formal convenience, not a counterfactual law. |
| Reference-state / representation dependence | The Gaussian centres and widths ((4.7), footnote 13) and the pure extension `ω` (4.16) are chosen. Unitary equivalence across choices of `ω` is deferred (footnote 20). | Open question: do the CT-level results (T1, T2) depend on the representation? This is **not** a violation of no-design. |
| Diffeomorphism invariance (amplitudes independent of cuts) | Fig. 28, (4.29), App. E axiom 1. | **The most CT-friendly input.** It is a timeless consistency condition on compositions, not a dynamical law. |
| Marletto–Vedral witness | No 4D matter. The only entanglement is gravity–gravity in the thermal state ((5.75)–(5.77)). | Neutral for BMV. |
| Composition principle (`Possibility.lean`) | (4.2e), (4.29)–(4.31). | Supportive. |

## 4. What does not translate cleanly

| Element | Why it resists CT |
| --- | --- |
| Lorentzian path integral (4.5) and Schwinger–Keldysh one loop ((D.1)–(D.12)) | It is the dynamics-plus-initial-state framing. The CT content lies only in the conclusions (T1, T2, T5). |
| Gaussian state (4.7) and `ω` (4.16) | Representation inputs. Whether the results depend on them is open (footnote 20). |
| Reference-frame dressing (§3.5, (3.58)–(3.59)) and edge modes | Attributes are defined relative to a dynamical frame at `S`. CT would need a frame substrate. D&M §6 anticipates this: "the spacetime region … must appear as an additional substrate". |
| Finiteness proved by perturbative contradiction (§5.2, D.2) | The statement is nonperturbative, but the proof uses a one-loop expansion within the hierarchy (5.26). |
| Pair-creation phase (Fig. 20) | It is a chosen boundary unitary, not a law. |
| Born-rule probabilities ((4.19b), (5.3)) | D&M §2 say probability has no exact CT meaning. Statements must be about tasks on density-operator variables. |

The clock operator is no longer listed here. It is mapped onto D&M timers in §5.

## 5. The light-ray clock as a constructor-theoretic timer (Deutsch & Marletto)

**D&M in brief.**
- A *null constructor* is a constructor for the null task `{ }`. D&M §5 derive that it is possible
  from the composition principle.
- It must be an **isolated** substrate (D&M §4): the possibility of tasks on it depends only on
  its own attributes.
- It has attributes `0` (start, non-static), `R` (running, non-static), `1` (done, **static**), and
  a distinguishable **halt flag**.
- `C_t` is the set of timers of duration `t`. Conditions:
  - D&M (8): `((0,0) → (1,1) on [C_t ⊕ C_t'])` is impossible for `t' > t`.
  - D&M (9): it is possible iff `t = t'`.
- So a duration is the **label of an equivalence class** of timers.
- Isolated identical timers stay synchronous: `(x,x)` can only become `(y,y)` (D&M §6).
- D&M expect GR, once recast in CT form, to treat "the spacetime region … as an additional
  substrate".

**Mapping Chandrasekaran's clock (3.27).**

| D&M timer | Light-ray clock | Fit |
| --- | --- | --- |
| Start attribute `0` | The cap cut `∂Σᵢ`, where the affine parameter is zero and the slope `p_{ε,y}` is fixed ((3.26d), (3.27)). | Good |
| Running `R` | Being on a null generator strictly between `∂Σᵢ` and `S`. | Good, classically |
| Done `1`, and the halt flag | Reaching the corner area element `ϱ_S(y)` at `S`. The one-bit halt flag for duration `ℓ` is the projector `1[0,ℓ](ū*)` (5.2). It and its complement are orthogonal, hence distinguishable. | Good: the bit is a sharp, distinguishable attribute |
| Duration independent of description | `ū*` does not change when `u` is rescaled ((3.27): the change in `u` times `p_{ε,y}`). Rescaling all lengths rescales the reading (§5.3, before (5.54)). | Good: duration belongs to the class, not to a parametrisation |
| D&M (8): different durations cannot halt together | `Ξ_y ≥ 0` (3.26c), with `Ξ = 0` only without shear. With the same initial area element and expansion, a sheared generator reaches a given `ϱ_S(y)` strictly later than a shear-free one (Fig. 9, Fig. 17). The radiation is part of the clock's own state, so a sheared clock is a *different timer*, not a tampered one. | Good analogue, classical and per generator |
| D&M (9) and synchrony | Identical characteristic data give identical readings, because the data determine the domain of dependence (§3.2, refs [21, 45]). Two copies with the same data halt together. | Good, classically. Quantum mechanically the readings superpose (Fig. 17), and D&M's exact determinism would need a restatement on density operators. |
| Isolation | Inside its domain of dependence, the reading depends only on data on `H_p ∪ Σ₀`. But the quantum diamond is glued to its neighbours through charge-matched edge modes ((3.64), §4.4), its attributes are dressed to the corner frame (§3.5), and `H_ω` depends on the global choice of `ω` (4.16). | **Partial.** Causally isolated classically. Not obviously isolated in D&M's sense quantum mechanically. |
| Timer as a self-transformation `0 → R → 1` | The reduced phase space is timeless. One state contains the whole null cone, so `0`, `R` and `1` are attributes of **different cuts** (sub-substrates) of one state, not successive attributes of one substrate. | **Main misfit.** The light-ray clock is closer to a stopwatch *read-out* of elapsed affine time than to a running timer. |
| Static `1` | By D&M footnote 3, a *finite* system cannot have a strictly static attribute, because of Poincaré recurrence. `d_D < ∞` (5.39c) therefore means any timer realised **inside** one bounded diamond is only approximately a timer. | Tension. Interesting rather than fatal. |
| Dynamics relative to a timer (D&M (10)–(11)) | Evolution between caps is generated by `H_c` (3.53b). The lapse along the null cone depends on shear through the same `Ξ` ((3.55), Fig. 11). | Fits D&M's picture: variables change relative to a timer whose rate depends on the radiation |
| Spacetime region as a substrate | The causal diamond with frame edge modes is exactly such a substrate (§3, Fig. 7). | Good: it realises D&M's §6 expectation |

**L-NC1 in timer units.** Let `C_ℓ` be the class of light-ray timers whose halt bit is
`1[0,ℓ](ū*)`. Then:

> For every macroscopic causal-diamond substrate whose light-ray timer has halted by a timer of
> class `C_ℓ`, perfectly distinguishing an infinite family of its attributes is impossible.

The resource is a **duration** measured by an equivalence class of timers, not an energy. L-NC2
then reads `card ≲ exp(π ℓ² / ((1−ε)² ℓ_P²))`. This needs `ℓ_P = √(Għ)` expressed in the same
timer class. Constructor theory does not supply that conversion. It comes from the dynamics.

## 6. Link to our three forbidden tasks

- **(b) unbounded distinguishability at bounded resources.**
  - `SpeedLimit.orthogonal_family_finite` (PR #6) proves FD *given* a finite-dimensional bounded
    subspace, and flags that as "an assumption about the Hamiltonian".
  - Chandrasekaran's (5.39c) **would conditionally discharge** that proviso on the gravity side,
    with `W = H_D` and the resource being size or duration (§5 above), not energy.
  - "Conditionally" means: one-loop input ((5.27)–(5.29)), the heuristic step (footnote 18), a
    fixed `ω` (footnote 20), and macroscopic diamonds only (5.26).
  - The dynamical half (the speed limit, `orthogonal_steps_le`) has no counterpart in the paper.
- **(a) superinformation.** Consistent with the type I factor. Nothing new.
- **(c) symmetrisation.** Not touched. Bosonic gravitons (4.10c) are an input.
- **Variation test.** T1′ (JT): remove 4D shear–focusing and task (b) becomes possible again.

## 7. Candidate law and Lean sketch (Markdown only; no `.lean` file in this PR)

**L-NC1 (qualitative; matches (5.39c), scoped by (5.26)).** For every macroscopic causal-diamond
substrate `D` and every clock bound `ℓ`, perfectly distinguishing an infinite family of non-empty
attributes inside `1[0,ℓ](ū*)` is impossible.

**L-NC2 (quantitative, conjectural; matches (5.64) only asymptotically).**
`card ≤ exp(π ℓ² / ((1−ε)² ℓ_P²) + o(ℓ²/ℓ_P²))`.

**Status of the code below.**
- It was **type-checked, with no `sorry`**, in a scratch build on the Grok Bot box: Lean
  `v4.36.0` with the repo's Mathlib cache.
- `#print axioms` reports only `propext`, `Classical.choice` and `Quot.sound` for both theorems.
- The scratch file contained verbatim copies of `readout`, `PerfectlyDistinguishes`, `shell`,
  `FDOn` (`ClosingTheGap.lean`, `main`) and `orthogonal_family_finite` (`SpeedLimit.lean`, PR #6).
  It used plain `import`s, not the repo's `module` / `public import` layout.
- It is **not** in the repo, and the repo harness has not been run on it.

```lean
-- ASSUMED STRUCTURE: a Hilbert space with monotone, right-continuous clock shells
-- ℓ ↦ range 1[0,ℓ](ū*), trivial for ℓ < 0 (the clock is nonnegative).
structure ClockedSubstrate where
  H : Type
  [nacg : NormedAddCommGroup H]
  [ips : InnerProductSpace ℂ H]
  clockShell : ℝ → Submodule ℂ H
  mono : Monotone clockShell
  bot_of_neg : ∀ ℓ < 0, clockShell ℓ = ⊥
  rightCont : ∀ ℓ (v : H), (∀ ℓ' > ℓ, v ∈ clockShell ℓ') → v ∈ clockShell ℓ

attribute [instance] ClockedSubstrate.nacg ClockedSubstrate.ips

namespace ClockedSubstrate
variable (D : ClockedSubstrate)

/-- Substrate (`Substrate := Type`): nonzero vectors with some finite clock reading.
Zero is excluded because `orthogonal_family_finite` needs `v i ≠ 0`. -/
def S : Substrate := {v : D.H // v ≠ 0 ∧ ∃ ℓ, v ∈ D.clockShell ℓ}

/-- The clock as a real function on states, as `FDOn` needs. -/
noncomputable def clock (s : D.S) : ℝ := sInf {ℓ | s.1 ∈ D.clockShell ℓ}

theorem nonneg_of_mem {v : D.H} (hv : v ≠ 0) {ℓ : ℝ} (h : v ∈ D.clockShell ℓ) : 0 ≤ ℓ := by
  by_contra hl
  rw [D.bot_of_neg ℓ (lt_of_not_ge hl)] at h
  exact hv ((Submodule.mem_bot ℂ).1 h)

/-- PROVED: the sublevel sets of `clock` are exactly the clock shells (uses `rightCont`). -/
theorem mem_shell_iff (s : D.S) (e : ℝ) : s ∈ shell D.clock e ↔ s.1 ∈ D.clockShell e := by
  have hne : ({ℓ | s.1 ∈ D.clockShell ℓ} : Set ℝ).Nonempty := s.2.2
  have hbdd : BddBelow {ℓ | s.1 ∈ D.clockShell ℓ} := ⟨0, fun ℓ h => D.nonneg_of_mem s.2.1 h⟩
  constructor
  · intro h
    apply D.rightCont
    intro ℓ' hℓ'
    obtain ⟨a, ha, hlt⟩ := exists_lt_of_csInf_lt hne (lt_of_le_of_lt h hℓ')
    exact D.mono hlt.le ha
  · intro h
    exact csInf_le hbdd h

/-- Readouts with disjoint outputs require elementwise-orthogonal inputs. -/
def OrthPairs (P : Set (Attribute D.S × Attribute D.S)) : Prop :=
  ∀ p ∈ P, ∀ q ∈ P, Disjoint p.2 q.2 → ∀ a ∈ p.1, ∀ b ∈ q.1, ⟪a.1, b.1⟫_ℂ = 0

/-- MODELLING CHOICE Θ_q ("distinguishable iff orthogonal"): on the diamond a constructor is any
set of pairs respecting `OrthPairs`. On other substrates the condition is vacuous. -/
def Θq : Theory where
  Constructor S := {P : Set (Attribute S × Attribute S) // ∀ h : S = D.S, D.OrthPairs (h ▸ P)}
  performs C := C.1

end ClockedSubstrate

/-- ASSUMED PHYSICS: Chandrasekaran (5.39c), every clock shell is finite-dimensional. -/
structure NullConeDiamond extends ClockedSubstrate where
  finiteDim : ∀ ℓ, FiniteDimensional ℂ (toClockedSubstrate.clockShell ℓ)

namespace NullConeDiamond
open ClockedSubstrate
variable (D : NullConeDiamond)

/-- PROVED: L-NC1, i.e. `FDOn` for the diamond with the clock as the resource. -/
theorem fd : FDOn D.Θq D.S D.clock := by
  intro e
  have := D.finiteDim e
  refine ⟨Module.finrank ℂ (D.clockShell e), fun ι x hne hE hD => ?_⟩
  obtain ⟨o, -, hdisj, C, hC⟩ := hD
  have horth : D.OrthPairs C.1 := C.2 rfl
  let v : ι → D.H := fun i => (hne i).some.1
  have hmem : ∀ i, (hne i).some ∈ x i := fun i => (hne i).some_mem
  refine SpeedLimit.orthogonal_family_finite (D.clockShell e) v
    (fun i => (D.mem_shell_iff _ e).1 (hE i (hmem i))) (fun i => (hne i).some.2.1) ?_
  intro i j hij
  exact horth _ (hC ⟨i, rfl⟩) _ (hC ⟨j, rfl⟩) (hdisj hij) _ (hmem i) _ (hmem j)

end NullConeDiamond

/-- JT-style stand-in: every nonnegative clock shell is all of ℓ²(ℕ). This is NOT the JT
Hilbert space L²([0,ℓ]) ⊗ H_φ of (2.13c). It is an infinite-dimensional stand-in for it. -/
noncomputable def jt : ClockedSubstrate where
  H := lp (fun _ : ℕ => ℂ) 2
  clockShell ℓ := if 0 ≤ ℓ then ⊤ else ⊥
  -- mono, bot_of_neg, rightCont: short case splits (see scratch file)

/-- PROVED: FD fails for the stand-in. The basis vectors `lp.single 2 n 1` at clock reading 0
are perfectly distinguishable and infinitely many. -/
theorem jt_not_fd : ¬ FDOn jt.Θq jt.S jt.clock
```

The two field proofs for `jt` and the proof of `jt_not_fd` (about 40 lines) are left out above.
They were checked in the same scratch build.

| | Assumed | Proved |
| --- | --- | --- |
| Physics | `finiteDim` (all of §5.2, with its one-loop / `ω` / (5.26) caveats). `mono`, `bot_of_neg` and `rightCont` (properties of a spectral family of the positive operator `ū*`, (4.27), C.2). | — |
| Modelling | `Θq`: "a readout is possible iff its inputs are elementwise orthogonal". Zero is excluded from the substrate. | — |
| Lean | — | `mem_shell_iff` (sublevel sets = shells), `NullConeDiamond.fd` (L-NC1 as `FDOn`), `jt_not_fd` (FD fails for an infinite-dimensional stand-in) |

**Honest assessment.** L-NC1 in Lean is a short corollary of `orthogonal_family_finite`. All the
gravity sits in the hypothesis `finiteDim`. Its value is bookkeeping: it shows exactly which
hypothesis of `SpeedLimit.lean` a quantum-gravity theory would have to discharge, and that this
paper claims to discharge it under stated conditions. L-NC2 cannot be stated as a theorem from the
paper. `jt_not_fd` uses ℓ²(ℕ), not the actual JT space (2.13c).

## 8. Bottom line

The finite causal-diamond Hilbert space would conditionally discharge the finite-dimensionality
proviso behind our forbidden task (b). The resource is size, which D&M's timers let us read as a
duration. The paper's diffeomorphism-invariance requirement and its App. E axioms are the most
CT-friendly parts. The path integral, the chosen representation and the frame dressing are not CT,
so the CT version is a reframing, not a derivation. The paper is vacuum gravity: no matter
coupling, no witness rates, and nothing that moves the BMV finish line.
