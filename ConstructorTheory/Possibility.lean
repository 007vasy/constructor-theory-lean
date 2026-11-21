/-
Copyright (c) 2026 ben. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: ben
-/
module

public import ConstructorTheory.Algebra

/-!
# Constructors, possibility, and the composition principles

A task is possible when some constructor performs it. Performing a task means carrying
every one of its input/output pairs out exactly, and retaining the capacity to do so
again. Both clauses are read into the predicate `Performs`; this module does not equip
a constructor with an internal substrate.

"Arbitrarily high accuracy" is the exact limit. `performs` records that limiting
capability. There is no metric of states and no `ε`-approximate constructor in this
milestone.

The serial and parallel composition principles are hypotheses on a theory, not
theorems. `ConstructorTheory.Models` shows they are independent of the task algebra
and jointly consistent.
-/

@[expose] public section

namespace ConstructorTheory

open _root_.ConstructorTheory.Task

/-- A constructor theory is an abstract supply of reusable constructors.

`Constructor S` is the type of constructors that act on the substrate `S`.
`performs C` is the set of attribute pairs that `C` transforms in the exact limit of
arbitrarily high accuracy. Reusability is part of that meaning: the relation does not
consume `C`. The constructor is not itself modelled as a substrate, so retention of
capacity is not a theorem about a preserved attribute. It is the reading of `Performs`.
-/
structure Theory where
  Constructor : Substrate → Type
  performs : {S : Substrate} → Constructor S → Set (Attribute S × Attribute S)

namespace Theory

/-- `C` performs `T` when every pair of `T` is within `C`'s limiting capability. -/
def Performs {Θ : Theory} {S : Substrate} (C : Θ.Constructor S) (T : Task S) : Prop :=
  T.pairs ⊆ Θ.performs C

/-- `T` is possible in `Θ` when some constructor of `Θ` performs it. -/
def Possible (Θ : Theory) {S : Substrate} (T : Task S) : Prop :=
  ∃ C : Θ.Constructor S, Θ.Performs C T

/-- `T` is impossible when it is not possible. -/
def Impossible (Θ : Theory) {S : Substrate} (T : Task S) : Prop :=
  ¬ Θ.Possible T

/-- A subtask of a possible task is possible.

The same constructor performs fewer pairs. This is the formal content of "a constructor
for a task is a constructor for each of its subtasks".
-/
theorem Possible.subtask {Θ : Theory} {S : Substrate} {A B : Task S}
    (hB : Θ.Possible B) (hAB : A ⊑ B) : Θ.Possible A := by
  rcases hB with ⟨C, hC⟩
  exact ⟨C, fun p hp => hC (hAB hp)⟩

/-- A task with an impossible subtask is impossible.

Constructor-theoretic impossibility proofs often restrict attention to a subtask.
This is the contrapositive of `Possible.subtask`.
-/
theorem Impossible.of_subtask {Θ : Theory} {S : Substrate} {A B : Task S}
    (hA : Θ.Impossible A) (hAB : A ⊑ B) : Θ.Impossible B := by
  intro hB
  exact hA (Possible.subtask hB hAB)

/-- If any constructor for `S` exists, the empty task on `S` is possible. -/
theorem Possible.empty_of_nonempty {Θ : Theory} {S : Substrate}
    (hS : Nonempty (Θ.Constructor S)) : Θ.Possible (Task.empty S) := by
  rcases hS with ⟨C⟩
  exact ⟨C, by simp [Performs, Task.empty]⟩

/-- Possibility passes along subtasks of a serial composite, with no composition principle.

If `A' ⊚ B'` is possible and `A`, `B` are subtasks of `A'`, `B'`, then `A ⊚ B` is possible.
-/
theorem Possible.of_serial_subtasks {Θ : Theory} {S : Substrate}
    {A A' B B' : Task S} (h : Θ.Possible (A' ⊚ B')) (hA : A ⊑ A') (hB : B ⊑ B') :
    Θ.Possible (A ⊚ B) :=
  Possible.subtask h (Task.IsSubtask.serial hA hB)

/-- Serial composition principle.

If `A` and `B` are possible on the same substrate, then "do `A`, then `B`" is possible.
This is a physical hypothesis about composing reusable constructors. It is not a
consequence of the task algebra: see `serialBreak_not_serial` in `Models.lean`.
-/
def SerialCompositionPrinciple (Θ : Theory) : Prop :=
  ∀ {S : Substrate} (A B : Task S), Θ.Possible A → Θ.Possible B → Θ.Possible (A ⊚ B)

/-- Parallel composition principle.

Possible tasks on two substrates yield a possible task on the product substrate that
effects both. Independent of the task algebra: see `parallelBreak_not_parallel`.
-/
def ParallelCompositionPrinciple (Θ : Theory) : Prop :=
  ∀ {S T : Substrate} (A : Task S) (B : Task T),
    Θ.Possible A → Θ.Possible B → Θ.Possible (A ⊗ B)

