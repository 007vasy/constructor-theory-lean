/-
Copyright (c) 2026 ben. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: ben
-/
module

public import Mathlib.Data.Set.Prod

/-!
# Substrates, attributes, and tasks

Constructor theory (Deutsch 2013; Deutsch and Marletto 2015) states physical laws as
which tasks on substrates are possible and which are impossible. This module is the
vocabulary of that statement. Modelling departures from the papers are recorded in
`NOTES.md`.

* A **substrate** is a type of states.
* An **attribute** is a set of states of a substrate.
* A **task** is a set of input-attribute to output-attribute pairs.
-/

@[expose] public section

namespace ConstructorTheory

/-- A substrate is a type of states.

In the papers a substrate is a physical system. The states are its most specific
descriptions, and every attribute is a set of those states.
-/
abbrev Substrate := Type

/-- An attribute of a substrate `S` is a set of states of `S`. -/
abbrev Attribute (S : Substrate) := Set S

/-- A task on a substrate is a set of input/output attribute pairs.

This is `𝔄 = {x₁ → y₁, x₂ → y₂, …}` in Deutsch and Marletto. The input attributes of
a task that a constructor can actually perform are required, in the papers, to be
pairwise disjoint; that requirement is the predicate `Task.hasDisjointInputs`, not
part of the data of a task.
-/
structure Task (S : Substrate) where
  pairs : Set (Attribute S × Attribute S)

namespace Task

/-- Tasks with the same pair-set are equal. -/
@[ext]
theorem ext {S : Substrate} {A B : Task S} (h : A.pairs = B.pairs) : A = B := by
  cases A with
  | mk p =>
    cases B with
    | mk q =>
      cases h
      rfl

/-- `A ⊑ B` means `A` is a subtask of `B`: every input/output pair of `A` is a pair of `B`. -/
def IsSubtask {S : Substrate} (A B : Task S) : Prop :=
  A.pairs ⊆ B.pairs

/-- Input attributes occurring in `T` are pairwise disjoint.

Deutsch and Marletto require this of a task a constructor performs: a state cannot be
asked to undergo two different transformations.
-/
def hasDisjointInputs {S : Substrate} (T : Task S) : Prop :=
  ∀ x₁ y₁ x₂ y₂ : Attribute S,
    (x₁, y₁) ∈ T.pairs → (x₂, y₂) ∈ T.pairs → x₁ ≠ x₂ → Disjoint x₁ x₂

/-- `T` prescribes at most one output attribute for each input attribute. -/
def isFunctional {S : Substrate} (T : Task S) : Prop :=
  ∀ x y y' : Attribute S, (x, y) ∈ T.pairs → (x, y') ∈ T.pairs → y = y'

/-- Every output attribute of `T` is inhabited.

Empty attributes collapse Cartesian products (`∅ ×ˢ _ = ∅`), so theorems that cancel a
product of attributes assume this.
-/
def outputsNonempty {S : Substrate} (T : Task S) : Prop :=
  ∀ x y : Attribute S, (x, y) ∈ T.pairs → y.Nonempty

/-- The task with no input/output requirements. -/
def empty (S : Substrate) : Task S where
  pairs := ∅

/-- The task that fixes every attribute in the family `X` (`x → x` for `x ∈ X`). -/
def idOn {S : Substrate} (X : Set (Attribute S)) : Task S where
  pairs := {p | ∃ x : Attribute S, x ∈ X ∧ p = (x, x)}

/-- Pointwise union of two tasks on the same substrate. -/
def union {S : Substrate} (A B : Task S) : Task S where
  pairs := A.pairs ∪ B.pairs

/-- Serial composition: perform `A`, then `B`.

`(x, z)` lies in `A.serial B` when some intermediate attribute `y` is an output of `A`
on input `x` and an input of `B` toward output `z`. This is relational composition of
the pair-set, in diagrammatic order (the left-hand task runs first), matching the
reading of the composite task `𝔄𝔅` in Deutsch and Marletto.
-/
def serial {S : Substrate} (A B : Task S) : Task S where
  pairs := {p | ∃ x y z : Attribute S, p = (x, z) ∧ (x, y) ∈ A.pairs ∧ (y, z) ∈ B.pairs}

