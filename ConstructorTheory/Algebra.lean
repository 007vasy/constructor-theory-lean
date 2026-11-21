/-
Copyright (c) 2026 ben. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: ben
-/
module

public import ConstructorTheory.Basic

/-!
# The algebra of tasks

Identities for serial composition, parallel composition, transpose, and subtasks.
These are theorems about the pair-set algebra. They do not say which tasks are
physically possible; that is `ConstructorTheory.Possibility`.
-/

@[expose] public section

namespace ConstructorTheory.Task

theorem IsSubtask.refl {S : Substrate} (A : Task S) : A ⊑ A :=
  le_refl A.pairs

theorem IsSubtask.trans {S : Substrate} {A B C : Task S} (hAB : A ⊑ B) (hBC : B ⊑ C) :
    A ⊑ C :=
  le_trans hAB hBC

theorem IsSubtask.antisymm {S : Substrate} {A B : Task S} (hAB : A ⊑ B) (hBA : B ⊑ A) :
    A = B := by
  apply Task.ext
  exact le_antisymm hAB hBA

/-- Serial composition is associative. Parenthesization of a chain of tasks does not matter. -/
theorem serial_assoc {S : Substrate} (A B C : Task S) : (A ⊚ B) ⊚ C = A ⊚ (B ⊚ C) := by
  ext ⟨x, z⟩
  simp only [mem_serial_pairs]
  constructor
  · rintro ⟨y, ⟨y', hA, hB⟩, hC⟩
    exact ⟨y', hA, ⟨y, hB, hC⟩⟩
  · rintro ⟨y, hA, ⟨y', hB, hC⟩⟩
    exact ⟨y', ⟨y, hA, hB⟩, hC⟩

theorem serial_empty_left {S : Substrate} (A : Task S) : empty S ⊚ A = empty S := by
  ext ⟨x, z⟩
  simp

theorem serial_empty_right {S : Substrate} (A : Task S) : A ⊚ empty S = empty S := by
  ext ⟨x, z⟩
  simp

/-- Fixing every attribute and then performing `A` is `A`. -/
theorem serial_idOn_left {S : Substrate} (A : Task S) : idOn Set.univ ⊚ A = A := by
  ext ⟨x, z⟩
  simp only [mem_serial_pairs, mem_idOn_pairs, Set.mem_univ, true_and]
  constructor
  · rintro ⟨_y, rfl, hA⟩
    exact hA
  · intro hA
    exact ⟨x, rfl, hA⟩

/-- Performing `A` and then fixing every attribute is `A`. -/
theorem serial_idOn_right {S : Substrate} (A : Task S) : A ⊚ idOn Set.univ = A := by
  ext ⟨x, z⟩
  simp only [mem_serial_pairs, mem_idOn_pairs, Set.mem_univ, true_and]
  constructor
  · rintro ⟨_y, hA, rfl⟩
    exact hA
  · intro hA
    exact ⟨z, hA, rfl⟩

theorem parallel_empty_left {S T : Substrate} (B : Task T) :
    empty S ⊗ B = empty (S × T) := by
  ext ⟨p, q⟩
  simp

theorem parallel_empty_right {S T : Substrate} (A : Task S) :
    A ⊗ empty T = empty (S × T) := by
  ext ⟨p, q⟩
  simp

/-- Transposition is an involution: `(A~)~ = A`. -/
theorem transpose_involutive {S : Substrate} (A : Task S) : (Aᵀ)ᵀ = A := by
  ext ⟨x, y⟩
  simp

/-- Transpose reverses serial composition: `(A ⊚ B)~ = B~ ⊚ A~`. -/
theorem transpose_serial {S : Substrate} (A B : Task S) : (A ⊚ B)ᵀ = Bᵀ ⊚ Aᵀ := by
  ext ⟨x, z⟩
  simp only [mem_transpose_pairs, mem_serial_pairs]
  constructor
  · rintro ⟨y, hA, hB⟩
    exact ⟨y, hB, hA⟩
  · rintro ⟨y, hB, hA⟩
    exact ⟨y, hA, hB⟩