/-- If `A` is possible and `A ⊚ B` is impossible, then `B` is impossible. -/
theorem Impossible.of_serial_right {Θ : Theory}
    (hΘ : Θ.SerialCompositionPrinciple) {S : Substrate} {A B : Task S}
    (hA : Θ.Possible A) (hAB : Θ.Impossible (A ⊚ B)) : Θ.Impossible B := by
  intro hB
  exact hAB (hΘ A B hA hB)

/-- If `B` is possible and `A ⊚ B` is impossible, then `A` is impossible. -/
theorem Impossible.of_serial_left {Θ : Theory}
    (hΘ : Θ.SerialCompositionPrinciple) {S : Substrate} {A B : Task S}
    (hB : Θ.Possible B) (hAB : Θ.Impossible (A ⊚ B)) : Θ.Impossible A := by
  intro hA
  exact hAB (hΘ A B hA hB)

/-- A chain of three possible tasks is possible, under the serial composition principle. -/
theorem Possible.serial_chain₃ {Θ : Theory} (hΘ : Θ.SerialCompositionPrinciple)
    {S : Substrate} {A B C : Task S}
    (hA : Θ.Possible A) (hB : Θ.Possible B) (hC : Θ.Possible C) :
    Θ.Possible ((A ⊚ B) ⊚ C) :=
  hΘ (A ⊚ B) C (hΘ A B hA hB) hC

/-- The other parenthesization is the same task, hence also possible. -/
theorem Possible.serial_chain₃' {Θ : Theory} (hΘ : Θ.SerialCompositionPrinciple)
    {S : Substrate} {A B C : Task S}
    (hA : Θ.Possible A) (hB : Θ.Possible B) (hC : Θ.Possible C) :
    Θ.Possible (A ⊚ (B ⊚ C)) := by
  rw [← Task.serial_assoc]
  exact Possible.serial_chain₃ hΘ hA hB hC

/-- Under both composition principles, serial-then-parallel is possible. -/
theorem Possible.parallel_of_serial {Θ : Theory}
    (hS : Θ.SerialCompositionPrinciple) (hP : Θ.ParallelCompositionPrinciple)
    {S T : Substrate} {A₁ B₁ : Task S} {A₂ B₂ : Task T}
    (hA₁ : Θ.Possible A₁) (hB₁ : Θ.Possible B₁)
    (hA₂ : Θ.Possible A₂) (hB₂ : Θ.Possible B₂) :
    Θ.Possible ((A₁ ⊚ B₁) ⊗ (A₂ ⊚ B₂)) :=
  hP (A₁ ⊚ B₁) (A₂ ⊚ B₂) (hS A₁ B₁ hA₁ hB₁) (hS A₂ B₂ hA₂ hB₂)

/-- Under both composition principles, parallel-then-serial is possible. -/
theorem Possible.serial_of_parallel {Θ : Theory}
    (hS : Θ.SerialCompositionPrinciple) (hP : Θ.ParallelCompositionPrinciple)
    {S T : Substrate} {A₁ B₁ : Task S} {A₂ B₂ : Task T}
    (hA₁ : Θ.Possible A₁) (hB₁ : Θ.Possible B₁)
    (hA₂ : Θ.Possible A₂) (hB₂ : Θ.Possible B₂) :
    Θ.Possible ((A₁ ⊗ A₂) ⊚ (B₁ ⊗ B₂)) :=
  hS (A₁ ⊗ A₂) (B₁ ⊗ B₂) (hP A₁ A₂ hA₁ hA₂) (hP B₁ B₂ hB₁ hB₂)

/-- With non-empty outputs the two schedules of `parallel_of_serial` and `serial_of_parallel`
are the same task, by `Task.serial_parallel_interchange`. Both are possible.
-/
theorem Possible.schedules_agree {Θ : Theory}
    (hS : Θ.SerialCompositionPrinciple) (hP : Θ.ParallelCompositionPrinciple)
    {S T : Substrate} {A₁ B₁ : Task S} {A₂ B₂ : Task T}
    (hA₁ : Θ.Possible A₁) (hB₁ : Θ.Possible B₁)
    (hA₂ : Θ.Possible A₂) (hB₂ : Θ.Possible B₂)
    (hne₁ : A₁.outputsNonempty) (hne₂ : A₂.outputsNonempty) :
    (A₁ ⊗ A₂) ⊚ (B₁ ⊗ B₂) = (A₁ ⊚ B₁) ⊗ (A₂ ⊚ B₂) ∧
      Θ.Possible ((A₁ ⊗ A₂) ⊚ (B₁ ⊗ B₂)) :=
  ⟨Task.serial_parallel_interchange hne₁ hne₂,
    Possible.serial_of_parallel hS hP hA₁ hB₁ hA₂ hB₂⟩

end Theory

end ConstructorTheory
