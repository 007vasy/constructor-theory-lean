/-
Copyright (c) 2026 ben. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: ben
-/
module

public import ConstructorTheory.FormalisationGap

/-!
# The formalisation gap: constructor-theoretic restatements (toy)

Companion to `docs/formalisation-gap/CT_RESTATEMENT.md`. Laws stated as possible/impossible
tasks, in the vocabulary of `Basic` and `Possibility`.

1. **Information and cloning** (Deutsch–Marletto 2015, simplified). `cloneTask X b` asks to
   copy each attribute of `X` onto a blank `b`. `IsInfoVariable` asks that `X` be a variable
   (pairwise-disjoint attributes) whose cloning task is possible. In the deterministic
   (classical) theory `functional`, *every* variable is an information variable
   (`functional_every_variable_info`). So that theory has no superinformation medium
   (`functional_no_superinformation`). This is the formal shape of catalogue row 22:
   "universal copying" is a theorem of classical physics. Quantum theory is, by
   Deutsch–Marletto, a superinformation theory. That direction needs Hilbert-space models and
   is not proved here.
2. **Conservation and the second law as impossibilities** (Marletto 2016, principle VIII and
   the law of impotence, simplified). In `thermo U Ent` the constructors are maps that
   preserve a conserved quantity `U` and do not decrease a monotone `Ent` (entropy-like).
   Changing `U` is impossible, in both directions (`conserved_change_impossible`).
   Decreasing `Ent` is impossible
   (`monotone_decrease_impossible`). A task that raises `Ent` can be possible while its
   transpose is impossible (`irreversible_of`): constructor-theoretic irreversibility in the
   sense of Marletto et al. (PRL 2022), "a task is possible, while its inverse is not".
   `thermo_irreversible_example` shows the hypotheses are satisfiable (two-state substrate).

Simplifications, as in milestone 1: exact limit (no accuracy), constructors are state maps,
real-valued functions are replaced by `ℤ`. No new axioms, no `sorry`.
-/

@[expose] public section

namespace ConstructorTheory

open _root_.ConstructorTheory.Task
open Theory

/-! ## 1. Information variables and cloning -/

/-- A *variable*: a set of pairwise-disjoint attributes. -/
def IsVariable {S : Substrate} (X : Set (Attribute S)) : Prop :=
  X.Pairwise Disjoint

/-- Cloning `X` onto the blank attribute `b`: `x ×ˢ b → x ×ˢ x` for every `x ∈ X`. -/
def cloneTask {S : Substrate} (X : Set (Attribute S)) (b : Attribute S) : Task (S × S) where
  pairs := {p | ∃ x ∈ X, p = (x ×ˢ b, x ×ˢ x)}

/-- An information variable (simplified Deutsch–Marletto): a variable whose cloning task, onto
some blank `b`, is possible. -/
def IsInfoVariable (Θ : Theory) {S : Substrate} (X : Set (Attribute S)) (b : Attribute S) :
    Prop :=
  IsVariable X ∧ Θ.Possible (cloneTask X b)

/-- A superinformation medium (simplified): two information variables whose union is a
variable that is *not* an information variable. -/
def IsSuperinformationMedium (Θ : Theory) (S : Substrate) : Prop :=
  ∃ (X Y : Set (Attribute S)) (b : Attribute S),
    IsInfoVariable Θ X b ∧ IsInfoVariable Θ Y b ∧ IsVariable (X ∪ Y) ∧
      ¬ IsInfoVariable Θ (X ∪ Y) b

/-- In the deterministic theory, the map `(s, t) ↦ (s, s)` clones every attribute. -/
theorem functional_clone_possible {S : Substrate} (X : Set (Attribute S)) (b : Attribute S) :
    functional.Possible (cloneTask X b) := by
  refine ⟨fun p => (p.1, p.1), ?_⟩
  rintro _ ⟨x, -, rfl⟩
  rintro ⟨s, t⟩ ⟨hs, -⟩
  exact ⟨hs, hs⟩

/-- Classical copying: in the deterministic theory every variable is an information variable. -/
theorem functional_every_variable_info {S : Substrate} {X : Set (Attribute S)}
    (hX : IsVariable X) (b : Attribute S) : IsInfoVariable functional X b :=
  ⟨hX, functional_clone_possible X b⟩

/-- The deterministic (classical) theory has no superinformation medium. -/
theorem functional_no_superinformation (S : Substrate) :
    ¬ IsSuperinformationMedium functional S := by
  rintro ⟨X, Y, b, -, -, hXY, hnot⟩
  exact hnot (functional_every_variable_info hXY b)

/-! ## 2. Conservation and irreversibility as impossibilities -/

/-- The task with the single pair `x → y`. -/
def single {S : Substrate} (x y : Attribute S) : Task S where
  pairs := {(x, y)}

