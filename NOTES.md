# Notes on milestone 1

These notes record what the formalization actually says, where it departs from
Deutsch (2013) and Deutsch & Marletto (2015), which claims are proved, and
which are hypotheses. They are the place to look before extending the project.
[`MAPPING.md`](MAPPING.md) lines each definition and theorem up against a
sentence from those papers.

## What is formalized

A **substrate** is a `Type`: its terms are states. An **attribute** is a
`Set` of states. A **task** is a set of pairs of attributes. Deutsch & Marletto
2015, §2, say an attribute “is the set of states in which the substrate has
that attribute”. Deutsch 2013, §1.1, still speaks of pairs of states.

Inside namespace `ConstructorTheory`:

- `Task.serial` (`A ⊚ B`) is relational composition. `(x, z)` is a pair when
  some intermediate attribute `y` satisfies `(x, y) ∈ A` and `(y, z) ∈ B`.
  `A ⊚ B` performs `A` and then `B`. In Deutsch & Marletto 2015, §2, that
  order is the composite written `BA`.
- `Task.parallel` (`A ⊗ B`) acts on the product type. Attributes are combined
  by the Cartesian product `x ×ˢ u`.
- `Task.transpose` (`Aᵀ`) swaps input and output, the papers’ `𝔄~`.
- `Task.IsSubtask` (`A ⊑ B`) is inclusion of pair-sets.
- `Task.union` is pointwise union of pair-sets, the least upper bound of the
  subtask order.
- `Task.hasDisjointInputs` and `Task.isFunctional` are properties of a task,
  not data. Neither source paper states that the input attributes of a task
  must be pairwise disjoint. `isFunctional` excludes the multiple-output
  example in Deutsch 2013, §1.1 (`{p → q, q → r, q → s}`).
- `Theory` is a constructor theory: for each substrate, a type of constructors
  and the set of attribute pairs each constructor can transform.
- `Theory.Possible` means some constructor’s pair-set contains the task.
  `Theory.Impossible` is the negation.

The name `Task` sits in this namespace because the Lean standard library
already defines `Task` for futures.

## Departures from the papers

**Accuracy is the exact limit.** A task is possible, in the papers, when some
constructor performs it to arbitrarily high accuracy and retains the ability
to do so again. There is no metric on states here and no family of
approximate constructors. `performs` is the limiting capability. Membership
is exact.

**Reusability is a reading, not a theorem.** A constructor is not itself a
substrate, and `Performs` does not mention a state of the constructor. Using
a constructor in a proof does not consume it, which matches the catalyst
picture at the level of the logic. The papers’ sharper statement — the
constructor’s own attribute is fixed by the transformation — is not
represented. Because constructors have no internal structure, the composite
of two constructors is not a defined object. The composition principles say
only that some constructor for the composite task exists.

**Not every Lean type is a physical substrate.** The theory quantifies over
all types so that the product substrate of a parallel task is the product
type. A countermodel that “has constructors only for `Fin 3`” is encoded by
`PLift (S = Fin 3)`. That is a coding device. A later version should take
the collection of substrates, and their product, as data of the theory.

**Empty attributes are degenerate.** `∅ ×ˢ u = ∅ ×ˢ v` even when `u ≠ v`, so
a product attribute does not determine its factors. The interchange law

```lean
(A₁ ⊗ A₂) ⊚ (B₁ ⊗ B₂) = (A₁ ⊚ B₁) ⊗ (A₂ ⊚ B₂)
```

is proved only when the output attributes of `A₁` and `A₂` are non-empty
(`Task.outputsNonempty`). One inclusion holds with no side condition. The
papers treat attributes as labels of a task and do not discuss this
degeneracy; it is an artefact of the set model. Restricting attributes to
non-empty sets would remove it.

**Disjoint inputs of a parallel task use classical logic.** If two product
attributes differ, one of the factors differs, but a constructive proof
cannot say which. `hasDisjointInputs.parallel` splits on equality of sets
with `by_cases`. The rest of the development is constructive apart from
lemmas inherited from Mathlib (in particular
`Set.prod_eq_prod_iff_of_nonempty`).

**Union of tasks is not automatically possible.** `A.union B` is the
least upper bound in the subtask order. Two possible tasks need not have a
possible union: a constructor for each task is not a constructor that
branches on which input it received. The papers obtain that combination from
distinguishability of the inputs. It is left to milestone 2.

