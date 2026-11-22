# Bridging classical and quantum physics with constructor theory: a machine-checked programme

> **Status: draft, not submitted.** Prepared 22 November 2026 (Australia/Melbourne). Nothing in
> this folder has been sent to any funder. Each submission needs Ben's explicit OK first.
> Placeholders in `[SQUARE BRACKETS]` are for Ben to fill in. No contact details are included on
> purpose.

**Project lead:** [PROJECT LEAD NAME], [ORGANISATION: CTOR Labs / independent — Ben to confirm], Melbourne, Australia
**Code:** [`007vasy/constructor-theory-lean`](https://github.com/007vasy/constructor-theory-lean) (Lean 4 + Mathlib, Apache-2.0). *Currently private; reviewers will need a public link or read access. Making it public is Ben's decision.*

## Abstract

Classical physical laws fail at the quantum level in a small number of recurring ways, and
constructor theory offers a language in which those failures can be stated as precise claims
about which physical tasks are possible and which are impossible. We have built an open Lean 4
library that formalises the core vocabulary of constructor theory (substrates, attributes,
tasks, constructors, possibility, serial and parallel composition) and a "formalisation gap"
catalogue of 22 classical laws that break down at the quantum level, sorted into six recurring
breakdown patterns. For 18 of the 22 we record an established q-number (operator) restatement,
and for 10 a constructor-theoretic restatement (7 published, 3 derived), with 8 open conjectures
and 4 laws that current constructor theory cannot yet express. Fourteen key theorems are
machine-checked and audited to use only Lean's standard axioms. We propose three next aims:
(a) a finite-dimensional Hilbert-space constructor model in Lean that proves quantum theory has
superinformation, hence no-cloning and Bell/CHSH violation; (b) a candidate
constructor-theoretic principle for energy quantisation, the largest open gap in the catalogue;
and (c) a formal statement of the Marletto–Vedral gravity-witness argument that underlies
tabletop tests of quantum gravity. We request model credits for adversarial review of proofs
and for automated proof search.

## 1. Problem

Every classical law in our catalogue gives wrong answers in some regime nature reaches: the
ultraviolet catastrophe, radiative collapse of atoms, heat capacities at low temperature,
Stern–Gerlach, Bell tests, droplet pinch-off. These failures are usually taught one at a time.
Our working hypothesis is that they share a small set of hidden assumptions about what a
physical state is: a point in a continuum, with every quantity jointly sharp, every state
distinguishable and copyable, and correlations set locally in advance. Constructor theory
(Deutsch 2013; Deutsch & Marletto 2015) states laws as possible and impossible tasks without
assuming a continuum, phase-space points or a Hilbert space. That makes it a candidate language
for saying exactly which assumption each classical law got wrong. The open problem is to do this
rigorously, not rhetorically, and to see where constructor theory itself runs out.

## 2. What exists today (verifiable in the repository)

- **Milestone 1, core vocabulary.** Lean definitions of substrate, attribute, task, constructor,
  `Possible` and `Impossible`; serial (`⊚`) and parallel (`⊗`) composition, transpose and
  subtasks, with associativity, units and the interchange law proved. "Possible tasks compose" is
  stated as two explicit hypotheses rather than axioms, and countermodels show neither follows
  from the definitions. A mapping table ties each definition to a sentence in the source papers.
- **The formalisation gap.** A catalogue of 22 classical laws that fail at the quantum level,
  tagged with six breakdown patterns: continuum (14 of 22), joint sharpness (9), local realism
  (1), distinguishability and copying (2), labelled identity (3), smooth at all scales (4). Tag
  counts are checked by `decide` in Lean.
- **Two restatements of every law.** q-number (Heisenberg-picture) forms: 18 established,
  3 partial, 1 speculative (Einstein's equations). Constructor-theoretic forms: 7 published,
  3 derived, 8 conjectures, 4 not expressible yet, with 19 checked source papers.
- **Lean results (toy models, no `sorry`, no added axioms).** Among them: a deterministic
  classical theory has no superinformation (`functional_no_superinformation`); a finite substrate
  cannot carry a continuum-valued information variable and misses every real interval
  (`no_continuum_info_variable_of_finite`, `finite_substrate_misses_interval`); in a deterministic
  theory overlapping attributes cannot be distinguished (`distinguish_impossible_of_overlap`);
  Pauli σx and σz do not commute and share no eigenvector (`pauliX_mul_pauliZ_ne`,
  `no_common_eigenvector`); in a toy thermodynamics, changing a conserved quantity is impossible
  and a task can be possible while its transpose is not (`conserved_change_impossible`,
  `irreversible_of`).
- **Verification harness.** Adapted from Bartosz Naskręcki's open-source
  `labyrinth-exploration` (MIT): fixed-format run notes, confidence tiers, a dead-end log, and a
  checker that audits the axioms of every cited theorem and logs OK/FAIL rows. All 14 audited
  theorems pass. CI builds the full Lean project on every change.

All of this is about 1,300 lines of Lean across seven modules, developed with AI coding agents
under the project lead's direction, with every claimed theorem checked by Lean rather than by
the agent.

**Honest scope.** These are toy and finite models. Nothing here proves quantum no-cloning,
Bell's theorem or Planck's law yet, and constructor theory has no published derivation of ħ.

## 3. Aims (12 months)

**Aim A — A Hilbert-space constructor model.** Build a finite-dimensional quantum model of the
milestone 1 vocabulary in Lean (qubits over Mathlib's matrices and inner-product spaces), with
constructors as unitary channels. Prove: (i) the computational and Hadamard bases are each
information variables whose union is not, so the model has superinformation; (ii) no-cloning as
the impossibility of copying that union; (iii) a CHSH value above 2 for a Bell state, as the
constructor-theoretic statement of locally inaccessible information. *Deliverable:* Lean module
and paper-style notes. *Success test:* builds in CI, passes the axiom audit, and moves catalogue
rows 1, 19, 20, 21 and 22 from "toy" to "proved in a quantum model".

**Aim B — Energy quantisation as a constructor-theoretic principle.** The continuum pattern
covers 14 of 22 laws, but constructor theory can only state those rows as conjectures. We will
formulate candidate principles (for example, that changing a mode's energy by less than a fixed
quantum is an impossible task) and test them in Lean against toy models: which catalogue rows
they recover (Planck, equipartition, Dulong–Petit, the third law) and which they break. *Success
test:* at least one candidate principle stated precisely, with a model where it holds, a
countermodel where it fails, and a documented verdict per catalogue row. A negative result is a
valid outcome and will be published as one.

**Aim C — The gravity witness, stated formally.** Marletto & Vedral (2017) and Bose et al.
(2017) argue that if gravity can entangle two masses through local interaction, the gravitational
field cannot be classical. This argument underlies proposed tabletop tests of quantum gravity
(BMV-type experiments). We will state it in the library's vocabulary and prove the finite-
dimensional core: a classical mediator, modelled as a substrate with no superinformation, cannot
create entanglement between two quantum substrates by local operations. *Success test:* a Lean
theorem whose hypotheses are listed against the published argument, making explicit which
assumptions any experiment must secure.

## 4. Why AI model access matters

The work is AI-first: agents draft Lean, Lean checks it. The weak point is not the checker but
the *statements*: a theorem can be correct and still not say what the physics says. We will
use models for (1) **adversarial review**, where an independent model tries to show that a Lean
statement does not match the published claim it cites, or that a hypothesis is doing the work;
(2) **proof search** for routine Mathlib lemmas; and (3) **literature cross-checks** against the
source papers. Every model output is either compiled by Lean or recorded as a reviewed note in
the dead-end log, so credit spend leaves an auditable trail.

## 5. Outputs and openness

- Open-source Lean library (Apache-2.0) with CI, axiom audit and mapping tables.
- Public notes per aim, including negative results.
- A preprint summarising the formalisation gap and Aims A–C [TARGET VENUE — Ben to choose].

## 6. Milestones

| Month | Milestone |
|---|---|
| 0–3 | Aim A: qubit model, superinformation and no-cloning proved |
| 3–6 | Aim A: CHSH; Aim C: gravity-witness statement and finite core |
| 6–10 | Aim B: candidate principles, models and countermodels |
| 10–12 | Catalogue update, preprint, public release |

## 7. Team

[PROJECT LEAD NAME], [ROLE], [ORGANISATION]. [ONE OR TWO SENTENCES ON BACKGROUND — Ben to write.]
No collaborators, endorsements or prior funding are claimed.

## References

- D. Deutsch, Constructor theory, *Synthese* 190, 4331–4359 (2013). arXiv:1210.7439.
- D. Deutsch & C. Marletto, Constructor theory of information, *Proc. R. Soc. A* 471, 20140540 (2015). arXiv:1405.5563.
- C. Marletto, Constructor theory of thermodynamics. arXiv:1608.02625.
- C. Marletto & V. Vedral, Gravitationally induced entanglement between two massive particles is sufficient evidence of quantum effects in gravity, *PRL* 119, 240402 (2017). arXiv:1707.06036.
- S. Bose et al., Spin entanglement witness for quantum gravity, *PRL* 119, 240401 (2017). arXiv:1707.06050.
- S. Gogioso et al., Constructor theory as process theory, EPTCS 397 (2023). arXiv:2401.05364.
- D. Deutsch & C. Marletto, Constructor theory of time, *J. Phys. Commun.* 10, 115003 (2026). arXiv:2505.08692.
- B. Naskręcki, labyrinth-exploration (MIT). https://github.com/nasqret/labyrinth-exploration

---

## Short variant — 250 words

Classical laws fail at the quantum level in a few recurring ways. We have built an open Lean 4
library that formalises the core of constructor theory, in which laws are statements about
which physical tasks are possible or impossible, and a catalogue of 22 classical laws that break
down at the quantum level, grouped into six breakdown patterns. Eighteen of the 22 have an
established operator (q-number) restatement; ten have a constructor-theoretic restatement (seven
published, three derived), eight remain conjectures and four cannot yet be expressed. Fourteen key
theorems are machine-checked and audited to use only Lean's standard axioms, including that a
deterministic classical theory has no superinformation and that a finite substrate cannot carry a
continuum-valued variable.

Over 12 months we will: (A) build a finite-dimensional Hilbert-space constructor model in Lean
and prove superinformation, no-cloning and a CHSH violation; (B) formulate and test candidate
constructor-theoretic principles for energy quantisation, the largest open gap, which affects 14
of the 22 laws; and (C) formally state the Marletto–Vedral gravity-witness argument that
underlies tabletop tests of quantum gravity, and prove its finite-dimensional core.

The work is AI-first: models draft Lean and Lean checks it. Model credits would fund adversarial
review, where an independent model tries to show a formal statement does not match the physics
claim it cites, plus proof search and literature cross-checks. All code is open source, with CI
and a public log of results, including negative ones.

## Short variant — 100 words

An open Lean 4 library formalising constructor theory, which states physical laws as possible
and impossible tasks, and using it to explain why 22 classical laws fail at the quantum level.
Six breakdown patterns, operator restatements for 18 laws, constructor-theoretic restatements for
10, and 14 machine-checked theorems exist today. Next: a Hilbert-space model proving
superinformation, no-cloning and Bell violation; a candidate principle for energy quantisation;
and a formal statement of the gravity-witness argument behind tabletop quantum-gravity tests.
Model credits would fund adversarial review of formal statements against the physics, and proof
search.