/-- A toy thermodynamic theory. Constructors are state maps that preserve `U` (a conserved
quantity) and do not decrease `Ent` (a monotone). -/
def thermo (U Ent : (S : Substrate) → S → ℤ) : Theory where
  Constructor S := {f : S → S // ∀ s, U S (f s) = U S s ∧ Ent S s ≤ Ent S (f s)}
  performs f := {p | Set.MapsTo f.1 p.1 p.2}

/-- First law (Marletto's principle VIII, toy). If every state of `x` has a different `U` from
every state of `y`, and `x` is inhabited, then `x → y` is impossible. -/
theorem conserved_change_impossible {U Ent : (S : Substrate) → S → ℤ} {S : Substrate}
    {x y : Attribute S} (hx : x.Nonempty) (hU : ∀ s ∈ x, ∀ t ∈ y, U S s ≠ U S t) :
    (thermo U Ent).Impossible (single x y) := by
  rintro ⟨f, hf⟩
  rcases hx with ⟨s, hs⟩
  have hmap : Set.MapsTo f.1 x y := hf (Set.mem_singleton _)
  exact hU s hs (f.1 s) (hmap hs) ((f.2 s).1).symm

/-- Perpetual motion of the first kind, as an impossible task: the transpose is impossible too. -/
theorem conserved_change_impossible_both {U Ent : (S : Substrate) → S → ℤ} {S : Substrate}
    {x y : Attribute S} (hx : x.Nonempty) (hy : y.Nonempty)
    (hU : ∀ s ∈ x, ∀ t ∈ y, U S s ≠ U S t) :
    (thermo U Ent).Impossible (single x y) ∧ (thermo U Ent).Impossible (single y x) :=
  ⟨conserved_change_impossible hx hU,
    conserved_change_impossible hy fun t ht s hs h => hU s hs t ht h.symm⟩

/-- Second law (law of impotence, toy). If `Ent` is strictly lower on `y` than on `x`, and `x` is
inhabited, then `x → y` is impossible. -/
theorem monotone_decrease_impossible {U Ent : (S : Substrate) → S → ℤ} {S : Substrate}
    {x y : Attribute S} (hx : x.Nonempty) (hEnt : ∀ s ∈ x, ∀ t ∈ y, Ent S t < Ent S s) :
    (thermo U Ent).Impossible (single x y) := by
  rintro ⟨f, hf⟩
  rcases hx with ⟨s, hs⟩
  have hmap : Set.MapsTo f.1 x y := hf (Set.mem_singleton _)
  exact absurd (hEnt s hs (f.1 s) (hmap hs)) (not_lt.mpr (f.2 s).2)

/-- Irreversibility: if some admissible map performs `x → y` and `Ent` is strictly higher on
`y` than on `x` (with `y` inhabited), then `x → y` is possible and its transpose is not. -/
theorem irreversible_of {U Ent : (S : Substrate) → S → ℤ} {S : Substrate} {x y : Attribute S}
    (f : (thermo U Ent).Constructor S) (hf : Set.MapsTo f.1 x y) (hy : y.Nonempty)
    (hEnt : ∀ s ∈ x, ∀ t ∈ y, Ent S s < Ent S t) :
    (thermo U Ent).Possible (single x y) ∧ (thermo U Ent).Impossible (single y x) := by
  refine ⟨⟨f, ?_⟩, monotone_decrease_impossible hy fun t ht s hs => hEnt s hs t ht⟩
  intro p hp
  rw [Set.mem_singleton_iff.mp hp]
  exact hf

open Classical in
/-- Toy entropy-like monotone: on `Bool`, 1 on `true` and 0 on `false`; 0 on other substrates. -/
noncomputable def toyEnt (S : Substrate) (s : S) : ℤ :=
  if h : S = Bool then (if cast h s then 1 else 0) else 0

theorem toyEnt_bool (b : Bool) : toyEnt Bool b = if b then 1 else 0 := by
  simp [toyEnt]

/-- The toy is not vacuous: on a two-state substrate (`U` constant, `Ent = toyEnt`), "heating"
`false → true` is possible and "cooling" `true → false` is impossible. -/
theorem thermo_irreversible_example :
    (thermo (fun _ _ => 0) toyEnt).Possible (single ({false} : Attribute Bool) {true}) ∧
    (thermo (fun _ _ => 0) toyEnt).Impossible (single ({true} : Attribute Bool) {false}) := by
  refine irreversible_of ⟨fun _ => true, fun s => ⟨rfl, ?_⟩⟩ ?_ ⟨true, rfl⟩ ?_
  · cases s <;> simp [toyEnt_bool]
  · intro s _; rfl
  · rintro s rfl t rfl; simp [toyEnt_bool]

#print axioms functional_no_superinformation
#print axioms conserved_change_impossible_both
#print axioms monotone_decrease_impossible
#print axioms irreversible_of
#print axioms thermo_irreversible_example

end ConstructorTheory
