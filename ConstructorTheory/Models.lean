/-
Copyright (c) 2026 ben. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: ben
-/
module

public import ConstructorTheory.Possibility
public import Mathlib.Data.Fintype.Card
public import Mathlib.Data.Fintype.Prod

/-!
# Models: consistency and independence

Four constructor theories, used as sanity checks rather than as physics.

* `omnipotent` can perform every task. Both composition principles hold.
* `inert` can perform only the empty task. Both composition principles hold.
* `irreversible` can perform `{0} → {1}` on `Fin 3` and not its transpose.
* `serialBreak` can perform `{0} → {1}` and `{1} → {2}` but not the composite.
* `parallelBreak` can perform a task on `Fin 3` whose parallel on `Fin 3 × Fin 3`
  is impossible, because that product is not the substrate the theory can act on.

No law of physics is being asserted by these models. They show which implications are
theorems of the definitions and which need a composition principle.
-/

@[expose] public section

namespace ConstructorTheory

open _root_.ConstructorTheory.Task
open Theory

/-- Transport a set of attribute pairs along an equality of substrates. -/
def castPairs {S T : Substrate} (h : S = T) (p : Set (Attribute S × Attribute S)) :
    Set (Attribute T × Attribute T) :=
  cast (congrArg (fun X : Substrate => Set (Attribute X × Attribute X)) h) p

/-- One constructor for every substrate, capable of every attribute pair. -/
def omnipotent : Theory where
  Constructor _S := Unit
  performs _C := Set.univ

/-- Every task is possible for `omnipotent`. -/
theorem omnipotent_possible {S : Substrate} (T : Task S) : omnipotent.Possible T :=
  ⟨(), fun _ _ => Set.mem_univ _⟩

theorem omnipotent_serial : omnipotent.SerialCompositionPrinciple :=
  fun {_S} A B _hA _hB => omnipotent_possible (A ⊚ B)

theorem omnipotent_parallel : omnipotent.ParallelCompositionPrinciple :=
  fun {_S _T} A B _hA _hB => omnipotent_possible (A ⊗ B)

/-- The two composition principles are jointly consistent. -/
theorem composition_principles_consistent :
    ∃ Θ : Theory, Θ.SerialCompositionPrinciple ∧ Θ.ParallelCompositionPrinciple :=
  ⟨omnipotent, omnipotent_serial, omnipotent_parallel⟩

/-- One constructor for every substrate, capable of no attribute pair. -/
def inert : Theory where
  Constructor _S := Unit
  performs _C := ∅

/-- `inert` can perform a task if and only if the task asks for nothing. -/
theorem inert_possible_iff {S : Substrate} (T : Task S) :
    inert.Possible T ↔ T = Task.empty S := by
  constructor
  · rintro ⟨_C, hC⟩
    apply Task.ext
    ext p
    simp only [Task.mem_empty_pairs, iff_false]
    intro hp
    exact hC hp
  · rintro rfl
    exact ⟨(), by simp [Performs, Task.empty]⟩

theorem inert_serial : inert.SerialCompositionPrinciple := by
  intro S A B hA hB
  have hAe : A = Task.empty S := (inert_possible_iff A).1 hA
  have hBe : B = Task.empty S := (inert_possible_iff B).1 hB
  rw [hAe, hBe, Task.serial_empty_left]
  exact (inert_possible_iff _).2 rfl

theorem inert_parallel : inert.ParallelCompositionPrinciple := by
  intro S T A B hA hB
  have hAe : A = Task.empty S := (inert_possible_iff A).1 hA
  have hBe : B = Task.empty T := (inert_possible_iff B).1 hB
  rw [hAe, hBe, Task.parallel_empty_left]
  exact (inert_possible_iff _).2 rfl

/-- A task with a pair is impossible in `inert`, while the composition principles hold. -/
theorem inert_impossible_of_pair {S : Substrate} {T : Task S}
    (h : ∃ p : Attribute S × Attribute S, p ∈ T.pairs) : inert.Impossible T := by
  intro hT
  rcases h with ⟨p, hp⟩
  have hE : T = Task.empty S := (inert_possible_iff T).1 hT
  rw [hE] at hp
  simp [Task.empty] at hp

/-! ### An irreversible task -/

/-- The task `{0} → {1}` on a three-state substrate. -/
def step01 : Task (Fin 3) where
  pairs := {({0}, {1})}

/-- The task `{1} → {2}` on a three-state substrate. -/
def step12 : Task (Fin 3) where
  pairs := {({1}, {2})}

/-- A constructor exists only for `Fin 3`, and it performs exactly `step01`. -/
def irreversible : Theory where
  Constructor S := PLift (S = Fin 3)
  performs h := castPairs h.down.symm step01.pairs

theorem irreversible_step01 : irreversible.Possible step01 := by
  refine ⟨PLift.up rfl, ?_⟩
  intro p hp
  simpa [Performs, irreversible, castPairs] using hp

