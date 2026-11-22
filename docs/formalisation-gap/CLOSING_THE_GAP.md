# Closing the formalisation gap: hard-to-vary candidate models

> "And continue on the ideation on how to close the gap and have a mathematical model with a hard
> to vary explanation" (Ben, 22 Nov 2026)

Status labels follow `THESIS.md`: **[fact]** established physics or mathematics, **[Lean]**
proved in this repository, **[interpretation]** argued but not established, **[speculation]**
a guess. Tiers T1–T6 are the confidence tiers from `METHOD.md` (Bartosz Naskręcki's harness).
Lean file: [`ConstructorTheory/ClosingTheGap.lean`](../../ConstructorTheory/ClosingTheGap.lean).

## 0. The gap we are trying to close

From `PATTERN.md`, `QNUMBER.md` and `CT_RESTATEMENT.md`:

1. **No constructor-theoretic account of energy quantisation.** The continuum pattern P1 hits
   14 of 22 laws, and CT had only conjectures for those rows.
2. **Rates and coefficients** (tunnelling, Drude/Ohm, magnetism, QFT divergences) could not be
   stated as tasks.
3. **CT restatements lose the numbers.** Every row.
4. **No Hilbert-space model** in Lean, so superinformation (the CT core of quantum theory) was
   asserted, not proved.

## 1. An operational hard-to-vary test

### What Deutsch actually says (verified)

- A good explanation is "hard to vary, because all its details play a functional role"
  (D. Deutsch, *The Beginning of Infinity*, 2011, ch. 1 "The Reach of Explanations", on the
  axis-tilt theory of the seasons).
- Glossary of the same book: "Good/bad explanation: An explanation that is hard/easy to vary
  while still accounting for what it purports to account for."
- Why it matters: "whenever it is easy to vary an explanation without changing its
  predictions, one could just as easily vary it to make different predictions if they were
  needed" (ch. 1). And: "it is only when a theory is a good explanation - hard to vary - that it
  even matters whether it is testable" (ch. 1).
- **Reach**: the axis-tilt theory, built for seasons, also explains why seasons are out of phase
  between hemispheres; "You cannot confine its predictions to a region of your choosing" (ch. 1).
- TED, July 2009, "A new way to explain explanation": "A bad explanation is easy to vary" and
  "The search for hard-to-vary explanations is the origin of all progress"
  (<https://www.ted.com/talks/david_deutsch_a_new_way_to_explain_explanation>).

The chapter text was read from a third-party copy of ch. 1 and the official excerpt site
(thebeginningofinfinity.com). Page numbers were not checked; cite by chapter.

### The test (our operationalisation; Deutsch gives no numeric score)

Score a model out of 10. Write every step down; the score is only as good as the audit.

| Part | Question | Score |
|---|---|---|
| **F** free choices | How many adjustable constants, cut-offs, functional forms or per-law choices does the model need that its principle does not fix? | 3: at most one universal constant, fixed by one measurement. 2: a few universal choices. 1: per-law fitting. 0: unlimited. |
| **V** variation audit | List every component. For each, write the most natural variant and say which *observed* result or impossibility it breaks. | 3 × (fraction of components whose variant breaks something observed), rounded. A component whose variant breaks nothing is decoration: delete it or lose the point. |
| **R** reach | How many catalogue rows (or outside phenomena) does it explain that it was **not** built for? | 0 none, 1 some, 2 many or across patterns. |
| **K** risk | Can we name, today, an observation that would refute it? | 0 none, 1 vague, 2 concrete and feasible in principle. |

Two disqualifiers: a model that can absorb any outcome by retuning (e.g. "a cut-off Λ per law")
fails V outright; and a model whose components are redundant (one derivable from another) must
be reduced before scoring, because the redundant part can be varied freely.

**Calibration (the easy-to-vary baseline).** "Regularise each divergent law with its own
cut-off": F 0 (one cut-off per law), V 0 (any cut-off value fits), R 0, K 1. **1/10.** This is
the Persephone myth of the formalisation gap.

## 2. Candidate closing models

### C1. Finite distinguishability per unit action (FD)

**Statement [speculation, as a principle].** For any substrate with mean energy above its ground
state at most *E*, inside radius *R*, over time *t*:

- the number of perfectly distinguishable states it can pass through is at most about
  1 + 2Et/(πħ);
- the number of perfectly distinguishable attributes it can hold is finite, at most about
  exp(2πRE/(ħc)).

In CT form: *perfectly distinguishing more attributes than N(E, R, t) is an impossible task.*

**Where the numbers come from [fact].** The time bound is the Margolus–Levitin theorem: a
quantum system with mean energy *E* above the ground state needs time at least πħ/(2E) to reach
an orthogonal state (Margolus & Levitin, Physica D 120, 188 (1998), arXiv:quant-ph/9710043;
used by Lloyd as a limit on operations per second, Nature 406, 1047 (2000),
arXiv:quant-ph/9908043). The space bound is Bekenstein's entropy bound S ≤ 2πkRE/(ħc)
(Phys. Rev. D 23, 287 (1981)); its general validity has been debated. Both are *theorems or
conjectures inside* quantum theory and GR. The proposal is to promote them to a
dynamics-independent CT principle, in the way Marletto promotes energy conservation to
principle VIII.

**What it explains.** The continuum rows. A mode whose quantum ħω exceeds the energy on offer
cannot be driven into a distinguishably different state, so it freezes: Rayleigh–Jeans,
equipartition, Dulong–Petit, the third law. Atoms have a lowest distinguishable state (Larmor).
The photoelectric threshold. A finite droplet holds finitely many neck configurations
(Navier–Stokes, Kuypers). Discrete Stern–Gerlach outcomes. Reach beyond: black-hole entropy
(Bekenstein), limits of computation (Lloyd).

**What it does not explain.** Non-commutativity, no-cloning, Bell, identical particles. A
classical cellular automaton satisfies FD. FD alone does not give the exact Planck spectrum,
only finiteness and freeze-out; the spectrum needs the quantum ladder plus Boltzmann weights.
It does not give the value of ħ. It makes ħ functional: the action per distinguishable step.

**Variation audit.** Make the bound infinite: the ultraviolet catastrophe and atomic collapse
return (refuted). Give each substrate its own constant: then black-body, photoelectric and
atomic-spectra measurements of *h* need not agree, but they do (refuted). Change the scaling
from *Et* to anything else: needs a new constant with no role (decoration). The prefactor π/2
is fixed by quantum theory, not by FD itself (a soft spot).

**Score.** F 3, V 2, R 1, K 2: **8/10.** **Refuted by:** any bounded-energy system shown to
distinguish more states, or switch faster, than the bound. **Tier:** T5 (principle); its
inputs are T1. **Open:** derive it from C2 plus "energy generates time translation" (then it is
a theorem, not a second principle).

### C2. Superinformation + interoperability generate the q-number algebra

**Statement [interpretation].** Deutsch–Marletto superinformation (two information variables
whose union is not one; Proc. R. Soc. A 471, 20140540 (2015), arXiv:1405.5563) plus the axioms
of an operational reconstruction single out finite-dimensional complex Hilbert space: Hardy,
"Quantum theory from five reasonable axioms" (arXiv:quant-ph/0101012, 2001);
Chiribella, D'Ariano & Perinotti, "Informational derivation of quantum theory" (Phys. Rev. A 84,
012311 (2011), arXiv:1011.6451); Masanes & Müller, "A derivation of quantum theory from
physical requirements" (New J. Phys. 13, 063001 (2011), arXiv:1004.1483). The q-number forms in
`QNUMBER.md` then follow: canonical commutators, von Neumann evolution, spin operators, Tsirelson,
no-cloning, Ozawa-type measurement disturbance. Marletto & Vedral, "Universal quantum theory
from dynamical consistency" (arXiv:2608.17688, Aug 2026), argue the same universality
dynamically: requiring the canonical algebra to survive joint unitary dynamics rules out
specific hybrid classical–quantum models, including for linearised gravity.

**Variation audit.** The reconstructions are themselves variation audits. Hardy shows that
dropping continuity of reversible transformations leaves classical probability theory.
Drop local tomography and real-amplitude quantum theory is allowed. Renou et al. showed that
variant predicts different correlations in a network Bell scenario, so it can be experimentally
falsified (Nature 600, 625 (2021)); we have not checked the follow-up experiments here.
Allow stronger-than-quantum correlations and Tsirelson's bound fails (Bell tests respect it).

**Weak spot [fact].** Superinformation is necessary but not sufficient: Spekkens' toy theory
(Phys. Rev. A 75, 032110 (2007), arXiv:quant-ph/0401052) has no-cloning, non-commuting
measurements and no discrimination of non-orthogonal states, yet it is not quantum theory. So
the bridge "superinformation ⇒ the reconstruction axioms" is open.

**What it does not explain.** Energy levels, ħ and Hamiltonians (P1 numbers), identical-particle
statistics (spin-statistics needs relativistic QFT), rates.

**Score.** F 3, V 3, R 1, K 2: **9/10 inside its domain**, but its domain is the P2/P4/P3 rows
only. **Refuted by:** post-quantum correlations, higher-order (three-slit) interference, or a
perfect copier of non-orthogonal states. **Tier:** T4 (bridge from CT to reconstructions).

### C3. Quantitative possibility: possible to accuracy ε at cost at least f(ε)

**Statement [speculation].** Replace the yes/no `Possible` with a cost: the least resource
(time, energy, steps) needed to perform a task to accuracy ε. Laws become lower bounds.
Examples that already have this shape **[fact]**: Landauer (erasure costs at least kT ln 2 per
bit; IBM J. Res. Dev. 5, 183 (1961)); Masanes & Oppenheim's third law, where cooling towards
absolute zero needs time growing as an inverse power of the target temperature (Nat. Commun.
8, 14538 (2017), arXiv:1412.3828); Margolus–Levitin (time at least πħ/(2E) per orthogonal
step). A tunnelling rate would be the inverse of the least time for the task "move the particle
from left to right of the barrier"; a conductivity the least dissipation for "carry charge Q in
time t".

**Variation audit.** The cost function is chosen law by law unless it is derived from C1/C2, so
it is easy to vary as it stands.

**Score.** F 1, V 1, R 1, K 1: **4/10.** It is the *format* that gives the numbers back
(gap 3), not yet an explanation. **Tier:** T5.

### C4. Ben's thesis, made exact: classical law = quantum law + a possibility assumption

**Statement.** A classical law *rests on* a class X of tasks if it is derivable from "every task
in X is possible" and entails it. Then the law fails in a theory **exactly** when X contains a
task that theory forbids. **[Lean]** `law_fails_iff`.

**Variation audit.** The logic is T2 and cannot be varied. The content lies in choosing X for
each law, and as long as X is chosen freely per law this is easy to vary.

**Score.** F 1 (X free per law), V 1, R 1, K 2: **5/10** alone. It becomes hard to vary only
when X is drawn from a **fixed menu**, which is what the chosen model does.

## 3. The chosen model: two forbidden tasks

**Explanation (one paragraph).** Classical physics quietly assumes two kinds of task are always
possible. (a) **Copying or jointly sharpening arbitrary attributes**: take any two states and
clone them, or give position and momentum (or two spin components) sharp values at once.
(b) **Distinguishing unboundedly many attributes with bounded action**: a finite system with
finite energy and time can resolve a continuum of states, such as every possible mode energy,
every orbit radius or every neck radius of a droplet. Physics forbids both. (a) is forbidden
because information media are superinformation media (C2). (b) is forbidden because
distinguishing costs action in units of ħ (C1). Each classical law in the catalogue fails at
exactly the first task of (a) or (b) it relies on (C4). The single constant ħ is the price of
one distinguishable step. Nothing in the explanation can be retuned per law: change the menu,
the constant or the bound and an observed result breaks.

**Coverage of the 22 laws** (by the catalogue tags; the tagging is ours, T5):

| Forbidden task | Rows (repo catalogue order) | Count |
|---|---|---|
| (a) only | Liouville, Bell, measurement, copying, tunnelling | 5 |
| (b) only | Rayleigh–Jeans, equipartition, Dulong–Petit, photoelectric, Drude, Fourier, Navier–Stokes, third law, Einstein, QFT UV | 10 |
| both | Newton, Larmor, magnetism, Stern–Gerlach, vacuum | 5 |
| neither | **Maxwell–Boltzmann, Gibbs** (identical particles) | 2 |

So 20 of 22 rows are covered. The two uncovered rows are the **live refutation targets**.
Identical-particle statistics is not obviously a forbidden copy or a forbidden fine
distinction. If no reading in terms of (a) or (b) exists, the model needs a third principle, or
it is wrong in its claim to completeness. Einstein and QFT UV are covered only in the weak
sense that (b) predicts *some* finite cut-off **[speculation]**.

**Score.** F 3 (one constant, ħ; the menu is fixed), V 2 (drop (a): classical copying returns
and Bell violations should be impossible, which is refuted. Drop
(b): the UV catastrophe returns, refuted. But (b)'s precise form is borrowed from quantum
theory, and (b) may be derivable from (a) plus dynamics, a redundancy), R 2 (20/22 rows plus
Bekenstein, Lloyd and the droplet), K 2 (perfect copier, over-the-bound distinguisher, or a
reading of the identical-particle rows that uses neither). **9/10 by our rubric**, held at
**T5**: a conjecture with tests, not an established theory.

**What it still does not do.** It does not derive ħ's value, spin-statistics, or rates (C3 is
needed for those), and it does not show that (a) and (b) are independent.

