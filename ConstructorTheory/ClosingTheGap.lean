/-
Copyright (c) 2026 ben. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: ben
-/
module

public import ConstructorTheory.CTRestatement
public import Mathlib.Data.Matrix.Mul
public import Mathlib.LinearAlgebra.Matrix.Notation
public import Mathlib.LinearAlgebra.Matrix.ConjTranspose
public import Mathlib.Basic.Complex.Basic
public import Mathlib.Algebra.BigOperators.Ring.Finset
public import Mathlib.Data.Set.Card
public import Mathlib.LinearAlgebra.Matrix.Kronecker
public import Mathlib.Analysis.SpecialFunctions.Exp
public import Mathlib.Analysis.SpecialFunctions.Pow.Asymptotics
public import Mathlib.Analysis.Real.Cardinality
public import Mathlib.Algebra.Order.Floor.Semiring
public import Mathlib.Tactic.LinearCombination
public import Mathlib.Tactic.FinCases
public import Mathlib.Tactic.NormNum

/-!
# Closing the formalisation gap (milestone: candidate principles)

Companion to `docs/formalisation-gap/CLOSING_THE_GAP.md`. Three pieces:

1. **Breakdown schema** (Ben's thesis, made exact). A classical law that is derived from, and
   entails, "every task in the class `X` is possible" fails in a theory exactly when some task
   in `X` is impossible there (`law_fails_iff`).
2. **Finite distinguishability** (candidate principle FD). A theory satisfies FD for an energy
   function when, below every energy bound, only finitely many attributes can be perfectly
   distinguished. For the deterministic theory `functional`, FD holds *iff* every bounded-energy
   shell has finitely many states (`functional_fd_iff_finite_shells`), and the continuum particle
   violates it (`continuum_violates_fd`). Under FD no task that reads out a continuum of
   bounded-energy attributes is possible (`fd_no_continuum_readout`).
3. **Superinformation in a qubit** (candidate principle SI, the quantum side). In a theory whose
   constructors preserve the inner product, cloning two states whose overlap is neither 0 nor 1
   is impossible (`no_cloning_overlap`, any dimension). On two qubits the computational-basis
   variable can be cloned (CNOT, `qubit_basis_clone_possible`), but the variable
   `{|0⟩, (3|0⟩+4|1⟩)/5}` cannot (`qubit_nonorthogonal_clone_impossible`), although its two
   attributes are disjoint. In `functional` every variable is clonable
   (`functional_every_variable_info`), so this is exactly where the classical copying law breaks.

Simplifications as before: exact limit, constructors are state maps, sharp states are singleton
attributes of vectors (no rays, so global phases are not quotiented). No new axioms, no `sorry`.
-/

@[expose] public section

namespace ConstructorTheory

open _root_.ConstructorTheory.Task
open Theory

/-! ## 1. The breakdown schema -/

/-- A class of tasks, each on its own substrate. -/
abbrev TaskClass := Set (Σ S : Substrate, Task S)

/-- `Θ` grants the possibility assumption `X`: every task in `X` is possible in `Θ`. -/
def Assumes (Θ : Theory) (X : TaskClass) : Prop :=
  ∀ T ∈ X, Θ.Possible T.2

/-- A law `P` (a property of theories) *rests on* `X` when it is derivable from `X` and entails
`X`. Example: classical copying rests on the class of all cloning tasks. -/
structure RestsOn (P : Theory → Prop) (X : TaskClass) : Prop where
  derive : ∀ Θ, Assumes Θ X → P Θ
  entail : ∀ Θ, P Θ → Assumes Θ X

/-- **Breakdown is exact.** A law that rests on `X` fails in `Θ` iff some task of `X` is
impossible in `Θ`. -/
theorem law_fails_iff {P : Theory → Prop} {X : TaskClass} (h : RestsOn P X) (Θ : Theory) :
    ¬ P Θ ↔ ∃ T ∈ X, Θ.Impossible T.2 := by
  constructor
  · intro hP
    by_contra hno
    exact hP (h.derive Θ fun T hT => by
      by_contra hT'
      exact hno ⟨T, hT, hT'⟩)
  · rintro ⟨T, hT, hImp⟩ hP
    exact hImp (h.entail Θ hP T hT)

/-- Weaker, one-sided form: a law merely *derived* from `X` is safe wherever `X` holds; its
derivation gives no warrant once a task of `X` is impossible. -/
theorem law_holds_of_assumes {P : Theory → Prop} {X : TaskClass}
    (h : ∀ Θ, Assumes Θ X → P Θ) {Θ : Theory} (hX : Assumes Θ X) : P Θ :=
  h Θ hX

/-! ## 2. Finite distinguishability -/

/-- The read-out task `x i → o i` for every index `i`. -/
def readout {S : Substrate} {ι : Type} (x o : ι → Attribute S) : Task S where
  pairs := {p | ∃ i, p = (x i, o i)}

/-- `Θ` perfectly distinguishes the family `x`: some read-out onto non-empty, pairwise-disjoint
output attributes is possible. -/
def PerfectlyDistinguishes (Θ : Theory) {S : Substrate} {ι : Type} (x : ι → Attribute S) :
    Prop :=
  ∃ o : ι → Attribute S, (∀ i, (o i).Nonempty) ∧ Pairwise (fun i j => Disjoint (o i) (o j)) ∧
    Θ.Possible (readout x o)

/-- The states of `S` with energy at most `e`. -/
def shell {S : Substrate} (E : S → ℝ) (e : ℝ) : Set S :=
  {s | E s ≤ e}

/-- **Finite distinguishability (FD) on a substrate.** Below every energy bound `e`, every
perfectly distinguishable family of non-empty attributes is finite, with a uniform bound `N`. -/
def FDOn (Θ : Theory) (S : Substrate) (E : S → ℝ) : Prop :=
  ∀ e : ℝ, ∃ N : ℕ, ∀ (ι : Type) (x : ι → Attribute S),
    (∀ i, (x i).Nonempty) → (∀ i, x i ⊆ shell E e) → PerfectlyDistinguishes Θ x →
      Finite ι ∧ Nat.card ι ≤ N

/-- Under FD no read-out of a continuum (`ℝ`-indexed family) of bounded-energy attributes is
possible. -/
theorem fd_no_continuum_readout {Θ : Theory} {S : Substrate} {E : S → ℝ} (hFD : FDOn Θ S E)
    {e : ℝ} (x : ℝ → Attribute S) (hne : ∀ r, (x r).Nonempty) (hE : ∀ r, x r ⊆ shell E e) :
    ¬ PerfectlyDistinguishes Θ x := by
  intro hD
  obtain ⟨N, hN⟩ := hFD e
  have := (hN ℝ x hne hE hD).1
  exact (Set.infinite_univ (α := ℝ)) (Set.toFinite _)

/-- In the deterministic theory, a possible read-out onto pairwise-disjoint outputs forces the
inputs to be pairwise disjoint. -/
theorem functional_readout_disjoint {S : Substrate} {ι : Type} {x o : ι → Attribute S}
    (ho : Pairwise fun i j => Disjoint (o i) (o j)) (h : functional.Possible (readout x o)) :
    Pairwise fun i j => Disjoint (x i) (x j) := by
  rcases h with ⟨f, hf⟩
  intro i j hij
  have hi : Set.MapsTo f (x i) (o i) := hf (show (x i, o i) ∈ (readout x o).pairs from ⟨i, rfl⟩)
  have hj : Set.MapsTo f (x j) (o j) := hf (show (x j, o j) ∈ (readout x o).pairs from ⟨j, rfl⟩)
  rw [Set.disjoint_left]
  intro s hsi hsj
  exact Set.disjoint_left.mp (ho hij) (hi hsi) (hj hsj)

/-- **FD for deterministic theories is discreteness.** `functional` satisfies FD on `S` for `E`
iff every bounded-energy shell of `S` has finitely many states. -/
theorem functional_fd_iff_finite_shells (S : Substrate) (E : S → ℝ) :
    FDOn functional S E ↔ ∀ e : ℝ, (shell E e).Finite := by
  constructor
  · intro hFD e
    obtain ⟨N, hN⟩ := hFD e
    -- read out every state of the shell as its own singleton
    let x : shell E e → Attribute S := fun s => {s.1}
    have hD : PerfectlyDistinguishes functional x := by
      refine ⟨x, fun s => ⟨s.1, rfl⟩, ?_, ⟨id, ?_⟩⟩
      · intro s t hst
        simp only [x, Set.disjoint_singleton]
        exact fun h => hst (Subtype.ext h)
      · rintro _ ⟨i, rfl⟩
        exact Set.mapsTo_id _
    have hfin := (hN _ x (fun s => ⟨s.1, rfl⟩) (fun s => by simp [x]) hD).1
    exact Set.finite_coe_iff.mp hfin
  · intro hfin e
    have : Finite (shell E e) := (hfin e).to_subtype
    refine ⟨Nat.card (shell E e), fun ι x hne hE hD => ?_⟩
    rcases hD with ⟨o, -, ho, hposs⟩
    have hdisj := functional_readout_disjoint ho hposs
    let w : ι → shell E e := fun i => ⟨(hne i).some, hE i (hne i).some_mem⟩
    have hw : Function.Injective w := by
      intro i j hij
      by_contra hne'
      have hi : (hne i).some ∈ x i := (hne i).some_mem
      have hj : (hne i).some ∈ x j := by
        have : (hne i).some = (hne j).some := congrArg Subtype.val hij
        rw [this]; exact (hne j).some_mem
      exact Set.disjoint_left.mp (hdisj hne') hi hj
    exact ⟨Finite.of_injective w hw, Nat.card_le_card_of_injective w hw⟩

/-- **The classical continuum violates FD for every energy function.** Whatever real-valued
energy is assigned to the points of a line, the deterministic theory distinguishes infinitely
many of them below some bound: the line is a countable union of shells, and it is uncountable. -/
theorem continuum_violates_fd (E : ℝ → ℝ) : ¬ FDOn functional ℝ E := by
  rw [functional_fd_iff_finite_shells]
  intro h
  have hcover : (Set.univ : Set ℝ) = ⋃ n : ℕ, shell E n := by
    ext s
    simp only [Set.mem_univ, Set.mem_iUnion, shell, Set.mem_ofPred_eq, true_iff]
    exact exists_nat_ge (E s)
  apply Cardinal.not_countable_real
  rw [hcover]
  exact Set.countable_iUnion fun n => (h n).countable

/-- **A ladder of quanta satisfies FD.** Levels `n : ℕ` with energy `n` (an oscillator in units
of `ħω`, zero point dropped) have finite shells, so the deterministic theory on the ladder
obeys FD. -/
theorem ladder_fd : FDOn functional ℕ (fun n => (n : ℝ)) := by
  rw [functional_fd_iff_finite_shells]
  intro e
  refine (Set.finite_Iic ⌈e⌉₊).subset fun n hn => ?_
  simp only [shell, Set.mem_ofPred_eq] at hn
  simp only [Set.mem_Iic]
  exact_mod_cast hn.trans (Nat.le_ceil e)

/-! ## 3. Superinformation in a qubit: no-cloning of non-orthogonal states -/

/-- Inner product `⟨v, w⟩ = Σ conj(vᵢ) wᵢ`. -/
def ip {ι : Type} [Fintype ι] (v w : ι → ℂ) : ℂ := star v ⬝ᵥ w

/-- Product state `v ⊗ w`. -/
def kron {ι κ : Type} (v : ι → ℂ) (w : κ → ℂ) : ι × κ → ℂ := fun p => v p.1 * w p.2

theorem ip_kron {ι κ : Type} [Fintype ι] [Fintype κ] (a c : ι → ℂ) (b d : κ → ℂ) :
    ip (kron a b) (kron c d) = ip a c * ip b d := by
  simp only [ip, kron, dotProduct, Pi.star_apply, star_mul', Fintype.sum_prod_type,
    Finset.sum_mul_sum]
  refine Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun j _ => ?_
  ring

/-- **No-cloning (Wootters–Zurek, Dieks).** If an inner-product-preserving map clones `ψ` and
`φ` onto a normalised blank `b`, then `⟨ψ, φ⟩` is `0` or `1`. -/
theorem no_cloning_overlap {ι : Type} [Fintype ι] (U : (ι × ι → ℂ) → (ι × ι → ℂ))
    (hU : ∀ v w, ip (U v) (U w) = ip v w) {b ψ φ : ι → ℂ} (hb : ip b b = 1)
    (hψ : U (kron ψ b) = kron ψ ψ) (hφ : U (kron φ b) = kron φ φ) :
    ip ψ φ = 0 ∨ ip ψ φ = 1 := by
  have key : ip ψ φ = ip ψ φ * ip ψ φ := by
    have h1 := hU (kron ψ b) (kron φ b)
    rw [hψ, hφ, ip_kron, ip_kron, hb, mul_one] at h1
    exact h1.symm
  have : ip ψ φ * (ip ψ φ - 1) = 0 := by linear_combination -key
  rcases mul_eq_zero.mp this with h | h
  · exact Or.inl h
  · exact Or.inr (by linear_combination h)

/-- A theory of inner-product-preserving constructors. `ipS S` is the inner product on
substrate `S`; constructors on `S` are the maps preserving it, acting by `Set.MapsTo`. -/
def isometric (ipS : (S : Substrate) → S → S → ℂ) : Theory where
  Constructor S := {f : S → S // ∀ a b, ipS S (f a) (f b) = ipS S a b}
  performs f := {p | Set.MapsTo f.1 p.1 p.2}

/-- Two-qubit state space. -/
abbrev Qubit2 := Fin 2 × Fin 2 → ℂ

/-- Cloning the sharp states `ψs` onto the blank `b`: `{ψ ⊗ b} → {ψ ⊗ ψ}`. -/
def qcloneTask (ψs : Set (Fin 2 → ℂ)) (b : Fin 2 → ℂ) : Task Qubit2 where
  pairs := {p | ∃ ψ ∈ ψs, p = ({kron ψ b}, {kron ψ ψ})}

/-- In any isometric theory using the standard inner product on two qubits, cloning a pair of
states with overlap outside `{0, 1}` onto a normalised blank is impossible. -/
theorem qclone_impossible_of_overlap {ipS : (S : Substrate) → S → S → ℂ}
    (hip : ∀ v w : Qubit2, ipS Qubit2 v w = ip v w) {b ψ φ : Fin 2 → ℂ} (hb : ip b b = 1)
    (h0 : ip ψ φ ≠ 0) (h1 : ip ψ φ ≠ 1) :
    (isometric ipS).Impossible (qcloneTask {ψ, φ} b) := by
  rintro ⟨f, hf⟩
  have hψ : f.1 (kron ψ b) = kron ψ ψ :=
    hf (show (({kron ψ b} : Set Qubit2), ({kron ψ ψ} : Set Qubit2)) ∈ (qcloneTask {ψ, φ} b).pairs
      from ⟨ψ, Or.inl rfl, rfl⟩) rfl
  have hφ : f.1 (kron φ b) = kron φ φ :=
    hf (show (({kron φ b} : Set Qubit2), ({kron φ φ} : Set Qubit2)) ∈ (qcloneTask {ψ, φ} b).pairs
      from ⟨φ, Or.inr rfl, rfl⟩) rfl
  have hU : ∀ v w, ip (f.1 v) (f.1 w) = ip v w := fun v w => by rw [← hip, ← hip]; exact f.2 v w
  rcases no_cloning_overlap f.1 hU hb hψ hφ with h | h
  · exact h0 h
  · exact h1 h

/-- `|0⟩`. -/
def ket0 : Fin 2 → ℂ := ![1, 0]
/-- `|1⟩`. -/
def ket1 : Fin 2 → ℂ := ![0, 1]
/-- `(3|0⟩ + 4|1⟩)/5`, normalised, overlap `3/5` with `|0⟩`. -/
noncomputable def ketφ : Fin 2 → ℂ := ![3 / 5, 4 / 5]

theorem ip_ket0_ket0 : ip ket0 ket0 = 1 := by
  simp [ip, ket0, dotProduct, Fin.sum_univ_two]

theorem ip_ket0_ketφ : ip ket0 ketφ = 3 / 5 := by
  simp [ip, ket0, ketφ, dotProduct, Fin.sum_univ_two]

/-- CNOT on two qubits, as a coordinate permutation: `(Uv)(i, j) = v(i, j + i)`. -/
def cnot (v : Qubit2) : Qubit2 := fun p => v (p.1, p.2 + p.1)

theorem ip_cnot (v w : Qubit2) : ip (cnot v) (cnot w) = ip v w := by
  simp only [ip, cnot, dotProduct, Pi.star_apply, Fintype.sum_prod_type]
  refine Finset.sum_congr rfl fun i _ => ?_
  exact Equiv.sum_comp (Equiv.addRight i) (fun j => star (v (i, j)) * w (i, j))

/-- The standard inner product on `Qubit2`, `0` on every other substrate. -/
noncomputable def stdIp (S : Substrate) : S → S → ℂ := by
  classical
  exact if h : S = Qubit2 then fun a b => ip (cast h a) (cast h b) else fun _ _ => 0

theorem stdIp_qubit2 (v w : Qubit2) : stdIp Qubit2 v w = ip v w := by
  simp [stdIp]

/-- **The computational basis is an information variable**: CNOT clones `{|0⟩, |1⟩}` onto the
blank `|0⟩`. -/
theorem qubit_basis_clone_possible :
    (isometric stdIp).Possible (qcloneTask {ket0, ket1} ket0) := by
  refine ⟨⟨cnot, fun a b => by rw [stdIp_qubit2, stdIp_qubit2, ip_cnot]⟩, ?_⟩
  rintro _ ⟨ψ, hψ, rfl⟩
  rintro _ rfl
  simp only [Set.mem_singleton_iff]
  rcases hψ with rfl | rfl <;>
  · funext p
    rcases p with ⟨i, j⟩
    fin_cases i <;> fin_cases j <;> simp [cnot, kron, ket0, ket1]

/-- **A variable that is not an information variable.** `{|0⟩}` and `{(3|0⟩+4|1⟩)/5}` are
disjoint attributes, yet cloning them is impossible: the overlap is `3/5`. -/
theorem qubit_nonorthogonal_clone_impossible :
    (isometric stdIp).Impossible (qcloneTask {ket0, ketφ} ket0) := by
  refine qclone_impossible_of_overlap stdIp_qubit2 ip_ket0_ket0 ?_ ?_ <;>
    rw [ip_ket0_ketφ] <;> norm_num

/-- The two sharp states really are different, so the attributes are disjoint: the classical
copying theorem (`functional_every_variable_info`) would clone them. -/
theorem ket0_ne_ketφ : ket0 ≠ ketφ := by
  intro h
  have := congrFun h 0
  simp [ket0, ketφ] at this
  norm_num at this

/-- **Classical copying rests on the cloning class, and breaks exactly at `{|0⟩, φ}`.** In the
isometric qubit theory, the law "every pair of distinct sharp states can be cloned onto
`|0⟩`" fails, and the impossible task that witnesses the failure is the non-orthogonal clone. -/
theorem copying_law_breaks_in_qubit :
    ∃ ψ φ : Fin 2 → ℂ, ψ ≠ φ ∧ (isometric stdIp).Impossible (qcloneTask {ψ, φ} ket0) ∧
      (isometric stdIp).Possible (qcloneTask {ket0, ket1} ket0) :=
  ⟨ket0, ketφ, ket0_ne_ketφ, qubit_nonorthogonal_clone_impossible, qubit_basis_clone_possible⟩


/-! ### 3b. A second information variable, and the superinformation medium -/

open Matrix
open scoped Kronecker

/-- A unitary matrix (`Mᴴ M = 1`) preserves the inner product. -/
theorem ip_mulVec_of_unitary {ι : Type} [Fintype ι] [DecidableEq ι] {M : Matrix ι ι ℂ}
    (hM : Mᴴ * M = 1) (v w : ι → ℂ) : ip (M *ᵥ v) (M *ᵥ w) = ip v w := by
  simp only [ip]
  rw [Matrix.star_mulVec, ← Matrix.dotProduct_mulVec, Matrix.mulVec_mulVec, hM, Matrix.one_mulVec]

theorem kronecker_mulVec_kron {ι κ : Type} [Fintype ι] [Fintype κ] (A : Matrix ι ι ℂ)
    (B : Matrix κ κ ℂ) (v : ι → ℂ) (w : κ → ℂ) :
    (A ⊗ₖ B) *ᵥ kron v w = kron (A *ᵥ v) (B *ᵥ w) := by
  funext p
  simp only [Matrix.mulVec, dotProduct, kron, Matrix.kroneckerMap_apply, Fintype.sum_prod_type,
    Finset.sum_mul_sum]
  refine Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun j _ => ?_
  ring

/-- Rotation taking `|0⟩ ↦ φ = (3,4)/5` and `|1⟩ ↦ φ⊥ = (-4,3)/5`. -/
noncomputable def rot : Matrix (Fin 2) (Fin 2) ℂ := !![3 / 5, -4 / 5; 4 / 5, 3 / 5]

/-- `φ⊥ = (-4|0⟩ + 3|1⟩)/5`. -/
noncomputable def ketφperp : Fin 2 → ℂ := ![-4 / 5, 3 / 5]

theorem rot_unitary : rotᴴ * rot = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [rot, Matrix.mul_apply, Fin.sum_univ_two, Matrix.conjTranspose_apply, map_ofNat] <;>
    norm_num

theorem rotT_unitary : (rotᴴ)ᴴ * rotᴴ = 1 := by
  rw [Matrix.conjTranspose_conjTranspose]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [rot, Matrix.mul_apply, Fin.sum_univ_two, Matrix.conjTranspose_apply, map_ofNat] <;>
    norm_num

theorem kron_unitary {A B : Matrix (Fin 2) (Fin 2) ℂ} (hA : Aᴴ * A = 1) (hB : Bᴴ * B = 1) :
    (A ⊗ₖ B)ᴴ * (A ⊗ₖ B) = 1 := by
  rw [Matrix.conjTranspose_kronecker, ← Matrix.mul_kronecker_mul, hA, hB, Matrix.one_kronecker_one]

theorem rot_ket0 : rot *ᵥ ket0 = ketφ := by
  funext i; fin_cases i <;> simp [rot, ket0, ketφ, Matrix.mulVec, dotProduct, Fin.sum_univ_two]
theorem rot_ket1 : rot *ᵥ ket1 = ketφperp := by
  funext i; fin_cases i <;> simp [rot, ket1, ketφperp, Matrix.mulVec, dotProduct, Fin.sum_univ_two]
theorem rotH_φ : rotᴴ *ᵥ ketφ = ket0 := by
  funext i; fin_cases i <;>
    simp [rot, ket0, ketφ, Matrix.mulVec, dotProduct, Fin.sum_univ_two,
      Matrix.conjTranspose_apply, map_ofNat] <;> norm_num
theorem rotH_φperp : rotᴴ *ᵥ ketφperp = ket1 := by
  funext i; fin_cases i <;>
    simp [rot, ket1, ketφperp, Matrix.mulVec, dotProduct, Fin.sum_univ_two,
      Matrix.conjTranspose_apply, map_ofNat] <;> norm_num

theorem one_mulVec' (v : Fin 2 → ℂ) : (1 : Matrix (Fin 2) (Fin 2) ℂ) *ᵥ v = v := Matrix.one_mulVec v

theorem cnot_kron_ket0 (ψ : Fin 2 → ℂ) (hψ : ψ = ket0 ∨ ψ = ket1) :
    cnot (kron ψ ket0) = kron ψ ψ := by
  rcases hψ with rfl | rfl <;>
  · funext p
    rcases p with ⟨i, j⟩
    fin_cases i <;> fin_cases j <;> simp [cnot, kron, ket0, ket1]

/-- The cloner for the rotated basis: `(R ⊗ R) ∘ CNOT ∘ (Rᴴ ⊗ 1)`. -/
noncomputable def rotCloner (v : Qubit2) : Qubit2 :=
  (rot ⊗ₖ rot) *ᵥ cnot ((rotᴴ ⊗ₖ (1 : Matrix (Fin 2) (Fin 2) ℂ)) *ᵥ v)

theorem ip_rotCloner (v w : Qubit2) : ip (rotCloner v) (rotCloner w) = ip v w := by
  simp only [rotCloner]
  rw [ip_mulVec_of_unitary (kron_unitary rot_unitary rot_unitary), ip_cnot,
    ip_mulVec_of_unitary (kron_unitary rotT_unitary (by simp))]

/-- **The rotated basis `{φ, φ⊥}` is also an information variable** (same blank `|0⟩`). -/
theorem qubit_rotated_clone_possible :
    (isometric stdIp).Possible (qcloneTask {ketφ, ketφperp} ket0) := by
  refine ⟨⟨rotCloner, fun a b => by rw [stdIp_qubit2, stdIp_qubit2, ip_rotCloner]⟩, ?_⟩
  rintro _ ⟨ψ, hψ, rfl⟩
  rintro _ rfl
  simp only [Set.mem_singleton_iff, rotCloner, kronecker_mulVec_kron, one_mulVec']
  rcases hψ with rfl | rfl
  · rw [rotH_φ, cnot_kron_ket0 _ (Or.inl rfl), kronecker_mulVec_kron, rot_ket0]
  · rw [rotH_φperp, cnot_kron_ket0 _ (Or.inr rfl), kronecker_mulVec_kron, rot_ket1]


theorem qcloneTask_mono {ψs ψs' : Set (Fin 2 → ℂ)} (h : ψs ⊆ ψs') (b : Fin 2 → ℂ) :
    qcloneTask ψs b ⊑ qcloneTask ψs' b := by
  rintro _ ⟨ψ, hψ, rfl⟩
  exact ⟨ψ, h hψ, rfl⟩

/-- A two-qubit superinformation medium, in the sense of Deutsch–Marletto (simplified to the
cloning clause): two variables `X`, `Y` of sharp qubit states that can each be cloned onto the
same blank, whose union cannot. -/
def IsQubitSuperinformation (Θ : Theory) : Prop :=
  ∃ (X Y : Set (Fin 2 → ℂ)) (b : Fin 2 → ℂ),
    Θ.Possible (qcloneTask X b) ∧ Θ.Possible (qcloneTask Y b) ∧ Θ.Impossible (qcloneTask (X ∪ Y) b)

/-- **The isometric (quantum) qubit theory is a superinformation theory**: `{|0⟩, |1⟩}` and
`{φ, φ⊥}` are both information variables, and their union is not. Contrast
`functional_no_superinformation`: the deterministic theory has none. -/
theorem qubit_superinformation : IsQubitSuperinformation (isometric stdIp) :=
  ⟨{ket0, ket1}, {ketφ, ketφperp}, ket0, qubit_basis_clone_possible, qubit_rotated_clone_possible,
    Impossible.of_subtask qubit_nonorthogonal_clone_impossible
      (qcloneTask_mono (by
        intro ψ hψ
        rcases hψ with rfl | rfl
        · exact Or.inl (Or.inl rfl)
        · exact Or.inr (Or.inl rfl)) ket0)⟩

/-! ## 4. Numbers back: the Planck factor (quantitative content of a discrete ladder)

For a mode of frequency `ω` at temperature `T`, a ladder of quanta `ħω` gives mean energy
`k_B T · x / (eˣ - 1)` with `x = ħω / k_B T` (Planck 1900; standard derivation, not redone here).
Equipartition says `k_B T` for every mode. The factor below is the ratio. It never exceeds 1
(equipartition is the ceiling, approached as `x → 0`) and it tends to 0 for high-frequency
modes: they freeze out, which removes the ultraviolet catastrophe. -/

open Filter Topology

noncomputable def planckFactor (x : ℝ) : ℝ := x / (Real.exp x - 1)

theorem planckFactor_pos {x : ℝ} (hx : 0 < x) : 0 < planckFactor x := by
  have : 0 < Real.exp x - 1 := by linarith [Real.add_one_lt_exp hx.ne']
  exact div_pos hx this

theorem planckFactor_le_one {x : ℝ} (hx : 0 < x) : planckFactor x ≤ 1 := by
  have h := Real.add_one_le_exp x
  have : 0 < Real.exp x - 1 := by linarith [Real.add_one_lt_exp hx.ne']
  rw [planckFactor, div_le_one this]; linarith

theorem tendsto_planckFactor_atTop : Tendsto planckFactor atTop (𝓝 0) := by
  have hlim : Tendsto (fun x : ℝ => 2 * (x ^ 1 * Real.exp (-x))) atTop (𝓝 0) := by
    simpa using (Real.tendsto_pow_mul_exp_neg_atTop_nhds_zero 1).const_mul 2
  refine tendsto_of_tendsto_of_tendsto_of_le_of_le' tendsto_const_nhds hlim ?_ ?_
  · filter_upwards [eventually_gt_atTop 0] with x hx
    exact (planckFactor_pos hx).le
  · filter_upwards [eventually_ge_atTop 1] with x hx
    have he : 2 ≤ Real.exp x := by
      have := Real.add_one_le_exp x; linarith
    have hpos : 0 < Real.exp x - 1 := by linarith
    have hexp : 0 < Real.exp x := Real.exp_pos x
    rw [planckFactor, pow_one, Real.exp_neg, div_le_iff₀ hpos]
    field_simp
    nlinarith

/-! ## Axiom audit -/

#print axioms law_fails_iff
#print axioms fd_no_continuum_readout
#print axioms functional_fd_iff_finite_shells
#print axioms continuum_violates_fd
#print axioms ladder_fd
#print axioms no_cloning_overlap
#print axioms qclone_impossible_of_overlap
#print axioms qubit_basis_clone_possible
#print axioms qubit_nonorthogonal_clone_impossible
#print axioms copying_law_breaks_in_qubit
#print axioms qubit_rotated_clone_possible
#print axioms qubit_superinformation
#print axioms planckFactor_le_one
#print axioms tendsto_planckFactor_atTop

end ConstructorTheory