/-- Transpose commutes with parallel composition. -/
theorem transpose_parallel {S T : Substrate} (A : Task S) (B : Task T) :
    (A ⊗ B)ᵀ = Aᵀ ⊗ Bᵀ := by
  ext ⟨p, q⟩
  simp only [mem_transpose_pairs, mem_parallel_pairs]
  constructor
  · rintro ⟨x, y, u, v, hA, hB, rfl, rfl⟩
    exact ⟨y, x, v, u, hA, hB, rfl, rfl⟩
  · rintro ⟨x, y, u, v, hA, hB, rfl, rfl⟩
    exact ⟨y, x, v, u, hA, hB, rfl, rfl⟩

theorem IsSubtask.serial {S : Substrate} {A A' B B' : Task S} (hA : A ⊑ A') (hB : B ⊑ B') :
    A ⊚ B ⊑ A' ⊚ B' := by
  intro ⟨x, z⟩ hxz
  rw [mem_serial_pairs] at hxz
  rcases hxz with ⟨y, hx, hz⟩
  rw [mem_serial_pairs]
  exact ⟨y, hA hx, hB hz⟩

theorem IsSubtask.parallel {S T : Substrate} {A A' : Task S} {B B' : Task T}
    (hA : A ⊑ A') (hB : B ⊑ B') : A ⊗ B ⊑ A' ⊗ B' := by
  intro ⟨p, q⟩ hpq
  rw [mem_parallel_pairs] at hpq
  rcases hpq with ⟨x, y, u, v, hAx, hBu, rfl, rfl⟩
  rw [mem_parallel_pairs]
  exact ⟨x, y, u, v, hA hAx, hB hBu, rfl, rfl⟩

theorem IsSubtask.transpose {S : Substrate} {A B : Task S} (h : A ⊑ B) : Aᵀ ⊑ Bᵀ := by
  intro ⟨y, x⟩ hyx
  rw [mem_transpose_pairs] at hyx
  rw [mem_transpose_pairs]
  exact h hyx

/-- `A.union B` is an upper bound for `A` in the subtask order. -/
theorem IsSubtask.union_left {S : Substrate} (A B : Task S) : A ⊑ A.union B := by
  intro p hp
  rw [mem_union_pairs]
  exact Or.inl hp

/-- `A.union B` is an upper bound for `B` in the subtask order. -/
theorem IsSubtask.union_right {S : Substrate} (A B : Task S) : B ⊑ A.union B := by
  intro p hp
  rw [mem_union_pairs]
  exact Or.inr hp

/-- `A.union B` is the least upper bound of `A` and `B` in the subtask order. -/
theorem IsSubtask.union_le {S : Substrate} {A B C : Task S} (hA : A ⊑ C) (hB : B ⊑ C) :
    A.union B ⊑ C := by
  intro p hp
  rw [mem_union_pairs] at hp
  rcases hp with hp | hp
  · exact hA hp
  · exact hB hp

/-- Serial composition keeps the disjoint-input property of the first task.

The input attributes of `A ⊚ B` are input attributes of `A`, so they stay disjoint.
-/
theorem hasDisjointInputs.serial {S : Substrate} {A B : Task S} (hA : A.hasDisjointInputs) :
    (A ⊚ B).hasDisjointInputs := by
  intro x₁ z₁ x₂ z₂ h₁ h₂ hne
  rw [mem_serial_pairs] at h₁ h₂
  rcases h₁ with ⟨y₁, hA₁, _⟩
  rcases h₂ with ⟨y₂, hA₂, _⟩
  exact hA x₁ y₁ x₂ y₂ hA₁ hA₂ hne

