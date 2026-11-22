/-
Copyright (c) 2026 ben. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: ben
-/
module

public import ConstructorTheory.Possibility
public import Mathlib.Data.Set.Finite.Basic
public import Mathlib.Order.Interval.Set.Infinite
public import Mathlib.Basic.Real.Basic
public import Mathlib.Data.Set.Finite.Range

/-!
# The formalisation gap: why classical laws break down at the quantum level (toy formal content)

Companion to `docs/formalisation-gap/`. The catalogue there tags each classical law with
the classical *assumptions* that fail in the quantum regime. This file formalizes three
small, honest pieces of that story. None of it is quantum mechanics; it is the
constructor-theoretic and counting skeleton that the explanation leans on.

1. `BreakdownAssumption` and `catalogue`: the classification used in `PATTERN.md`, as
   data, with facts about the table checked by `decide`. These are facts about our
   tagging, not about nature.
2. **Continuum vs countable states** (`no_continuum_info_variable_of_finite`,
   `finite_substrate_misses_interval`). A substrate with finitely many states cannot carry
   a family of pairwise-disjoint, non-empty attributes indexed by `ℝ`, and any real-valued
   quantity on it misses every open interval. This is the skeleton of Kuypers' droplet
   argument: a finite-atom neck cannot pass through a continuum of radii.
3. **Distinguishability needs disjointness** (`functional`, `disjoint_of_distinguish`).
   In the theory whose constructors are deterministic state maps, a task that sends
   attributes `x` and `y` to disjoint outputs is possible only if `x` and `y` are
   disjoint. Overlapping attributes are a classical stand-in for non-orthogonal quantum
   states; the quantum statement (no measurement perfectly distinguishes non-orthogonal
   states) needs Hilbert-space structure and is not proved here.

No new axioms and no `sorry`; `#print axioms` at the end shows only Lean's standard
`propext`, `Classical.choice`, `Quot.sound`.
-/

@[expose] public section

namespace ConstructorTheory

open _root_.ConstructorTheory.Task
open Theory

/-! ## 1. The classification, as data -/

/-- Classical assumptions whose failure explains the breakdown of classical laws.
See `docs/formalisation-gap/PATTERN.md` for the physics behind each tag. -/
inductive BreakdownAssumption where
  /-- Physical quantities and modes vary continuously; energy is infinitely divisible. -/
  | continuum
  /-- All observables have sharp values simultaneously (phase-space points exist). -/
  | jointSharpness
  /-- Correlations are explained by local, pre-existing values (local realism). -/
  | localRealism
  /-- Every state can be perfectly distinguished and copied. -/
  | universalDistinguishability
  /-- Identical particles are individually labelled (Boltzmann counting). -/
  | labelledIdentity
  /-- A smooth background spacetime/field description holds at all scales. -/
  | smoothAllScales
  deriving DecidableEq, Repr

open BreakdownAssumption

/-- The catalogue of `docs/formalisation-gap/CATALOGUE.md`: each entry is a short name
and the assumptions we tag it with. The tagging is our analysis, not a theorem. -/
def catalogue : List (String × List BreakdownAssumption) :=
  [ ("Newton/Hamilton trajectories", [jointSharpness, continuum])
  , ("Liouville phase-space density", [jointSharpness])
  , ("Rayleigh-Jeans law", [continuum])
  , ("Equipartition theorem", [continuum])
  , ("Dulong-Petit law", [continuum])
  , ("Larmor radiation / classical atom", [continuum, jointSharpness])
  , ("Wien/Lenard photoelectric expectation", [continuum])
  , ("Maxwell-Boltzmann statistics", [labelledIdentity])
  , ("Gibbs entropy without 1/N!", [labelledIdentity])
  , ("Drude conductivity at low T", [labelledIdentity, continuum])
  , ("Curie law / Bohr-van Leeuwen", [continuum, jointSharpness])
  , ("Classical spin (Stern-Gerlach)", [continuum, jointSharpness])
  , ("Classical vacuum (no Casimir)", [continuum, jointSharpness])
  , ("Fourier heat law at nanoscale", [smoothAllScales, continuum])
  , ("Navier-Stokes at pinch-off/superfluid", [smoothAllScales, continuum])
  , ("Third law vs classical entropy", [continuum])
  , ("Bell local hidden variables", [localRealism, jointSharpness])
  , ("Classical measurement (no disturbance)", [universalDistinguishability, jointSharpness])
  , ("Universal copying of information", [universalDistinguishability])
  , ("Classical tunnelling barrier", [jointSharpness])
  , ("Einstein field equations at Planck scale", [smoothAllScales, continuum])
  , ("QFT without cutoff (UV divergences)", [smoothAllScales])
  , ("Non-contextual values (Mermin-Peres magic square)", [jointSharpness])
  ]

/-- Number of laws carrying a given tag. -/
def tagCount (a : BreakdownAssumption) : Nat :=
  (catalogue.filter fun e => decide (a ∈ e.2)).length

theorem catalogue_length : catalogue.length = 23 := by decide

/-- Every catalogued law is tagged with at least one failing assumption. -/
theorem catalogue_all_tagged : ∀ e ∈ catalogue, e.2 ≠ [] := by decide

/-- In our tagging, the continuum assumption is the most common culprit. -/
theorem continuum_most_common :
    tagCount continuum = 14 ∧ tagCount jointSharpness = 10 ∧
      tagCount labelledIdentity = 3 ∧ tagCount smoothAllScales = 4 ∧
      tagCount localRealism = 1 ∧ tagCount universalDistinguishability = 2 := by
  decide