theorem irreversible_not_transpose : irreversible.Impossible (step01ᵀ) := by
  intro h
  rcases h with ⟨⟨hS⟩, hsub⟩
  have hmem : (({1} : Attribute (Fin 3)), {0}) ∈ (step01ᵀ).pairs := by
    simp [step01]
  have hcast : irreversible.performs ⟨hS⟩ = step01.pairs := by
    cases hS
    rfl
  have : (({1} : Attribute (Fin 3)), {0}) ∈ step01.pairs := by
    simpa [Performs, hcast] using hsub hmem
  simp [step01] at this

/-- The transpose of a possible task need not be possible. -/
theorem possible_transpose_not_necessary :
    ∃ (Θ : Theory) (T : Task (Fin 3)), Θ.Possible T ∧ Θ.Impossible (Tᵀ) :=
  ⟨irreversible, step01, irreversible_step01, irreversible_not_transpose⟩

/-! ### Serial composition is independent -/

/-- Constructors for `Fin 3` perform `step01` and `step12`, but not their composite. -/
def serialBreak : Theory where
  Constructor S := PLift (S = Fin 3)
  performs h := castPairs h.down.symm (step01.pairs ∪ step12.pairs)

theorem serialBreak_step01 : serialBreak.Possible step01 := by
  refine ⟨PLift.up rfl, ?_⟩
  intro p hp
  have : p ∈ step01.pairs ∪ step12.pairs := Or.inl hp
  simpa [Performs, serialBreak, castPairs] using this

theorem serialBreak_step12 : serialBreak.Possible step12 := by
  refine ⟨PLift.up rfl, ?_⟩
  intro p hp
  have : p ∈ step01.pairs ∪ step12.pairs := Or.inr hp
  simpa [Performs, serialBreak, castPairs] using this

theorem serialBreak_not_composite : serialBreak.Impossible (step01 ⊚ step12) := by
  intro h
  rcases h with ⟨⟨hS⟩, hsub⟩
  have hpair : (({0} : Attribute (Fin 3)), {2}) ∈ (step01 ⊚ step12).pairs := by
    rw [Task.mem_serial_pairs]
    refine ⟨{1}, ?_, ?_⟩
    · simp [step01]
    · simp [step12]
  have hcast : serialBreak.performs ⟨hS⟩ = step01.pairs ∪ step12.pairs := by
    cases hS
    rfl
  have hmem : (({0} : Attribute (Fin 3)), {2}) ∈ step01.pairs ∪ step12.pairs := by
    simpa [Performs, hcast] using hsub hpair
  simp only [step01, step12, Set.mem_union, Set.mem_singleton_iff] at hmem
  rcases hmem with hmem | hmem
  · have h21 : ({2} : Attribute (Fin 3)) = {1} := congrArg Prod.snd hmem
    have htwo : (2 : Fin 3) ∈ ({1} : Set (Fin 3)) := by
      rw [← h21]
      simp
    simp [Set.mem_singleton_iff] at htwo
  · have h01 : ({0} : Attribute (Fin 3)) = {1} := congrArg Prod.fst hmem
    have hzero : (0 : Fin 3) ∈ ({1} : Set (Fin 3)) := by
      rw [← h01]
      simp
    simp [Set.mem_singleton_iff] at hzero

/-- Possible steps need not compose: the serial composition principle is not a theorem. -/
theorem serialBreak_not_serial : ¬ serialBreak.SerialCompositionPrinciple := by
  intro hprin
  exact serialBreak_not_composite (hprin step01 step12 serialBreak_step01 serialBreak_step12)

/-! ### Parallel composition is independent -/

/-- A constructor exists only for `Fin 3`, and it can perform every task there. -/
def parallelBreak : Theory where
  Constructor S := PLift (S = Fin 3)
  performs _h := Set.univ

theorem parallelBreak_step01 : parallelBreak.Possible step01 :=
  ⟨PLift.up rfl, fun _ _ => Set.mem_univ _⟩

/-- `Fin 3` is not the product substrate `Fin 3 × Fin 3`. -/
theorem fin3_ne_prod : Fin 3 ≠ (Fin 3 × Fin 3) := by
  intro h
  have hc : Fintype.card (Fin 3) = Fintype.card (Fin 3 × Fin 3) :=
    Fintype.card_congr (Equiv.cast h)
  simp [Fintype.card_fin, Fintype.card_prod] at hc

theorem parallelBreak_not_parallel : ¬ parallelBreak.ParallelCompositionPrinciple := by
  intro hprin
  have hcomp : parallelBreak.Possible (step01 ⊗ step01) :=
    hprin step01 step01 parallelBreak_step01 parallelBreak_step01
  rcases hcomp with ⟨⟨hS⟩, _hsub⟩
  exact fin3_ne_prod hS.symm

end ConstructorTheory