/-- Parallel composition preserves disjoint inputs on both factors. -/
theorem hasDisjointInputs.parallel {S T : Substrate} {A : Task S} {B : Task T}
    (hA : A.hasDisjointInputs) (hB : B.hasDisjointInputs) : (A ⊗ B).hasDisjointInputs := by
  intro p₁ q₁ p₂ q₂ hp hq hne
  rw [mem_parallel_pairs] at hp hq
  rcases hp with ⟨x₁, y₁, u₁, v₁, hA₁, hB₁, rfl, rfl⟩
  rcases hq with ⟨x₂, y₂, u₂, v₂, hA₂, hB₂, rfl, rfl⟩
  rw [Set.disjoint_prod]
  by_cases hx : x₁ = x₂
  · subst hx
    refine Or.inr ?_
    have hu : u₁ ≠ u₂ := by
      intro hu
      subst hu
      exact hne rfl
    exact hB u₁ v₁ u₂ v₂ hB₁ hB₂ hu
  · exact Or.inl (hA x₁ y₁ x₂ y₂ hA₁ hA₂ hx)

/-- Serial composition of functional tasks is functional. -/
theorem isFunctional.serial {S : Substrate} {A B : Task S}
    (hA : A.isFunctional) (hB : B.isFunctional) : (A ⊚ B).isFunctional := by
  intro x z z' hz hz'
  rw [mem_serial_pairs] at hz hz'
  rcases hz with ⟨y, hAy, hBz⟩
  rcases hz' with ⟨y', hAy', hBz'⟩
  have hy : y = y' := hA x y y' hAy hAy'
  subst hy
  exact hB y z z' hBz hBz'

/-- Doing two tasks side by side, then two more, contains the parallel of the serial composites.

The converse needs non-empty output attributes; see `serial_parallel_interchange`.
-/
theorem parallel_serial_sub_serial_parallel {S T : Substrate}
    (A₁ B₁ : Task S) (A₂ B₂ : Task T) :
    (A₁ ⊚ B₁) ⊗ (A₂ ⊚ B₂) ⊑ (A₁ ⊗ A₂) ⊚ (B₁ ⊗ B₂) := by
  intro ⟨p, r⟩ hpr
  rw [mem_parallel_pairs] at hpr
  rcases hpr with ⟨x₁, z₁, x₂, z₂, h₁, h₂, rfl, rfl⟩
  rw [mem_serial_pairs] at h₁ h₂
  rcases h₁ with ⟨y₁, hA₁, hB₁⟩
  rcases h₂ with ⟨y₂, hA₂, hB₂⟩
  rw [mem_serial_pairs]
  refine ⟨y₁ ×ˢ y₂, ?_, ?_⟩
  · rw [mem_parallel_pairs]
    exact ⟨x₁, y₁, x₂, y₂, hA₁, hA₂, rfl, rfl⟩
  · rw [mem_parallel_pairs]
    exact ⟨y₁, z₁, y₂, z₂, hB₁, hB₂, rfl, rfl⟩

/-- Converse inclusion when the intermediate attributes of `A₁` and `A₂` are non-empty.

An empty attribute satisfies `∅ ×ˢ u = ∅ ×ˢ v` even if `u ≠ v`, so a product attribute does
not determine its factors. Non-emptiness restores that cancellation
(`Set.prod_eq_prod_iff_of_nonempty`).
-/
theorem serial_parallel_sub_parallel_serial {S T : Substrate}
    {A₁ B₁ : Task S} {A₂ B₂ : Task T}
    (hA₁ : A₁.outputsNonempty) (hA₂ : A₂.outputsNonempty) :
    (A₁ ⊗ A₂) ⊚ (B₁ ⊗ B₂) ⊑ (A₁ ⊚ B₁) ⊗ (A₂ ⊚ B₂) := by
  intro ⟨p, r⟩ hpr
  rw [mem_serial_pairs] at hpr
  rcases hpr with ⟨q, hpq, hqr⟩
  rw [mem_parallel_pairs] at hpq hqr
  rcases hpq with ⟨x₁, y₁, x₂, y₂, hA₁p, hA₂p, rfl, hq⟩
  rcases hqr with ⟨y₁', z₁, y₂', z₂, hB₁, hB₂, hq', rfl⟩
  have hqeq : y₁ ×ˢ y₂ = y₁' ×ˢ y₂' := hq.symm.trans hq'
  have hne : (y₁ ×ˢ y₂).Nonempty := (hA₁ x₁ y₁ hA₁p).prod (hA₂ x₂ y₂ hA₂p)
  rcases (Set.prod_eq_prod_iff_of_nonempty hne).1 hqeq with ⟨rfl, rfl⟩
  rw [mem_parallel_pairs]
  refine ⟨x₁, z₁, x₂, z₂, ?_, ?_, rfl, rfl⟩
  · rw [mem_serial_pairs]
    exact ⟨y₁, hA₁p, hB₁⟩
  · rw [mem_serial_pairs]
    exact ⟨y₂, hA₂p, hB₂⟩

