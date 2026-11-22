# The formalisation gap: constructor-theory papers that restate laws

> "Ok research papers around re-stating laws in constructor theory and try to re-state the above
> one as well" (Ben)

This file lists the papers that turn an existing law into a constructor-theoretic statement, i.e.
a statement about which **tasks** are possible or impossible, and on which substrates. Every
paper was opened on arXiv, the journal or Zenodo on 22 Nov 2026. Journal references were checked
with doi.org/Crossref where given. The restatements of our 22 catalogue laws are in
[`CT_RESTATEMENT.md`](CT_RESTATEMENT.md).

## The common pattern

Each restatement works in the same way:

1. **Pick the substrate and the attributes.** Choose which physical system is being changed and
   which sets of its states are the input and output.
2. **Replace the dynamical law with a task statement.** "The equation predicts X" becomes "the
   task X is possible" or "the task Y is impossible". In the second case the law is a *law of
   impotence*.
3. **State a principle that is independent of dynamics.** It must constrain *all* dynamical laws,
   including ones not yet known (for example interoperability of information, or principle VIII
   on conserved quantities).
4. **Recover the old law as a corollary** inside a specific theory, usually quantum theory,
   sometimes classical. Quantitative content (numbers, rates, spectra) comes from that theory, not
   from the constructor-theoretic statement.

## Core papers

