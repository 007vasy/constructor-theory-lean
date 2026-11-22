/-
Copyright (c) 2026 ben. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: ben
-/
module

public import Mathlib.Data.Matrix.Mul
public import Mathlib.LinearAlgebra.Matrix.Notation
public import Mathlib.Basic.Complex.Basic
public import Mathlib.Tactic.LinearCombination
public import Mathlib.Tactic.FinCases
public import Mathlib.Tactic.NormNum

/-!
# The formalisation gap: q-numbers, the smallest honest example

Dirac's q-numbers are quantities that need not commute. Vedral's phrase "everything is a
q-number" (Vedral, arXiv:2303.00831) says physical quantities are operators, not c-numbers.
This file proves the smallest instance of why that kills pattern P2 (joint sharpness):

* `pauliX_mul_pauliZ_ne`: the spin observables `σx` and `σz` do not commute.
* `no_common_eigenvector`: no non-zero state is an eigenvector of both, so no state assigns
  sharp values to both at once.

Classical (c-number) quantities commute, so this is exactly the step a classical law cannot
take. No new axioms and no `sorry`.
-/

@[expose] public section

namespace ConstructorTheory

open Matrix

/-- Pauli `X` (spin along x, in units of ħ/2). -/
def pauliX : Matrix (Fin 2) (Fin 2) ℂ := !![0, 1; 1, 0]

/-- Pauli `Z` (spin along z, in units of ħ/2). -/
def pauliZ : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- `σx σz ≠ σz σx`: spin components are q-numbers. -/
theorem pauliX_mul_pauliZ_ne : pauliX * pauliZ ≠ pauliZ * pauliX := by
  intro h
  have h01 := congrFun (congrFun h 0) 1
  simp [pauliX, pauliZ, Matrix.mul_apply, Fin.sum_univ_two] at h01
  norm_num at h01

/-- No non-zero vector is an eigenvector of both `σx` and `σz`: sharp joint values of the two
spin components do not exist. -/
theorem no_common_eigenvector (v : Fin 2 → ℂ) (a b : ℂ)
    (hx : pauliX *ᵥ v = a • v) (hz : pauliZ *ᵥ v = b • v) : v = 0 := by
  have hx0 : v 1 = a * v 0 := by
    simpa [pauliX, Matrix.mulVec, dotProduct, Fin.sum_univ_two] using congrFun hx 0
  have hx1 : v 0 = a * v 1 := by
    simpa [pauliX, Matrix.mulVec, dotProduct, Fin.sum_univ_two] using congrFun hx 1
  have hz0 : v 0 = b * v 0 := by
    simpa [pauliZ, Matrix.mulVec, dotProduct, Fin.sum_univ_two] using congrFun hz 0
  have hz1 : -v 1 = b * v 1 := by
    simpa [pauliZ, Matrix.mulVec, dotProduct, Fin.sum_univ_two] using congrFun hz 1
  by_cases h0 : v 0 = 0
  · have h1 : v 1 = 0 := by rw [hx0, h0, mul_zero]
    funext i
    fin_cases i <;> simp [h0, h1]
  · have hb : b = 1 := by
      have : (b - 1) * v 0 = 0 := by linear_combination -hz0
      rcases mul_eq_zero.mp this with h | h
      · linear_combination h
      · exact absurd h h0
    have h1 : v 1 = 0 := by
      rw [hb] at hz1
      linear_combination -hz1 / 2
    exact absurd (by rw [hx1, h1, mul_zero]) h0

#print axioms pauliX_mul_pauliZ_ne
#print axioms no_common_eigenvector

end ConstructorTheory