/-- The transpose task, written `𝔄~` in the papers: swap every input with its output. -/
def transpose {S : Substrate} (A : Task S) : Task S where
  pairs := {p | ∃ x y : Attribute S, (x, y) ∈ A.pairs ∧ p = (y, x)}

/-- Parallel composition on the product substrate.

`A.parallel B` effects `A` on the first factor and `B` on the second. An input pair
`(x, u)` is sent to `(y, v)` by taking the Cartesian product of the attributes.
-/
def parallel {S T : Substrate} (A : Task S) (B : Task T) : Task (S × T) where
  pairs :=
    {p | ∃ x y : Attribute S, ∃ u v : Attribute T,
      (x, y) ∈ A.pairs ∧ (u, v) ∈ B.pairs ∧ p = (x ×ˢ u, y ×ˢ v)}

scoped infixl:50 " ⊑ " => IsSubtask

scoped infixl:70 " ⊚ " => serial

scoped infixl:75 " ⊗ " => parallel

scoped postfix:max "ᵀ" => transpose

@[simp]
theorem mem_empty_pairs {S : Substrate} (p : Attribute S × Attribute S) :
    p ∈ (empty S).pairs ↔ False := by
  simp [empty]

@[simp]
theorem mem_idOn_pairs {S : Substrate} {X : Set (Attribute S)} {a b : Attribute S} :
    (a, b) ∈ (idOn X).pairs ↔ a ∈ X ∧ a = b := by
  constructor
  · rintro ⟨x, hx, heq⟩
    cases heq
    exact ⟨hx, rfl⟩
  · rintro ⟨ha, rfl⟩
    exact ⟨a, ha, rfl⟩

@[simp]
theorem mem_union_pairs {S : Substrate} {A B : Task S} {p : Attribute S × Attribute S} :
    p ∈ (A.union B).pairs ↔ p ∈ A.pairs ∨ p ∈ B.pairs := by
  simp [union]

@[simp]
theorem mem_serial_pairs {S : Substrate} {A B : Task S} {x z : Attribute S} :
    (x, z) ∈ (A ⊚ B).pairs ↔ ∃ y : Attribute S, (x, y) ∈ A.pairs ∧ (y, z) ∈ B.pairs := by
  constructor
  · rintro ⟨x', y, z', heq, hx, hz⟩
    cases heq
    exact ⟨y, hx, hz⟩
  · rintro ⟨y, hx, hz⟩
    exact ⟨x, y, z, rfl, hx, hz⟩

@[simp]
theorem mem_transpose_pairs {S : Substrate} {A : Task S} {y x : Attribute S} :
    (y, x) ∈ (Aᵀ).pairs ↔ (x, y) ∈ A.pairs := by
  constructor
  · rintro ⟨x', y', hxy, heq⟩
    cases heq
    exact hxy
  · intro hxy
    exact ⟨x, y, hxy, rfl⟩

@[simp]
theorem mem_parallel_pairs {S T : Substrate} {A : Task S} {B : Task T}
    {p q : Attribute (S × T)} :
    (p, q) ∈ (A ⊗ B).pairs ↔
      ∃ x y : Attribute S, ∃ u v : Attribute T,
        (x, y) ∈ A.pairs ∧ (u, v) ∈ B.pairs ∧ p = x ×ˢ u ∧ q = y ×ˢ v := by
  constructor
  · rintro ⟨x, y, u, v, hA, hB, heq⟩
    cases heq
    exact ⟨x, y, u, v, hA, hB, rfl, rfl⟩
  · rintro ⟨x, y, u, v, hA, hB, rfl, rfl⟩
    exact ⟨x, y, u, v, hA, hB, rfl⟩

end Task

end ConstructorTheory