/-! ## 2. Continuum vs finitely many states -/

/-- An *information variable* in the sense of Deutsch–Marletto, simplified: a family of
non-empty, pairwise-disjoint attributes indexed by `ι`. -/
structure InfoVariable (S : Substrate) (ι : Type) where
  attr : ι → Attribute S
  nonempty : ∀ i, (attr i).Nonempty
  disjoint : Pairwise fun i j => Disjoint (attr i) (attr j)

namespace InfoVariable

/-- Choose a witness state for each value; distinct values give distinct states. -/
theorem witness_injective {S : Substrate} {ι : Type} (V : InfoVariable S ι) :
    Function.Injective fun i => (V.nonempty i).some := by
  intro i j hij
  by_contra hne
  have hi : (V.nonempty i).some ∈ V.attr i := (V.nonempty i).some_mem
  have hj : (V.nonempty i).some ∈ V.attr j := by
    simp only at hij
    rw [hij]
    exact (V.nonempty j).some_mem
  exact Set.disjoint_left.mp (V.disjoint hne) hi hj

/-- A finite substrate can only carry finitely-valued information variables. -/
theorem finite_index {S : Substrate} [Finite S] {ι : Type} (V : InfoVariable S ι) :
    Finite ι :=
  Finite.of_injective _ V.witness_injective

end InfoVariable

/-- No substrate with finitely many states carries a sharp, real-valued (continuum)
information variable. -/
theorem no_continuum_info_variable_of_finite (S : Substrate) [Finite S] :
    IsEmpty (InfoVariable S ℝ) :=
  ⟨fun V => by
    have := V.finite_index
    exact (Set.infinite_univ (α := ℝ)) (Set.toFinite _)⟩

/-- Kuypers' droplet, in toy form. If a fluid neck is made of finitely many atomic
configurations `S`, any real-valued neck radius `r : S → ℝ` takes finitely many values,
so it cannot sweep through any open interval of radii. Continuum hydrodynamics assumes
that it does, which is why it fails at pinch-off. -/
theorem finite_substrate_misses_interval {S : Substrate} [Finite S] (r : S → ℝ)
    {a b : ℝ} (hab : a < b) : ¬ Set.Ioo a b ⊆ Set.range r := by
  intro h
  exact (Set.Ioo_infinite hab) ((Set.finite_range r).subset h)

/-! ## 3. Distinguishing a pair of attributes requires them to be disjoint -/

/-- The deterministic theory: constructors on `S` are state maps `S → S`, and a map
performs `x → y` when it sends every state of `x` into `y`. -/
def functional : Theory where
  Constructor S := S → S
  performs f := {p | Set.MapsTo f p.1 p.2}

/-- The task "send `x` to `x'` and `y` to `y'`". -/
def distinguishTask {S : Substrate} (x y x' y' : Attribute S) : Task S where
  pairs := {(x, x'), (y, y')}

/-- In the deterministic theory, if `x` and `y` can be sent to disjoint outputs, then
`x` and `y` were already disjoint. Equivalently, overlapping attributes cannot be
perfectly distinguished. -/
theorem disjoint_of_distinguish {S : Substrate} {x y x' y' : Attribute S}
    (hout : Disjoint x' y') (h : functional.Possible (distinguishTask x y x' y')) :
    Disjoint x y := by
  rcases h with ⟨f, hf⟩
  have hx : Set.MapsTo f x x' := 
    hf (show (x, x') ∈ (distinguishTask x y x' y').pairs from Or.inl rfl)
  have hy : Set.MapsTo f y y' := 
    hf (show (y, y') ∈ (distinguishTask x y x' y').pairs from Or.inr rfl)
  rw [Set.disjoint_left]
  intro s hsx hsy
  exact Set.disjoint_left.mp hout (hx hsx) (hy hsy)

/-- Contrapositive: distinguishing overlapping attributes is impossible. -/
theorem distinguish_impossible_of_overlap {S : Substrate} {x y x' y' : Attribute S}
    (hout : Disjoint x' y') (hover : (x ∩ y).Nonempty) :
    functional.Impossible (distinguishTask x y x' y') := by
  intro h
  rcases hover with ⟨s, hsx, hsy⟩
  exact Set.disjoint_left.mp (disjoint_of_distinguish hout h) hsx hsy

/-- Sanity check: disjoint attributes *can* be distinguished when the outputs are
inhabited (the map is built classically). -/
theorem distinguish_possible_of_disjoint {S : Substrate} {x y x' y' : Attribute S}
    (hxy : Disjoint x y) {a b : S} (ha : a ∈ x') (hb : b ∈ y') :
    functional.Possible (distinguishTask x y x' y') := by
  classical
  refine ⟨fun s => if s ∈ x then a else b, ?_⟩
  intro p hp
  simp only [distinguishTask, Set.mem_insert_iff, Set.mem_singleton_iff] at hp
  rcases hp with rfl | rfl
  · intro s hs
    simp [hs, ha]
  · intro s hs
    have : s ∉ x := fun hsx => Set.disjoint_left.mp hxy hsx hs
    simp [this, hb]

/-! ## Axiom audit -/

#print axioms no_continuum_info_variable_of_finite
#print axioms finite_substrate_misses_interval
#print axioms distinguish_impossible_of_overlap
#print axioms continuum_most_common

end ConstructorTheory
