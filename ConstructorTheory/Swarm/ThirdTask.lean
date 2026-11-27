/-
Copyright (c) 2026 ben. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: ben
-/
module

public import ConstructorTheory.IdenticalParticles
public import Mathlib.Logic.Equiv.Defs

/-!
# The third forbidden task

`docs/formalisation-gap/CLOSING_THE_GAP.md`, §6.3, names a third impossible task:

> **T3.** No physical process can distinguish a configuration of identical particles from a
> permutation of it.

`IdenticalParticles.lean` records only the two-particle case, and only by taking the substrate
to be `Sym2`. This file states T3 for `n` particles as a principle on a constructor theory.
A **presentation** sends each labelled configuration `Fin n → α` to a state of the substrate.
T3 says that telling the state of a configuration from the state of any relabelling is
impossible.

`thirdForbiddenTask_sym2` checks that the principle holds for the `Sym2` presentation in the
deterministic theory `functional`. It holds because `Sym2` identifies a pair with its swap
(`Sym2.eq_swap`), which is the symmetrisation postulate already in the repo, not a derivation
of T3. Tier T5 for `ThirdForbiddenTask`. Tier T2 for the sanity lemma, with that caveat.

Not imported from `ConstructorTheory.lean`; the steward batches index imports.
-/

@[expose] public section

namespace ConstructorTheory.Swarm

open ConstructorTheory.Theory

variable {α : Type}

/-- A labelled configuration of `n` particles drawn from `α`. Slot `i` carries `v i`. -/
abbrev Config (α : Type) (n : ℕ) := Fin n → α

/-- Relabel the slots of a configuration by a permutation of `Fin n`.

`(permute σ v) i = v (σ i)`. The values move with the slots; the multiset of values does not.
-/
def permute {n : ℕ} (σ : Equiv.Perm (Fin n)) (v : Config α n) : Config α n :=
  fun i => v (σ i)

/-- How a substrate `S` receives labelled configurations of `n` particles of species `α`.

This is the only map from labels to states. Identical particles are a presentation for which
T3 holds, not a separate kind of type.
-/
abbrev Presentation (S : Substrate) (α : Type) (n : ℕ) := Config α n → S

/-- The task "send the presented state of `v` to `o`, and the presented state of
`permute σ v` to `o'`". -/
def permutationDistinguishTask {S : Substrate} {n : ℕ}
    (present : Presentation S α n) (v : Config α n) (σ : Equiv.Perm (Fin n))
    (o o' : Attribute S) : Task S :=
  distinguishTask ({present v} : Attribute S) ({present (permute σ v)} : Attribute S) o o'

/-- **T3, the third forbidden task.**

On the substrate presented by `present`, no constructor of `Θ` distinguishes a configuration
of `n` particles from its image under any permutation of the slots. The outputs are an
arbitrary disjoint pair, so a perfect "which labelling is this" readout is a task of this shape.

A principle, not a theorem of the task algebra. `labelled_swap_possible` shows that the
labelled substrate `α × α` fails the two-particle case. Tier T5.
-/
def ThirdForbiddenTask (Θ : Theory) {S : Substrate} {n : ℕ}
    (present : Presentation S α n) : Prop :=
  ∀ (v : Config α n) (σ : Equiv.Perm (Fin n)) (o o' : Attribute S),
    Disjoint o o' → Θ.Impossible (permutationDistinguishTask present v σ o o')

/-! ## Sanity check: the `Sym2` substrate -/

/-- Two labelled particles, presented as an unordered pair. The slot names are forgotten. -/
def sym2Present (v : Config α 2) : Sym2 α := s(v 0, v 1)

private theorem fin2_eq_zero_or_one (i : Fin 2) : i = 0 ∨ i = 1 := by
  cases i using Fin.cases with
  | zero => exact Or.inl rfl
  | succ i =>
    cases i using Fin.cases with
    | zero => exact Or.inr rfl
    | succ i => exact i.elim0

private theorem fin2_one_ne_zero : (1 : Fin 2) ≠ 0 := by
  intro h
  exact Nat.one_ne_zero (congrArg Fin.val h)

/-- Every relabelling of two slots leaves the unordered pair unchanged.

This is `Sym2.eq_swap` for an arbitrary element of `Equiv.Perm (Fin 2)`, including the
identity. It is the symmetrisation postulate for `n = 2`, restated with `permute`.
-/
theorem sym2Present_permute (v : Config α 2) (σ : Equiv.Perm (Fin 2)) :
    sym2Present (permute σ v) = sym2Present v := by
  rcases fin2_eq_zero_or_one (σ 0) with h0 | h0
  · have h1 : σ 1 = 1 := by
      rcases fin2_eq_zero_or_one (σ 1) with h1 | h1
      · exact absurd (σ.injective (h1.trans h0.symm)) fin2_one_ne_zero
      · exact h1
    simp [sym2Present, permute, h0, h1]
  · have h1 : σ 1 = 0 := by
      rcases fin2_eq_zero_or_one (σ 1) with h1 | h1
      · exact h1
      · exact absurd (σ.injective (h0.trans h1.symm)) fin2_one_ne_zero.symm
    simp [sym2Present, permute, h0, h1, Sym2.eq_swap]

/-- **Sanity.** The `Sym2` presentation satisfies T3 in the deterministic theory.

The two input attributes are the same singleton (`sym2Present_permute`), so they overlap,
and `distinguish_impossible_of_overlap` applies. This is the same reason as
`identical_swap_impossible`. It does not derive T3: `Sym2` was defined so that a pair and
its swap are one state. Tier T2 about that postulate.
-/
theorem thirdForbiddenTask_sym2 :
    ThirdForbiddenTask (α := α) functional sym2Present := by
  intro v σ o o' hout
  unfold permutationDistinguishTask
  apply distinguish_impossible_of_overlap hout
  exact ⟨sym2Present v, rfl, (sym2Present_permute v σ).symm⟩

#print axioms sym2Present_permute
#print axioms thirdForbiddenTask_sym2

end ConstructorTheory.Swarm