## Hypotheses and theorems

There are no Lean `axiom` declarations.

These are **definitions**, not claims about physics: substrates, attributes,
tasks, subtasks, union, serial and parallel composition, transpose,
`hasDisjointInputs`, `isFunctional`, `Theory`, `Performs`, `Possible`,
`Impossible`.

These are **hypotheses** (`Prop`s on a `Theory`):

```lean
def Theory.SerialCompositionPrinciple (Θ : Theory) : Prop :=
  ∀ {S : Substrate} (A B : Task S),
    Θ.Possible A → Θ.Possible B → Θ.Possible (A ⊚ B)

def Theory.ParallelCompositionPrinciple (Θ : Theory) : Prop :=
  ∀ {S T : Substrate} (A : Task S) (B : Task T),
    Θ.Possible A → Θ.Possible B → Θ.Possible (A ⊗ B)
```

They are the composition principles of the theory, used as assumptions. They
are not theorems of the task algebra.

**Theorems about tasks** (no possibility):

- Subtask is a partial order: `IsSubtask.refl`, `IsSubtask.trans`,
  `IsSubtask.antisymm`.
- `A.union B` is the least upper bound: `IsSubtask.union_left`,
  `IsSubtask.union_right`, `IsSubtask.union_le`.
- `Task.serial_assoc`: `(A ⊚ B) ⊚ C = A ⊚ (B ⊚ C)`.
- Units: `Task.serial_idOn_left`, `Task.serial_idOn_right`, with
  `Task.idOn Set.univ`. The empty task is an absorbing element
  (`serial_empty_left`, `serial_empty_right`, and the parallel analogues).
- `Task.transpose_involutive`: `(Aᵀ)ᵀ = A`.
- `Task.transpose_serial`: `(A ⊚ B)ᵀ = Bᵀ ⊚ Aᵀ`.
- `Task.transpose_parallel`: `(A ⊗ B)ᵀ = Aᵀ ⊗ Bᵀ`.
- Serial composition preserves disjoint inputs and functionality.
  Parallel composition preserves disjoint inputs.
- `Task.serial_parallel_interchange` under `outputsNonempty`.
- `Task.exists_functional_of_transpose_not`: functionality is not stable
  under transpose. The task `{0}→{1}`, `{2}→{1}` on `Fin 3` is single-valued;
  its transpose sends `{1}` to both `{0}` and `{2}`.

**Theorems about possibility**, from the definition alone:

- `Theory.Possible.subtask`: a subtask of a possible task is possible. The
  same constructor performs fewer pairs.
- `Theory.Impossible.of_subtask`: a task with an impossible subtask is
  impossible. This is the pattern the papers use to propagate impossibility.
- `Theory.Possible.of_serial_subtasks`: if `A' ⊚ B'` is possible and `A`, `B`
  are subtasks of the factors, then `A ⊚ B` is possible. No composition
  principle is used.
- `Theory.Possible.empty_of_nonempty`: if any constructor on `S` exists, the
  empty task on `S` is possible.

**Theorems that assume a composition principle:**

- `Theory.Impossible.of_serial_left` and `of_serial_right`: if a serial
  composite is impossible and one factor is possible, the other factor is
  impossible.
- `Theory.Possible.serial_chain₃` and `serial_chain₃'`: a chain of three
  possible tasks is possible, in either parenthesization.
- `Theory.Possible.parallel_of_serial` and `serial_of_parallel`: under both
  principles, “compose on each factor, then place side by side” and “place
  side by side, then compose” are both possible.
- `Theory.Possible.schedules_agree`: if in addition the outputs of the first
  pair of tasks are non-empty, those two schedules are the same task.

**Models** in `ConstructorTheory/Models.lean` are consistency checks, not
physics.

- `omnipotent` performs every pair. Both principles hold, so they are jointly
  consistent (`composition_principles_consistent`).
- `inert` performs only the empty task. Both principles hold, and any task
  with a pair is impossible (`inert_possible_iff`, `inert_impossible_of_pair`).
  The principles do not force non-trivial tasks to be possible.
- `irreversible` performs `{0}→{1}` on `Fin 3` and not the transpose
  (`possible_transpose_not_necessary`). Possibility is not closed under
  transpose. The formalization does not assume reversibility.
- `serialBreak` performs `{0}→{1}` and `{1}→{2}` but not `{0}→{2}`. The serial
  principle fails (`serialBreak_not_serial`).
