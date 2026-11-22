/-
Copyright (c) 2026 ben. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: ben
-/
module

public import Mathlib.Data.Matrix.Mul
public import Mathlib.LinearAlgebra.Matrix.Notation
public import Mathlib.LinearAlgebra.Matrix.Kronecker
public import Mathlib.Basic.Complex.Basic
public import Mathlib.Data.Fintype.Prod
public import Mathlib.Data.Fintype.Pi
public import Mathlib.Algebra.Order.Field.Rat
public import Mathlib.Tactic.LinearCombination
public import Mathlib.Tactic.FinCases
public import Mathlib.Tactic.NormNum

/-!
# Law 23: the Mermin–Peres magic square

Classical law: every observable has a pre-assigned value, independent of which compatible
observables are measured with it (non-contextual hidden variables). The magic square refutes it
(Mermin, PRL 65, 3373 (1990); Peres, Phys. Lett. A 151, 107 (1990)).

* `no_magic_table`: no table of numbers has every row product `+1` and every column product
  `-1`. Purely algebraic (holds over `ℤ`; the entries need not even be `±1`).
* `no_magic_table_bool`: the same in parity form (`true` = `-1`).
* The game. Alice gets a row and answers three signs with an even number of `-1`s; Bob gets a
  column and answers with an odd number. They win round `(r, c)` when they agree on the shared
  cell. `classical_wins_le_eight`: every deterministic strategy (a pre-assigned answer table per
  player) loses at least one of the 9 rounds. `classical_wins_eq_eight`: some strategy wins
  exactly 8. So the best deterministic win rate over uniformly random rounds is `8/9`
  (`classical_best_rate`). Shared randomness is a mixture of deterministic strategies and cannot
  do better; that step is the standard convexity argument and is not formalised here.
* The quantum square: nine two-qubit Pauli observables whose row products are `+I` and column
  products `-I` (`magic_rows`, `magic_cols`). Sharing two Bell pairs, Alice and Bob measure the
  operators of their row or column and win with certainty (Mermin 1990; Google Quantum AI report
  98.3% on hardware, Science 394, 870 (2026), doi:10.1126/science.aec3042). The winning-
  probability calculation is not formalised; the operator identities are.

No `sorry`, no new axioms.
-/

@[expose] public section

namespace ConstructorTheory

namespace MagicSquare

/-! ## Classical: no pre-assigned table -/

/-- **No magic table.** Multiplying all nine entries row by row gives `+1`; column by column
gives `-1`. -/
theorem no_magic_table (s : Fin 3 → Fin 3 → ℤ)
    (hr : ∀ i, s i 0 * s i 1 * s i 2 = 1) (hc : ∀ j, s 0 j * s 1 j * s 2 j = -1) : False := by
  have e : (s 0 0 * s 0 1 * s 0 2) * (s 1 0 * s 1 1 * s 1 2) * (s 2 0 * s 2 1 * s 2 2) =
      (s 0 0 * s 1 0 * s 2 0) * (s 0 1 * s 1 1 * s 2 1) * (s 0 2 * s 1 2 * s 2 2) := by ring
  rw [hr 0, hr 1, hr 2, hc 0, hc 1, hc 2] at e
  norm_num at e

/-- Parity of three signs, `true` meaning an odd number of `-1`s (product `-1`). -/
def par3 (a b c : Bool) : Bool := xor (xor a b) c

/-- Parity form: no Boolean table has even rows and odd columns. -/
theorem no_magic_table_bool (t : Fin 3 → Fin 3 → Bool)
    (hr : ∀ i, par3 (t i 0) (t i 1) (t i 2) = false)
    (hc : ∀ j, par3 (t 0 j) (t 1 j) (t 2 j) = true) : False := by
  have key : ∀ a b c d e f g h k : Bool, par3 a b c = false → par3 d e f = false →
      par3 g h k = false → par3 a d g = true → par3 b e h = true → par3 c f k = true → False := by
    decide
  exact key _ _ _ _ _ _ _ _ _ (hr 0) (hr 1) (hr 2) (hc 0) (hc 1) (hc 2)

