# Chandrasekaran's null-cone quantization of gravity, restated in constructor theory

Source: Venkatesa Chandrasekaran, *An algebraic quantization of gravity from the null cone*,
[arXiv:2611.34924](https://arxiv.org/abs/2611.34924) (23 November 2026), 83 pp. All section and
equation numbers below refer to that paper. Read in full (§§1–6, Appendices A–E) on
27 November 2026 (Australia/Sydney).

> **Retry with a future model.** This is a first pass. It is a *reframing* of the paper's results
> in constructor-theoretic (CT) language. It is not a derivation of those results from CT
> principles, and it contains no new Lean code. A later pass with a stronger model should:
> (1) re-check every equation reference against the PDF (this pass worked from `pdftotext`
> output, where the equations were garbled); (2) try to derive the finite-dimensionality of a
> causal diamond (§5.2) from CT principles, rather than translate it; (3) try to get a
> non-asymptotic explicit bound on `dim H_D` (the paper gives only (5.21d), (5.64) and (D.46));
> (4) write the Lean statements in §6 below, with complete proofs and no `sorry`, against
> `ClosingTheGap.FDOn` and `SpeedLimit.orthogonal_family_finite`; (5) check whether adding matter
> (which the paper leaves out in 4D) gives a CT statement about the BMV witness.

## 0. What the paper actually is (for orientation)

- **Vacuum general relativity only.** The 4D reduced phase space (3.19) is defined by
  `R_ab = Λ g_ab`. The only matter is a scalar in the 2D JT warm-up (§2, (2.2)). Nothing in 4D
  couples to masses, so there is no BMV set-up.
- **Construction.** First-order (Plebański) gravity (3.2)–(3.5). Solve the null constraints
  (Raychaudhuri (3.25), (3.57)) on the two null cones of a capped causal diamond. The free data
  are the conformal metric (two graviton polarisations) plus corner edge modes: area density
  `K(y) = ϱ_S²/8πG`, which is conjugate to the relative boost (3.42)–(3.43), (3.63)–(3.66), and
  angular data (A.15). Quantize at finite `G_N` (§4.1–4.2). The Hilbert space is built from a
  **chosen** Gaussian state (4.7) and a **chosen** pure extension `ω` (4.16). The algebra is then a
  type I factor (4.11), (4.17).
- **Gravitational clock.** `ū*` is the angle-averaged affine parameter from the cap to the corner
  (3.27), (3.28), (4.26). Shear can only *increase* it (`Ξ ≥ 0`, (3.26c), (4.22)).
- **Results.** Amplitudes are unitary and the sums over intermediate states converge absolutely
  ((4.18), (4.29)–(4.31); Cauchy–Schwarz). Graviton pair creation is finite (4.33), although the
  `G_N` expansion diverges like `log N` (4.34). The causal-diamond Hilbert space
  `H_D = 1[0,ℓ(D)](ū*) H_ω` (5.1)–(5.2) is finite-dimensional ((5.38)–(5.39), proof by
  contradiction). The area spectrum is discrete (5.40). There is a Bekenstein–Hawking term with a
  log correction (5.50), (5.65), with `q = 257/302` (5.68), which gives Sen's 106/45 at fixed mass
  (5.69). Connected-topology states are null-equivalent to sums of product states (5.73)–(5.74).
  The semiclassical Einstein equations hold through one loop ((6.4), (6.13), (D.12)).

## 1. Substrates and attributes

| CT notion | In the paper |
| --- | --- |
| Substrate `D` | A capped causal diamond `D : Σ₀ → Σ₁` (Fig. 7), described by its reduced phase space `P(D)` (3.19). Larger regions are built by gluing ((3.29)–(3.31)). |
| Sub-substrates | The incoming null cone `H_p` with its cap; the corner `S`; the edge modes (frame `e_Σ`, boost angle `Γ`, angular map `Y`). |
| States | Vectors of `H_ω` (4.16). The CT substrate state space is `H_D` (5.1). |
| Attribute "size ≤ ℓ" | The spectral projector `P_D = 1[0,ℓ(D)](ū*)` (5.2). This is how the paper says "a causal diamond of a given maximum size". |
| Attribute "area in J" | `1_J(Â)`, defined using the boost (4.12)–(4.14). It commutes with `P_D` (5.21). |
| Observables (variables) | The C*-algebra `A` from deformations of the reduced action (4.1)–(4.2e). It is defined *before* any state is chosen, which suits CT. |
| Composition | Spatial gluing is the "entangling product" (§4.4, (3.64)): states on `S` matched and quotiented by the common boost. Temporal gluing is (4.29). |

## 2. Tasks: what each result becomes

| # | Result (paper) | CT restatement | Status |
| --- | --- | --- | --- |
| T1 | `dim H_D < ∞` for every finite `ℓ(D)` ((5.38)–(5.39c)). | **Impossible:** perfectly distinguishing infinitely many attributes of a causal diamond of bounded clock reading `ℓ`. Equivalently, every distinguishable set of attributes of such a `D` is finite. | Reframing. The proof is the paper's, not CT's. It is conditional on the chosen `ω` (footnote 20) and on a one-loop two-point function around a smooth background ((5.27)–(5.29), App. D.2). The existence of a state (5.19) is "strong evidence" with a heuristic step (footnote 18), not a full proof. |
| T1′ | The 2D contrast: in JT gravity a bounded diamond has infinitely many orthogonal states (2.14)–(2.15), and `Tr W = ∞` (2.17). | The same task is **possible** in JT gravity. So T1 is not generic. It comes from 4D shear–focusing (Raychaudhuri), §3 opening and Fig. 9. | Genuine "hard to vary" evidence: change the dimension and the impossibility goes away. |
| T2 | Area takes at most `d_D` values (5.40), bounded by `A ≤ 4πℓ(D)²/(1−ε)²` (5.21d). | **Impossible:** preparing a bounded diamond whose corner area exceeds `4πℓ²/(1−ε)²`, or whose area attribute has a continuum of values. | Reframing. The bound itself is classical: Cauchy–Schwarz plus `Ξ ≥ 0`, (5.21a–c). |
| T3 | Explicit counting. Only asymptotically, for large black-hole interiors: `dim 1[0,a s*](ŝ) H_D = exp[a s* + o(s*)]`, with `s* = πℓ²/((1−ε)² ℓ_P²)` ((5.64), footnote 24). One-loop per-area bound `log d(s) ≲ 1 + (sQ*)^{3/4}` (D.46c). | Conjectured quantitative law: no constructor distinguishes more than `≈ exp(A_max(ℓ)/4Għ)` attributes of `D`. | **Not proved in general.** The paper says only that the covariant entropy bound "suggests" this (§5 opening). Treat it as a conjecture. |
| T4 | Graviton pair creation and annihilation on one null cone is finite at every `G_N > 0`: `Li₂(e^{−2i/s})/(2s²)`, `s = A/4Għ` (4.33). | Possible task: a finite-amplitude pair-creation/annihilation transformation of the null-cone substrate. | Weak as CT. The annihilation phase `e^{−2ik/s}` is **chosen** by a boundary unitary (Fig. 20 and footnote 17), so the finiteness depends on that choice. This is about the order of limits, not a principle. |
| T5 | Unitary composition. Absolute convergence (4.30) and subdivision independence (4.31). | The composition principle for tasks (serial composition of possible tasks is possible), realised in a concrete model. | Supports CT's serial composition. Mathematically this is Cauchy–Schwarz in any Hilbert space. |
| T6 | Entropy `S(ρ_D) = ⟨Â⟩/4Għ + log Z_{D,1}` (5.50), with log coefficient `q/(2(1−q))` (5.65), `q = 257/302` (5.68), and 106/45 at fixed `M` (5.69). | A counting/distinguishability statement: the number of distinguishable interior attributes at a marginally trapped corner (5.51) is `exp(A/4Għ)` times a power of area. | Reframing. The log coefficient re-uses the standard Gauss–Bonnet/trace-anomaly coefficient (5.67c) [ref 71], so it is not an independent check of Sen. |
| T7 | Semiclassical limit. Coherent states follow Hamilton's equations (6.1). Stationarity gives Einstein's equations (6.3)–(6.4) and their one-loop backreaction (6.13). | The classical dynamical law appears as the **emergent** possible/impossible structure in the `ħ → 0` limit. | Standard. Neutral for CT. |
| T8 | Spatial topology is not a superselection sector. A connected filling equals a sum of product states up to a null state (5.73), and `K_Σ ≅ H_Σ ⊗ H_Σ*` (5.74). | Supports CT locality: two-boundary states are compositions of states of the parts. | Supportive. |

## 3. Which CT principles each result uses

| Principle | Where it shows up | Verdict |
| --- | --- | --- |
| Interoperability of information | Not addressed. No information variables are defined across substrates. | Neutral. |
| Superinformation (no-cloning of non-orthogonal attributes) | A type I factor `B(H_D)` (5.20) with non-commuting observables. Graviton insertions connect different area eigenspaces (5.41). | Consistent: it is quantum. Not derived. |
| Locality (Deutsch–Hayden: subsystems have their own states; composition) | Type I factor and factorisation (5.74) **support** it. But the gluing is an *entangling product* that restricts the tensor product to charge-matched states (§1 [12], §4.4). Observables are dressed to corner frames, and deformations "may be nonlocal" across a spatial boundary (§4.1). | Mixed. It is the best locality structure among the QG approaches we have catalogued, but it is not strict Deutsch–Hayden locality. |
| Counterfactuals | The algebra comes before the state (§4 intro). There are conditional probabilities (5.3). | Supportive in spirit. |
| No-design | The Gaussian centre and widths (4.7), footnote 13, and the pure extension `ω` (4.16) are **free choices**. Unitary equivalence across `ω` is deferred (footnote 20). | Tension. These are design choices that CT would want to be irrelevant. |
| Marletto–Vedral witness | There is no 4D matter, so there are no two masses and no mediator test. Gravity–gravity entanglement appears in the thermal state (5.75)–(5.77). | Neutral for BMV. A fully quantum gravity is *compatible* with the witness, but the paper gives no rate. |
| Composition principle (repo `Possibility.lean`) | (4.2e), (4.29)–(4.31). | Supportive. |

## 4. What does not translate cleanly

| Element | Why it resists CT |
| --- | --- |
| Lorentzian path integral (4.5) and Schwinger–Keldysh one loop (D.1)–(D.12) | Dynamics plus initial state is exactly the framing CT replaces. Here it is just the calculational tool. The CT content is only in the *conclusions* (T1, T2, T5). |
| Gaussian state choice (4.7) and pure extension `ω` (4.16) | These are free design inputs. CT laws should not depend on a chosen reference state. The paper itself leaves it open whether the results depend on `ω` (footnote 20). |
| Reference-frame dressing (§3.5, (3.58)–(3.59)) and edge modes | Observables are defined relative to a dynamical frame at `S`. CT has no native notion of a relational/dressed attribute. We would need a "frame substrate" whose attributes are not locally specifiable. |
| The clock `ū*` as the size bound | The CT attribute "size ≤ ℓ" is a spectral projector of a nonlinear, operator-ordered clock (4.26)–(4.27). Its self-adjointness is argued only on a dense set (footnote 14, C.2). |
| Finiteness proof by perturbative contradiction (§5.2, D.2) | It uses a one-loop two-point function on a smooth background (5.27)–(5.29). The statement is nonperturbative, but the proof is not fully so. |
| Pair-creation phase (Fig. 20) | It is a chosen boundary unitary, not a law. |

## 5. Link to our three forbidden tasks

- **(b) unbounded distinguishability at bounded resources.** This is the direct link.
  `SpeedLimit.lean` (PR #6) proves the *static half* of FD: `orthogonal_family_finite`
  (pairwise-orthogonal nonzero vectors in a finite-dimensional `W` number at most `dim W`).
  The file says explicitly that the finite-dimensionality of `W` is "an **assumption about the
  Hamiltonian**". Chandrasekaran's (5.39c) supplies that proviso on the gravity side, with
  `W = H_D` and the bounded resource being the **size** `ℓ(D)` (clock reading), not energy. The
  dynamical half (speed limit, `orthogonal_steps_le`) has no counterpart in the paper.
- **(a) superinformation.** It is consistent (type I factor), but the paper adds nothing new.
- **(c) symmetrisation.** It is not touched. Gravitons are bosonic Fock excitations (4.10c), but
  that is an input.
- **"Hard to vary" bonus.** T1′ (the JT contrast) is a real variation test. Removing the
  shear–focusing coupling (as in 2D) makes task (b) possible again.

## 6. Candidate law and Lean sketch (statements only; no `.lean` file in this PR)

**Candidate law L-NC1 (qualitative, matches (5.39c)).** For every causal-diamond substrate `D`
and every clock bound `ℓ`, perfectly distinguishing an infinite family of non-empty attributes
inside `1[0,ℓ](ū*)` is impossible.

**Candidate law L-NC2 (quantitative, conjectural; matches (5.64) only asymptotically).**
`card ≤ exp(π ℓ² / ((1−ε)² ℓ_P²) + o(ℓ²/ℓ_P²))`.

Lean sketch, in the vocabulary of `ClosingTheGap.lean` (`FDOn`, `shell`, `PerfectlyDistinguishes`)
and `SpeedLimit.lean` (on branch `next-steps`, PR #6):

```lean
-- ASSUMED (the gravity content of the paper, as a hypothesis, not proved):
structure NullConeDiamond where
  H      : Type*                          -- H_ω, inner-product space over ℂ
  [ips   : InnerProductSpace ℂ H]
  clockShell : ℝ → Submodule ℂ H          -- ℓ ↦ range of 1[0,ℓ](ū*)
  mono   : Monotone clockShell
  finiteDim : ∀ ℓ, FiniteDimensional ℂ (clockShell ℓ)   -- Chandrasekaran (5.39c)

-- PROVED from the hypothesis (this would be a wrapper around orthogonal_family_finite):
theorem nc1_fd (D : NullConeDiamond) (ℓ : ℝ) {ι : Type*} (v : ι → D.H)
    (hv : ∀ i, v i ≠ 0) (hmem : ∀ i, v i ∈ D.clockShell ℓ)
    (horth : Pairwise fun i j => inner (v i) (v j) = 0) :
    Finite ι ∧ Nat.card ι ≤ Module.finrank ℂ (D.clockShell ℓ)

-- Bridge to the CT predicate: with Θ_q = "distinguishable iff orthogonal" and E := ū*,
-- FDOn Θ_q D.H ū* holds.
-- Variation test (provable now): the JT model (2.13c) has clockShell ℓ ≅ L²[0,ℓ] ⊗ H_φ,
-- which is infinite-dimensional, so FDOn fails. The analogue of continuum_violates_fd.
```

What Lean would **assume**: `finiteDim` (all of §5.2), and the identification of perfect
distinguishability with orthogonality. What it would **prove**: FD for the diamond, the bound
`≤ finrank`, and the failure of FD in a JT-style infinite-dimensional shell. **Honest
assessment:** L-NC1 in Lean is a short corollary of existing work. All the physics sits in the
hypothesis. Its value is bookkeeping. It shows which hypothesis of `SpeedLimit.lean` a theory of
quantum gravity would have to discharge, and that this paper claims to discharge it. L-NC2
cannot be formalized as a theorem from the paper, because the paper does not prove it in general.

## 7. Bottom line

The paper's finite causal-diamond Hilbert space gives a concrete gravity-side reason for our
forbidden task (b), in "bounded size" form. Its type I factor and factorisation are friendlier to
CT locality than most approaches. Its machinery (path integral, chosen Gaussian state and `ω`,
dressed frames) is not CT, and the CT version is a reframing. It is vacuum gravity: there is no
matter coupling and no prediction of witness rates, so it does not move the BMV finish line.