/-- Interchange law for non-empty outputs.

Performing `A₁` and `A₂` in parallel and then `B₁` and `B₂` in parallel is the same task
as performing `A₁` then `B₁` on the first substrate and `A₂` then `B₂` on the second,
provided the outputs of `A₁` and `A₂` are non-empty.
-/
theorem serial_parallel_interchange {S T : Substrate}
    {A₁ B₁ : Task S} {A₂ B₂ : Task T}
    (hA₁ : A₁.outputsNonempty) (hA₂ : A₂.outputsNonempty) :
    (A₁ ⊗ A₂) ⊚ (B₁ ⊗ B₂) = (A₁ ⊚ B₁) ⊗ (A₂ ⊚ B₂) :=
  IsSubtask.antisymm
    (serial_parallel_sub_parallel_serial hA₁ hA₂)
    (parallel_serial_sub_serial_parallel A₁ B₁ A₂ B₂)

/-- Functionality is not stable under transpose.

`{0} → {1}` together with `{2} → {1}` is single-valued, but the transpose sends `{1}` to
both `{0}` and `{2}`. Reversing a deterministic task can make it multi-valued, so
transpose is an algebraic operation, not a physical symmetry.
-/
theorem exists_functional_of_transpose_not :
    ∃ T : Task (Fin 3), T.isFunctional ∧ ¬ (Tᵀ).isFunctional := by
  refine ⟨⟨{({0}, {1}), ({2}, {1})}⟩, ?_, ?_⟩
  · intro x y y' hy hy'
    simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at hy hy'
    have hyOut : y = ({1} : Attribute (Fin 3)) := by
      rcases hy with hxy | hxy
      · exact (Prod.ext_iff.mp hxy).2
      · exact (Prod.ext_iff.mp hxy).2
    have hy'Out : y' = ({1} : Attribute (Fin 3)) := by
      rcases hy' with hxy | hxy
      · exact (Prod.ext_iff.mp hxy).2
      · exact (Prod.ext_iff.mp hxy).2
    exact hyOut.trans hy'Out.symm
  · intro hfun
    have h₀ : (({1} : Attribute (Fin 3)), {0}) ∈
        (⟨{({0}, {1}), ({2}, {1})}⟩ : Task (Fin 3))ᵀ.pairs := by
      rw [mem_transpose_pairs]
      simp [Set.mem_insert_iff, Set.mem_singleton_iff]
    have h₂ : (({1} : Attribute (Fin 3)), {2}) ∈
        (⟨{({0}, {1}), ({2}, {1})}⟩ : Task (Fin 3))ᵀ.pairs := by
      rw [mem_transpose_pairs]
      simp [Set.mem_insert_iff, Set.mem_singleton_iff]
    have hEq : ({0} : Attribute (Fin 3)) = {2} := hfun {1} {0} {2} h₀ h₂
    have hmem : (0 : Fin 3) ∈ ({2} : Set (Fin 3)) := by
      rw [← hEq]
      simp
    simp [Set.mem_singleton_iff] at hmem

end ConstructorTheory.Task