| Paper | Law(s) restated | How it restates them |
|---|---|---|
| D. Deutsch, *Constructor Theory*, [arXiv:1210.7439](https://arxiv.org/abs/1210.7439); Synthese 190, 4331–4359 (2013), [doi:10.1007/s11229-013-0279-z](https://doi.org/10.1007/s11229-013-0279-z) | Conservation laws, the second law, locality, "laws of motion" in general | Sets up the framework. Laws are statements about which tasks are possible, and dynamics is one way to describe them. States the principle of locality and the "principle of interoperability". |
| D. Deutsch & C. Marletto, *Constructor Theory of Information*, [arXiv:1405.5563](https://arxiv.org/abs/1405.5563); Proc. R. Soc. A 471, 20140540 (2015), [doi:10.1098/rspa.2014.0540](https://doi.org/10.1098/rspa.2014.0540) | No-cloning, complementarity (non-simultaneous sharp variables), measurement disturbance, entanglement | Information variables are defined by possible tasks (permutation and copying). *Superinformation media* are media with two information variables whose union is not one. From that one definition the abstract derives: no cloning, "pairs of variables that cannot simultaneously have sharp values", irreducible perturbation by measurement, and locally inaccessible information (entanglement). |
| C. Marletto, *Constructor Theory of Thermodynamics*, [arXiv:1608.02625](https://arxiv.org/abs/1608.02625) | First law (conservation of energy), second law (Kelvin form), work vs heat, adiabatic accessibility | Principle VIII: "The task of changing the U of any substrate is impossible." The second law becomes a law of impotence: some task is possible while its transpose is impossible *by adiabatic means*. Work and heat are distinguished through the information variable/non-information variable split. Uses the "is-like" relation A∼B ⇔ (Aᵀ⊗B)✓ ∧ (A⊗Bᵀ)✓. Holds at the micro scale, with no ensembles or coarse-graining. |
| C. Marletto, *Constructor Theory of Probability*, [arXiv:1507.03287](https://arxiv.org/abs/1507.03287); Proc. R. Soc. A 472, 20150883 (2016), [doi:10.1098/rspa.2015.0883](https://doi.org/10.1098/rspa.2015.0883) | The Born rule / probabilistic predictions | Restates "probabilistic" laws without fundamental probabilities. Proves that unpredictability of measurement outcomes necessarily arises in superinformation theories. Gives sufficient conditions, via a Deutsch–Wallace-type decision argument, for such a theory to support decisions as if it were probabilistic. |
| D. Deutsch, *The Logic of Experimental Tests, Particularly of Everettian Quantum Theory*, [arXiv:1508.02048](https://arxiv.org/abs/1508.02048) | Testability of probabilistic theories | Companion to the probability paper. Explains what it means for a deterministic theory to be tested by "probabilistic" data. |
| C. Marletto, *Constructor Theory of Life*, [arXiv:1407.0681](https://arxiv.org/abs/1407.0681); J. R. Soc. Interface 12, 20141226 (2015), [doi:10.1098/rsif.2014.1226](https://doi.org/10.1098/rsif.2014.1226) | Self-reproduction compatible with no-design laws | Shows that self-reproducers and replicators are *possible* under laws that contain no design, provided digital information is possible. This is the template for an "existence" (possibility) restatement. |
| C. Marletto & V. Vedral, *Gravitationally-induced entanglement between two massive particles is sufficient evidence of quantum effects in gravity*, [arXiv:1707.06036](https://arxiv.org/abs/1707.06036); PRL 119, 240402 (2017) | Classical gravity (Einstein equations with a c-number metric) | Restated as a witness. If a mediator can locally create entanglement between two quantum systems, the mediator cannot be classical (it has non-commuting variables). |
| C. Marletto & V. Vedral, *Why we need to quantise everything, including gravity*, [arXiv:1703.04325](https://arxiv.org/abs/1703.04325) | Hybrid classical–quantum dynamics | Argues that hybrid quantum–classical systems are inconsistent: either the quantum sector's properties spread to the classical sector or they are violated. The argument uses constraints on copying operations (the most general measurement interactions) instead of a particular dynamical model. It notes that earlier arguments required the classical sector to have all observables simultaneously sharp, or to obey Liouvillian dynamics. |
| C. Marletto & V. Vedral, *Witnessing non-classicality beyond quantum theory*, [arXiv:2003.07974](https://arxiv.org/abs/2003.07974); PRD 102, 086012 (2020), [doi:10.1103/PhysRevD.102.086012](https://doi.org/10.1103/PhysRevD.102.086012) | The same gravity witness, without assuming quantum theory | Defines non-classicality as "having two distinguishable variables that cannot be measured jointly" (superinformation). Proves the witness theorem in constructor-theoretic terms. |
| C. Marletto, V. Vedral, L. Knoll, F. Piacentini et al., *Emergence of Constructor-based Irreversibility in Quantum Systems*, [arXiv:2009.14649](https://arxiv.org/abs/2009.14649); PRL 128, 080401 (2022), [doi:10.1103/PhysRevLett.128.080401](https://doi.org/10.1103/PhysRevLett.128.080401) | Irreversibility (the "arrow" of the second law) under reversible unitary dynamics | Irreversibility as "a task is possible, while its inverse is not", with an experimental quantum homogeniser. |
| C. Marletto, *The information-theoretic foundation of thermodynamic work extraction*, [arXiv:2009.04588](https://arxiv.org/abs/2009.04588) | Work extraction (Szilard/Landauer type) | Deterministic work extraction requires the input states to be distinguishable, which follows from energy conservation plus the constructor theory of information. |
| M. Violaris & C. Marletto, *Irreversibility beyond Landauer's principle: is it possible to perform erasure using the quantum homogenizer?*, [arXiv:2205.11310](https://arxiv.org/abs/2205.11310); New J. Phys. 24, 113030 (2022), [doi:10.1088/1367-2630/ac9e13](https://doi.org/10.1088/1367-2630/ac9e13) | Landauer's principle / erasure | Irreversibility of erasure stated as possible/impossible tasks on a homogeniser. |
| S. Plesnik & M. Violaris, *Impossibility of universal work extraction from coherence*, [arXiv:2404.07786](https://arxiv.org/abs/2404.07786) | Work extraction from quantum coherence | A no-go stated as an impossible task: there is no universal work extractor from coherence. The paper shows this follows from a constructor-theoretic theorem based on distinguishability, and links it to constructor-based irreversibility. |
| D. Deutsch & C. Marletto, *Constructor theory of time*, [arXiv:2505.08692](https://arxiv.org/abs/2505.08692) (v3) | Dynamics and time itself | Time and duration defined through "timers" (constructors), so that dynamical laws can in principle be expressed as task statements. Does not yet re-derive specific equations of motion. |
| C. Marletto, D. Deutsch & V. Vedral, *Tests of constructor theory*, [arXiv:2606.07352](https://arxiv.org/abs/2606.07352) | — | Lists experimental tests of constructor-theoretic principles (2026). |
| C. Marletto & V. Vedral, *Universal quantum theory from dynamical consistency*, [arXiv:2608.17688](https://arxiv.org/abs/2608.17688) | Hilbert-space structure | Step towards deriving quantum structure from principles (2026). This is the ROADMAP item 3 bridge. |
| S. Gogioso, V. Wang-Maścianica, M. Waseem, C. Scandolo, B. Coecke, *Constructor Theory as Process Theory*, [arXiv:2401.05364](https://arxiv.org/abs/2401.05364); EPTCS 397, [doi:10.4204/EPTCS.397.9](https://doi.org/10.4204/EPTCS.397.9) | — (formal foundations) | Category-theoretic formalisation of tasks and constructors. Closest prior formal work to this Lean library. |
| IAOM, *The Boundary of the Possible: A Co-Heyting Semantics for Constructor Theory*, Zenodo [doi:10.5281/zenodo.23303926](https://doi.org/10.5281/zenodo.23303926) (11 Oct 2026) | — (logic of possibility) | Proposes a co-Heyting algebra semantics for possible/impossible. **Not peer reviewed.** |
| M. Violaris, *Counterfactuals in Macroscopic Quantum Physics* (thesis), [arXiv:2505.22834](https://arxiv.org/abs/2505.22834) | Measurement / Wigner's friend | Measurement and observers analysed with constructor-theoretic counterfactuals. |

## Minor or adjacent

- A. K. Pati & S. L. Braunstein, no-deleting/no-cloning conservation argument,
  [quant-ph/0303124](https://arxiv.org/abs/quant-ph/0303124). Not constructor theory, but the
  "impossible task" form of a quantum law.
- T. Fritz, [arXiv:1504.03661](https://arxiv.org/abs/1504.03661), a mathematical take on
  resource theories, which are close in spirit to tasks/constructors.
- R. Franco on cognition ([arXiv:1904.09829](https://arxiv.org/abs/1904.09829)) and emotions
  ([arXiv:2008.06052](https://arxiv.org/abs/2008.06052)); Malhotra on photoemission
  ([arXiv:2502.17458](https://arxiv.org/abs/2502.17458)). Peripheral; not used for any row's tag.

## What I looked for and did not find

- A separate **"constructor theory of conservation laws"** paper. Conservation is handled inside
  the thermodynamics paper (principle VIII) and in Deutsch 2013.
- A **constructor theory of measurement** paper by Di Biagio. I couldn't find one. Measurement is
  covered in Deutsch–Marletto 2015 and the Violaris thesis.
- Any constructor-theoretic derivation of **Planck's law, ħ, transport coefficients or
  Navier–Stokes**. None found. These rows are tagged accordingly in `CT_RESTATEMENT.md`.