/-! ## The game -/

/-- A deterministic strategy: Alice's answer row for each row question, Bob's answer column for
each column question (`true` = `-1`). -/
structure Strategy where
  alice : Fin 3 → Fin 3 → Bool
  bob : Fin 3 → Fin 3 → Bool
  aliceEven : ∀ r, par3 (alice r 0) (alice r 1) (alice r 2) = false
  bobOdd : ∀ c, par3 (bob c 0) (bob c 1) (bob c 2) = true

/-- Round `(r, c)` is won when Alice's entry in column `c` equals Bob's entry in row `r`. -/
def Strategy.wins (σ : Strategy) (p : Fin 3 × Fin 3) : Prop := σ.alice p.1 p.2 = σ.bob p.2 p.1

instance (σ : Strategy) : DecidablePred σ.wins := fun p => by
  unfold Strategy.wins; infer_instance

/-- Number of the 9 rounds the strategy wins. -/
def Strategy.winCount (σ : Strategy) : ℕ := (Finset.univ.filter σ.wins).card

/-- **No deterministic strategy wins every round.** -/
theorem not_all_win (σ : Strategy) : ¬ ∀ p, σ.wins p := by
  intro h
  exact no_magic_table_bool σ.alice σ.aliceEven fun j => by
    have := σ.bobOdd j
    rwa [h (0, j), h (1, j), h (2, j)]

/-- **Classical bound: at most 8 of 9.** -/
theorem classical_wins_le_eight (σ : Strategy) : σ.winCount ≤ 8 := by
  have h9 : σ.winCount ≤ 9 := by
    have := Finset.card_filter_le (Finset.univ : Finset (Fin 3 × Fin 3)) σ.wins
    simpa [Strategy.winCount] using this
  by_contra hlt
  have heq : (Finset.univ.filter σ.wins) = Finset.univ := by
    apply Finset.eq_univ_of_card
    simp only [Fintype.card_prod, Fintype.card_fin]
    unfold Strategy.winCount at h9 hlt
    omega
  exact not_all_win σ fun p => by
    have : p ∈ Finset.univ.filter σ.wins := by rw [heq]; exact Finset.mem_univ p
    exact (Finset.mem_filter.mp this).2

/-- A strategy that wins 8 rounds. Alice's table has `-1` at `(0,0)` and `(0,1)`, `+1`
elsewhere (rows even, columns 0 and 1 odd). Bob copies columns 0 and 1 and answers
`(+1, +1, -1)` in column 2, so only round `(2, 2)` is lost. -/
def eightStrategy : Strategy where
  alice r c := decide (r = 0 ∧ c ≠ 2)
  bob c r := if c = 2 then decide (r = 2) else decide (r = 0)
  aliceEven := by decide
  bobOdd := by decide

theorem eightStrategy_winCount : eightStrategy.winCount = 8 := by decide

/-- **The bound is attained.** -/
theorem classical_wins_eq_eight : ∃ σ : Strategy, σ.winCount = 8 :=
  ⟨eightStrategy, eightStrategy_winCount⟩

/-- **Best deterministic win rate over uniformly random rounds is `8/9`.** -/
theorem classical_best_rate :
    (∀ σ : Strategy, (σ.winCount : ℚ) / 9 ≤ 8 / 9) ∧
      ∃ σ : Strategy, (σ.winCount : ℚ) / 9 = 8 / 9 := by
  refine ⟨fun σ => ?_, eightStrategy, by rw [eightStrategy_winCount]; norm_num⟩
  have h8 : (σ.winCount : ℚ) ≤ 8 := by exact_mod_cast classical_wins_le_eight σ
  gcongr

/-! ## Quantum: the Pauli square -/

open Matrix
open scoped Kronecker