## 4. What Lean proved

All in `ConstructorTheory/ClosingTheGap.lean`: no `sorry`, no new axioms. `harness/run_checks.py`
audits each theorem for Lean's three standard axioms only.

| Theorem | Candidate | Content |
|---|---|---|
| `law_fails_iff` | C4 | A law that rests on X fails in Θ iff some task of X is impossible in Θ. |
| `fd_no_continuum_readout` | C1 | Under FD, no read-out of an ℝ-indexed family of bounded-energy attributes is possible. |
| `functional_fd_iff_finite_shells` | C1 | In the deterministic theory, FD on S ⇔ every energy shell {E ≤ e} is finite. FD *is* discreteness there. |
| `continuum_violates_fd` | C1 | For **every** energy function E : ℝ → ℝ, the classical line violates FD (ℝ is uncountable, a countable union of finite shells is not). No choice of energy rescues the continuum. |
| `ladder_fd` | C1 | A ladder of quanta (level n has energy n·ħω) satisfies FD. |
| `no_cloning_overlap` | C2 | Any inner-product-preserving map that clones ψ and φ onto a normalised blank forces ⟨ψ, φ⟩ ∈ {0, 1}, in any finite dimension (Wootters–Zurek, Nature 299, 802 (1982); Dieks, Phys. Lett. A 92, 271 (1982)). |
| `qclone_impossible_of_overlap` | C2 | In any isometric two-qubit `Theory`, cloning two states with overlap outside {0, 1} is an impossible task. |
| `qubit_basis_clone_possible` | C2 | CNOT clones {\|0⟩, \|1⟩} onto \|0⟩. |
| `qubit_rotated_clone_possible` | C2 | (R⊗R)·CNOT·(Rᴴ⊗1) clones {(3,4)/5, (−4,3)/5} onto \|0⟩. |
| `qubit_nonorthogonal_clone_impossible` | C2 | {\|0⟩} and {(3\|0⟩+4\|1⟩)/5} are disjoint, yet cloning them is impossible (overlap 3/5). |
| `copying_law_breaks_in_qubit` | C4 + C2 | The classical copying law (`functional_every_variable_info`) breaks at exactly that pair. |
| `qubit_superinformation` | C2 | The isometric qubit theory **is a superinformation theory**: two information variables whose union is not one. Contrast `functional_no_superinformation`. Closes gap 4 in toy form. |
| `planckFactor_le_one`, `tendsto_planckFactor_atTop` | C1 numbers | x/(eˣ − 1) ≤ 1 (equipartition is the ceiling) and → 0 as x → ∞ (high modes freeze out): the UV catastrophe removed, with numbers. |