- `parallelBreak` performs tasks on `Fin 3` only. `Fin 3` is not
  `Fin 3 × Fin 3` (`fin3_ne_prod`), so the parallel of a possible task with
  itself is impossible (`parallelBreak_not_parallel`).

## What worked

The pair-set algebra is a good fit for Lean. Associativity of relational
composition, the transpose laws, and “a subtask of a possible task is
possible” are short and match the way the papers argue. Separating the
algebra (`Algebra.lean`) from possibility (`Possibility.lean`) made the
status of the composition principles obvious: they are extra assumptions,
and the countermodels show they are independent. Mathlib’s `Set` library
was the right dependency. The project does not need anything heavier from
Mathlib yet.

## What was awkward

- **Empty products.** The interchange law’s side condition is the one place
  the set model fights the informal theory. It is documented on
  `Task.outputsNonempty` and `Task.serial_parallel_interchange` rather than
  patched away.
- **Constructors have no body.** A natural attempt was to define possibility
  as “there exists a function `S → S` carrying each input attribute into the
  output attribute”. That collapses the theory: far too many tasks become
  possible for purely mathematical reasons, and there is nothing left for a
  physical law to say. Possibility had to stay abstract. The cost is that
  “compose the constructors” cannot be written as a program.
- **Accuracy.** “Arbitrarily high accuracy” is doing work in the papers
  (approximate machines, a limit). Replacing it by an exact pair-set is
  honest for milestone 1 and is not a theory of approximation.
- **Countermodels by type equality.** `PLift (S = Fin 3)` is ugly. It is
  confined to `Models.lean`.
- **Lean’s module system.** Mathlib 4.36 is a module library. Definitions
  that later files unfold are in an `@[expose] public section`, and `Task`
  needed an explicit `@[ext]` lemma because the usual structure extensionality
  lemma was not exported. This is bookkeeping, not a conceptual block.
- **The name `Task`.** The clash with Lean’s concurrency primitive forced
  the namespace. It is a nuisance at the import boundary and nothing more.

## Milestone 2 proposal

Formalize the start of constructor-theoretic **information**, following
Deutsch & Marletto (2015), §§2–4, and stop before the quantum
interoperability principle and the reconstruction of quantum theory.

Suggested deliverables, in order:

1. **Distinguishability.** Attributes `x` and `y` of a substrate are
   distinguishable when there is a substrate `M` (an information medium)
   with two disjoint attributes `0` and `1` such that the task
   `{x → 0, y → 1}` is possible. Record that disjointness of `x` and `y`
   is necessary, which is already provable from `hasDisjointInputs` once
   the task is possible and the constructor’s task has disjoint inputs.
2. **Information variable / information medium.** A finite family of
   pairwise disjoint, distinguishable attributes of one substrate, together
   with the hypothesis that every permutation of them is a possible task
   (they can be prepared and re-prepared). Do not yet require a cloning
   task. Cloning is not generally possible, and the papers treat copying
   as a further, non-trivial demand.
3. **Interoperability, as a hypothesis.** If two media carry attributes in
   bijection, a task on one is possible if and only if the transported task
   on the other is possible. State it as a `Prop` on a `Theory`, and give
   one model where it holds and one where it fails, in the style of
   `Models.lean`.
4. **Combination.** If `A` and `B` are possible, their input attributes are
   disjoint, and any two inputs drawn from different tasks are
   distinguishable, then `A.union B` is possible. This is the missing
   principle noted above. Prove the expected consequences: a possible task
   with disjoint inputs can be restricted to a subset of its branches
   (already true, by `Possible.subtask`) and extended by another possible
   branch when the inputs are distinguishable (new, from the hypothesis).
5. **Keep the discipline of milestone 1.** No `sorry`. New physical claims
   are `Prop`s. Algebraic facts are theorems. `NOTES.md` gains a section on
   what interoperability does not say.

Locality and no-signalling should wait for a milestone 3. The intended
statement, so the vocabulary is aimed the right way: a task on `S × T` is
signalling when an output attribute of one factor depends on the input
attribute of the other. No-signalling is the impossibility of every such
task. That is expressible with `parallel` once information attributes exist,
and it should not be started until combination and distinguishability are
in place. The link from constructor-theoretic information to quantum theory,
and any incompleteness-type limit, are further out than milestone 2.