/-- Pauli matrices and the identity on one qubit. -/
def σI : Matrix (Fin 2) (Fin 2) ℂ := 1
def σX : Matrix (Fin 2) (Fin 2) ℂ := !![0, 1; 1, 0]
def σY : Matrix (Fin 2) (Fin 2) ℂ := !![0, -Complex.I; Complex.I, 0]
def σZ : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- The two-qubit magic square (Mermin 1990):
```
 X⊗I    I⊗X    X⊗X
 I⊗Z    Z⊗I    Z⊗Z
-X⊗Z   -Z⊗X    Y⊗Y
``` -/
noncomputable def sq : Fin 3 → Fin 3 → Matrix (Fin 2 × Fin 2) (Fin 2 × Fin 2) ℂ
  | 0, 0 => σX ⊗ₖ σI | 0, 1 => σI ⊗ₖ σX | 0, 2 => σX ⊗ₖ σX
  | 1, 0 => σI ⊗ₖ σZ | 1, 1 => σZ ⊗ₖ σI | 1, 2 => σZ ⊗ₖ σZ
  | 2, 0 => -(σX ⊗ₖ σZ) | 2, 1 => -(σZ ⊗ₖ σX) | 2, 2 => σY ⊗ₖ σY

/-- Row products are `+I`. -/
theorem magic_rows : ∀ i, sq i 0 * sq i 1 * sq i 2 = 1 := by
  intro i
  fin_cases i <;>
  · ext ⟨a, b⟩ ⟨c, d⟩
    fin_cases a <;> fin_cases b <;> fin_cases c <;> fin_cases d <;>
      simp [sq, σI, σX, σY, σZ, Matrix.mul_apply, Fintype.sum_prod_type, Fin.sum_univ_two,
        Matrix.one_apply]

/-- Column products are `-I`. -/
theorem magic_cols : ∀ j, sq 0 j * sq 1 j * sq 2 j = -1 := by
  intro j
  fin_cases j <;>
  · ext ⟨a, b⟩ ⟨c, d⟩
    fin_cases a <;> fin_cases b <;> fin_cases c <;> fin_cases d <;>
      simp [sq, σI, σX, σY, σZ, Matrix.mul_apply, Fintype.sum_prod_type, Fin.sum_univ_two,
        Matrix.one_apply]

set_option maxHeartbeats 4000000 in
-- 27 index cases × 16 matrix entries, each a sum of products, so `simp` needs more time.
/-- Observables in the same row commute (they can be measured together). -/
theorem magic_row_commute : ∀ i j k, sq i j * sq i k = sq i k * sq i j := by
  intro i j k
  fin_cases i <;> fin_cases j <;> fin_cases k <;>
  · ext ⟨a, b⟩ ⟨c, d⟩
    fin_cases a <;> fin_cases b <;> fin_cases c <;> fin_cases d <;>
      simp [sq, σI, σX, σY, σZ, Matrix.mul_apply, Fintype.sum_prod_type, Fin.sum_univ_two]

set_option maxHeartbeats 4000000 in
-- 27 index cases × 16 matrix entries, each a sum of products, so `simp` needs more time.
/-- Observables in the same column commute. -/
theorem magic_col_commute : ∀ j i k, sq i j * sq k j = sq k j * sq i j := by
  intro j i k
  fin_cases j <;> fin_cases i <;> fin_cases k <;>
  · ext ⟨a, b⟩ ⟨c, d⟩
    fin_cases a <;> fin_cases b <;> fin_cases c <;> fin_cases d <;>
      simp [sq, σI, σX, σY, σZ, Matrix.mul_apply, Fintype.sum_prod_type, Fin.sum_univ_two]

#print axioms no_magic_table
#print axioms no_magic_table_bool
#print axioms classical_wins_le_eight
#print axioms classical_wins_eq_eight
#print axioms classical_best_rate
#print axioms magic_rows
#print axioms magic_cols
#print axioms magic_row_commute
#print axioms magic_col_commute

end MagicSquare

end ConstructorTheory