Simplifications, stated honestly: sharp states are singleton sets of vectors, not rays (global
phases are not quotiented). The superinformation definition keeps only the cloning clause of
Deutsch–Marletto (no permutation tasks). FD uses energy shells, not time or action, and the
Margolus–Levitin link is not formalised. The Planck mean-energy formula is defined, not
derived.

## 5. Next most valuable step

**Derive FD from quantum dynamics in Lean.** In a finite-dimensional Hilbert-space `Theory`,
prove the Mandelstam–Tamm / Margolus–Levitin bound (time to orthogonality is at least of order
ħ/ΔE), hence that a bounded-energy, bounded-time task distinguishes finitely many states. If it
goes through, (b) becomes a theorem of (a) plus "energy generates time translation". The chosen
model then rests on **one** principle, which is the most hard-to-vary outcome available. In
parallel: attack the two uncovered rows (Maxwell–Boltzmann, Gibbs) as a deliberate attempt to
refute the model.

## Sources (all opened on 22 Nov 2026)

- D. Deutsch, *The Beginning of Infinity* (2011), ch. 1 "The Reach of Explanations", and glossary.
- D. Deutsch, TED 2009, "A new way to explain explanation", <https://www.ted.com/talks/david_deutsch_a_new_way_to_explain_explanation>.
- D. Deutsch & C. Marletto, Proc. R. Soc. A 471, 20140540 (2015), arXiv:1405.5563.
- C. Marletto, *Constructor theory of thermodynamics*, arXiv:1608.02625.
- C. Marletto & V. Vedral, *Universal quantum theory from dynamical consistency*, arXiv:2608.17688 (2026).
- N. Margolus & L. B. Levitin, Physica D 120, 188 (1998), arXiv:quant-ph/9710043, doi:10.1016/S0167-2789(98)00054-2.
- S. Lloyd, Nature 406, 1047 (2000), arXiv:quant-ph/9908043, doi:10.1038/35023282.
- J. D. Bekenstein, Phys. Rev. D 23, 287 (1981), doi:10.1103/PhysRevD.23.287.
- L. Hardy, arXiv:quant-ph/0101012 (2001).
- G. Chiribella, G. M. D'Ariano & P. Perinotti, Phys. Rev. A 84, 012311 (2011), arXiv:1011.6451.
- Ll. Masanes & M. P. Müller, New J. Phys. 13, 063001 (2011), arXiv:1004.1483.
- M.-O. Renou et al., Nature 600, 625 (2021), doi:10.1038/s41586-021-04160-4.
- R. W. Spekkens, Phys. Rev. A 75, 032110 (2007), arXiv:quant-ph/0401052.
- R. Landauer, IBM J. Res. Dev. 5, 183 (1961), doi:10.1147/rd.53.0183.
- Ll. Masanes & J. Oppenheim, Nat. Commun. 8, 14538 (2017), arXiv:1412.3828.
- W. K. Wootters & W. H. Zurek, Nature 299, 802 (1982), doi:10.1038/299802a0.
- D. Dieks, Phys. Lett. A 92, 271 (1982), doi:10.1016/0375-9601(82)90084-6.
