/-
Copyright (c) 2026 ben. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: ben
-/
module

public import ConstructorTheory.FormalisationGap
public import Mathlib.Data.Sym.Sym2
public import Mathlib.Data.Nat.Choose.Central
public import Mathlib.Algebra.Order.Field.Rat
public import Mathlib.Tactic.FieldSimp

/-!
# Identical particles: the refutation attempt on Maxwell–Boltzmann and Gibbs

Companion to `docs/formalisation-gap/CLOSING_THE_GAP.md`, §6. Two toys.

1. **The swap task.** On a labelled two-particle substrate `α × α`, the configurations `(x, y)`
   and `(y, x)` (with `x ≠ y`) can be perfectly distinguished (`labelled_swap_possible`). On the
   substrate of unordered pairs `Sym2 α` they are the same state, so distinguishing a
   configuration from its swap is impossible (`identical_swap_impossible`). The physics is in
   the *choice of substrate*: that identical particles live on the symmetrised state space is
   the symmetrisation postulate, which this file assumes, not derives.
2. **Gibbs counting.** `N` labelled particles in `M` cells have `M^N` configurations. Mixing two
   equal samples (`2N` particles, `2M` cells) multiplies that count by `4^N` relative to the two
   separate samples (`labelled_mixing`), an entropy of mixing `2N ln 2` for identical gases: the
   Gibbs paradox. With Gibbs' `1/N!` the factor is `4^N / C(2N, N)`, which lies between `1`
   and `2N + 1` (`gibbs_mixing_ratio_bounds`): an entropy change at most `ln(2N + 1)`, so zero
   per particle as `N → ∞`.

No `sorry`, no new axioms.
-/

@[expose] public section

namespace ConstructorTheory

namespace IdenticalParticles

open Theory

/-! ## 1. The swap task -/

/-- Labelled particles: `(x, y)` and `(y, x)` are different states and can be told apart. -/
theorem labelled_swap_possible {α : Type} {x y : α} (hxy : x ≠ y) :
    functional.Possible
      (distinguishTask ({(x, y)} : Attribute (α × α)) {(y, x)} {(x, y)} {(y, x)}) := by
  refine distinguish_possible_of_disjoint ?_ rfl rfl
  rw [Set.disjoint_singleton]
  intro h
  exact hxy (Prod.ext_iff.mp h).1

/-- Identical particles: on unordered pairs the swapped configuration is the same state, so no
deterministic constructor sends it to a disjoint output. -/
theorem identical_swap_impossible {α : Type} (x y : α) {o o' : Attribute (Sym2 α)}
    (hout : Disjoint o o') :
    functional.Impossible
      (distinguishTask ({s(x, y)} : Attribute (Sym2 α)) {s(y, x)} o o') := by
  refine distinguish_impossible_of_overlap hout ⟨s(x, y), rfl, ?_⟩
  exact Sym2.eq_swap

/-! ## 2. Gibbs counting -/

/-- Labelled count: mixing two equal samples multiplies the configuration count by `4^N`. -/
theorem labelled_mixing (N M : ℕ) : (2 * M) ^ (2 * N) = 4 ^ N * (M ^ N) ^ 2 := by
  rw [mul_pow, pow_mul, pow_mul]; ring

/-- Gibbs-corrected count `M^N / N!`. -/
noncomputable def gibbsCount (N M : ℕ) : ℚ := (M : ℚ) ^ N / N.factorial

theorem centralBinom_mul_factorial (N : ℕ) :
    (Nat.centralBinom N : ℚ) * N.factorial * N.factorial = (2 * N).factorial := by
  have h := Nat.choose_mul_factorial_mul_factorial (show N ≤ 2 * N by omega)
  rw [show 2 * N - N = N by omega] at h
  rw [Nat.centralBinom_eq_two_mul_choose]
  exact_mod_cast h

/-- With `1/N!`, the mixing factor is `4^N / C(2N, N)`. -/
theorem gibbs_mixing_ratio (N M : ℕ) (hM : 0 < M) :
    gibbsCount (2 * N) (2 * M) / gibbsCount N M ^ 2 = 4 ^ N / Nat.centralBinom N := by
  have hc := centralBinom_mul_factorial N
  have hf : (N.factorial : ℚ) ≠ 0 := by exact_mod_cast N.factorial_ne_zero
  have hb : (Nat.centralBinom N : ℚ) ≠ 0 := by exact_mod_cast Nat.centralBinom_ne_zero N
  have hMq : (M : ℚ) ≠ 0 := by exact_mod_cast hM.ne'
  unfold gibbsCount
  rw [← hc]
  push_cast
  field_simp
  rw [mul_pow, pow_mul, pow_mul]
  ring

/-- **The Gibbs-corrected mixing factor is between `1` and `2N + 1`.** So the entropy of
mixing identical gases is at most `ln(2N + 1)`, not `2N ln 2`. -/
theorem gibbs_mixing_ratio_bounds (N : ℕ) :
    1 ≤ (4 : ℚ) ^ N / Nat.centralBinom N ∧ (4 : ℚ) ^ N / Nat.centralBinom N ≤ 2 * N + 1 := by
  have hpos : (0 : ℚ) < Nat.centralBinom N := by exact_mod_cast Nat.centralBinom_pos N
  constructor
  · rw [le_div_iff₀ hpos, one_mul]
    exact_mod_cast Nat.centralBinom_le_four_pow N
  · rw [div_le_iff₀ hpos]
    exact_mod_cast Nat.four_pow_le_two_mul_add_one_mul_centralBinom N

#print axioms labelled_swap_possible
#print axioms identical_swap_impossible
#print axioms labelled_mixing
#print axioms gibbs_mixing_ratio
#print axioms gibbs_mixing_ratio_bounds

end IdenticalParticles

end ConstructorTheory
