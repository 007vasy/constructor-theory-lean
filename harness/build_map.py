#!/usr/bin/env python3
"""Build the labyrinth map for "the formalisation gap" from one table.

Claim tested: the tag counts in this table equal the tag counts of the Lean `catalogue` in
ConstructorTheory/FormalisationGap.lean (which `continuum_most_common` proves by `decide`).
Two independent encodings of one classification, cross-checked, in the spirit of the
labyrinth-exploration loop ("independent cross-checks catch bugs").

Writes labyrinth/knowledge.json and labyrinth/sota.json. Never edit those by hand.
Usage: python3 harness/build_map.py
"""
import json
import re
import sys
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LAB = ROOT / "labyrinth"
LEAN = ROOT / "ConstructorTheory" / "FormalisationGap.lean"
TODAY = "2026-11-22"

# code -> (Lean constructor, title, statement)
PATTERNS = {
    "CONT": ("continuum", "P1 Continuum",
             "Energy and modes are infinitely divisible. Fails where hbar*omega >~ k_B T, or action ~ hbar."),
    "SHARP": ("jointSharpness", "P2 Joint sharpness",
              "Every observable has a sharp value at once (phase-space points). Fails because [q,p] = i*hbar."),
    "LOCAL": ("localRealism", "P3 Local realism",
              "Correlations come from local pre-set values. Fails because CHSH reaches 2*sqrt(2) > 2."),
    "DIST": ("universalDistinguishability", "P4 Universal distinguishability and copying",
             "Every state can be perfectly distinguished and copied. Fails: non-orthogonal states, no-cloning."),
    "LABEL": ("labelledIdentity", "P5 Labelled identity",
              "Identical particles carry labels. Fails: (anti)symmetrised states, Bose/Fermi statistics."),
    "SMOOTH": ("smoothAllScales", "P6 Smooth at all scales",
               "A differential (field) description holds down to arbitrarily small scales. Fails: divergences."),
}

# (slug, Lean name, regime, replacement, refuting evidence, tags)  -- order matches the Lean list
LAWS = [
    ("newton", "Newton/Hamilton trajectories", "action ~ hbar", "Schrodinger / Heisenberg", "double slit, atomic spectra", ["SHARP", "CONT"]),
    ("liouville", "Liouville phase-space density", "interference states", "von Neumann; Wigner can go negative", "uncertainty relation", ["SHARP"]),
    ("rayleigh-jeans", "Rayleigh-Jeans law", "h nu >~ k_B T", "Planck law", "black-body spectrum", ["CONT"]),
    ("equipartition", "Equipartition theorem", "hbar omega >> k_B T", "Bose-Einstein mode energy", "frozen-out degrees of freedom", ["CONT"]),
    ("dulong-petit", "Dulong-Petit law", "low T", "Einstein 1907, Debye T^3", "low-T heat capacities", ["CONT"]),
    ("larmor", "Larmor radiation / classical atom", "atoms", "Bohr, then Schrodinger bound states", "stable atoms", ["CONT", "SHARP"]),
    ("photoelectric", "Wien/Lenard photoelectric expectation", "light on metals", "E_max = h nu - phi", "photoelectric effect", ["CONT"]),
    ("maxwell-boltzmann", "Maxwell-Boltzmann statistics", "n lambda^3 >~ 1", "Fermi-Dirac, Bose-Einstein", "degenerate gases, BEC", ["LABEL"]),
    ("gibbs", "Gibbs entropy without 1/N!", "mixing identical gases", "symmetrised states", "Gibbs paradox", ["LABEL"]),
    ("drude", "Drude conductivity at low T", "metals", "Sommerfeld/Bloch, BCS", "electronic heat capacity, superconductivity", ["LABEL", "CONT"]),
    ("magnetism", "Curie law / Bohr-van Leeuwen", "every magnet", "quantised spin and orbital momentum", "Bohr-van Leeuwen theorem", ["CONT", "SHARP"]),
    ("spin", "Classical spin (Stern-Gerlach)", "inhomogeneous B field", "spin-1/2", "two discrete spots", ["CONT", "SHARP"]),
    ("vacuum", "Classical vacuum (no Casimir)", "plates ~ um apart", "zero-point energy", "Casimir force", ["CONT", "SHARP"]),
    ("fourier", "Fourier heat law at nanoscale", "below phonon mean free path", "phonon Boltzmann transport", "nanoscale thermal transport", ["SMOOTH", "CONT"]),
    ("navier-stokes", "Navier-Stokes at pinch-off/superfluid", "neck ~ nm; He-II", "molecular dynamics; quantised vortices", "droplet pinch-off, superfluidity", ["SMOOTH", "CONT"]),
    ("third-law", "Third law vs classical entropy", "T -> 0", "gapped discrete spectrum", "Nernst theorem", ["CONT"]),
    ("bell", "Bell local hidden variables", "space-like separated entangled pairs", "Tsirelson 2 sqrt 2", "loophole-free Bell tests", ["LOCAL", "SHARP"]),
    ("measurement", "Classical measurement (no disturbance)", "non-commuting observables", "measurement back-action", "uncertainty, disturbance relations", ["DIST", "SHARP"]),
    ("copying", "Universal copying of information", "unknown quantum states", "no-cloning; superinformation", "no-cloning theorem", ["DIST"]),
    ("tunnelling", "Classical tunnelling barrier", "thin barriers, light particles", "Gamow tunnelling", "alpha decay, STM", ["SHARP"]),
    ("einstein", "Einstein field equations at Planck scale", "singularities; l_P", "unknown (quantum gravity); BMV tests", "singularity theorems (internal)", ["SMOOTH", "CONT"]),
    ("qft-uv", "QFT without cutoff (UV divergences)", "short distances", "renormalisation; EFT", "divergent loop integrals (internal)", ["SMOOTH"]),
]

LEAN_THEOREMS = [
    ("th.catalogue-counts", "continuum_most_common", "Tag counts of the catalogue",
     "In our tagging: continuum 14, joint sharpness 9, smooth 4, labelled 3, distinguishability 2, local realism 1 (of 22)."),
    ("th.no-continuum-iv", "no_continuum_info_variable_of_finite", "No continuum information variable on a finite substrate",
     "A substrate with finitely many states has no family of non-empty pairwise-disjoint attributes indexed by R."),
    ("th.droplet", "finite_substrate_misses_interval", "Kuypers' droplet (toy)",
     "Any real-valued quantity on a finite substrate misses every open interval: a finite-atom neck cannot sweep a continuum of radii."),
    ("th.distinguish", "distinguish_impossible_of_overlap", "Overlapping attributes cannot be distinguished",
     "In the deterministic theory, sending x and y to disjoint outputs is impossible if x and y overlap."),
    ("th.distinguish-converse", "distinguish_possible_of_disjoint", "Disjoint attributes can be distinguished",
     "In the deterministic theory, disjoint x, y with inhabited outputs can be sent to disjoint outputs."),
    ("th.pauli-noncommute", "pauliX_mul_pauliZ_ne", "Spin components are q-numbers",
     "sigma_x sigma_z != sigma_z sigma_x over C (ConstructorTheory/QNumber.lean)."),
    ("th.no-joint-sharp", "no_common_eigenvector", "No state is sharp for both sigma_x and sigma_z",
     "No non-zero vector in C^2 is an eigenvector of both sigma_x and sigma_z (ConstructorTheory/QNumber.lean)."),
    ("th.classical-copying", "functional_every_variable_info", "Classical copying (CT)",
     "In the deterministic theory every variable is an information variable: its cloning task is possible (ConstructorTheory/CTRestatement.lean)."),
    ("th.no-superinformation", "functional_no_superinformation", "No superinformation in the deterministic theory",
     "The deterministic (classical) theory has no superinformation medium; no-cloning and complementarity need non-classical constructors (CTRestatement.lean)."),
    ("th.conservation-impossible", "conserved_change_impossible_both", "Changing a conserved quantity is impossible (toy principle VIII)",
     "In a toy thermodynamic theory whose constructors conserve U, x -> y and y -> x are both impossible when U differs (CTRestatement.lean)."),
    ("th.second-law-impotence", "monotone_decrease_impossible", "Decreasing the monotone is impossible (toy law of impotence)",
     "In the toy thermodynamic theory, x -> y is impossible when the entropy-like monotone is strictly lower on y (CTRestatement.lean)."),
    ("th.ct-irreversibility", "irreversible_of", "Constructor-based irreversibility (toy)",
     "A task can be possible while its transpose is impossible (CTRestatement.lean)."),
    ("th.ct-irreversibility-example", "thermo_irreversible_example", "Irreversibility is not vacuous (two-state example)",
     "On Bool, false -> true is possible and true -> false impossible in the toy thermodynamic theory (CTRestatement.lean)."),
    # Closing the gap (ConstructorTheory/ClosingTheGap.lean, docs/formalisation-gap/CLOSING_THE_GAP.md)
    ("th.breakdown-exact", "law_fails_iff", "Breakdown is exact (Ben's thesis, schema)",
     "A law that is derived from and entails 'every task in X is possible' fails in a theory iff some task of X is impossible there."),
    ("th.fd-no-continuum", "fd_no_continuum_readout", "FD forbids continuum read-outs",
     "Under finite distinguishability, no read-out of a continuum of bounded-energy attributes is possible."),
    ("th.fd-iff-discrete", "functional_fd_iff_finite_shells", "FD in a deterministic theory = finite energy shells",
     "The deterministic theory satisfies FD on S for E iff every shell {E <= e} is finite."),
    ("th.continuum-violates-fd", "continuum_violates_fd", "The classical continuum violates FD for every energy function",
     "For any E : R -> R, the deterministic theory on a line violates FD (a countable union of finite shells cannot cover R)."),
    ("th.ladder-fd", "ladder_fd", "A ladder of quanta satisfies FD",
     "Levels n with energy n (units of hbar*omega) have finite shells, so FD holds on the ladder."),
    ("th.no-cloning", "no_cloning_overlap", "No-cloning (Wootters-Zurek/Dieks), any dimension",
     "An inner-product-preserving map that clones psi and phi onto a normalised blank forces <psi,phi> in {0,1}."),
    ("th.qclone-impossible", "qclone_impossible_of_overlap", "Cloning non-orthogonal qubit states is an impossible task",
     "In any isometric two-qubit theory, cloning two states with overlap outside {0,1} is impossible."),
    ("th.qubit-basis-clone", "qubit_basis_clone_possible", "The computational basis is an information variable (CNOT)",
     "CNOT clones {|0>, |1>} onto |0>."),
    ("th.qubit-rotated-clone", "qubit_rotated_clone_possible", "The rotated basis {phi, phi_perp} is an information variable",
     "(R x R) CNOT (R^H x 1) clones {(3,4)/5, (-4,3)/5} onto |0>."),
    ("th.qubit-nonorth", "qubit_nonorthogonal_clone_impossible", "A variable that is not an information variable",
     "{|0>} and {(3|0>+4|1>)/5} are disjoint, yet cloning them is impossible (overlap 3/5)."),
    ("th.copying-law-breaks", "copying_law_breaks_in_qubit", "The classical copying law breaks exactly at a non-orthogonal pair",
     "In the isometric qubit theory a pair of distinct sharp states cannot be cloned, while the basis can."),
    ("th.qubit-superinformation", "qubit_superinformation", "The quantum qubit theory is a superinformation theory",
     "{|0>,|1>} and {phi,phi_perp} are information variables; their union is not (Deutsch-Marletto, cloning clause)."),
    ("th.planck-ceiling", "planckFactor_le_one", "Equipartition is the ceiling of the Planck factor",
     "x/(e^x - 1) <= 1 for x > 0: a quantised mode never holds more than k_B T on average."),
    ("th.planck-freeze", "tendsto_planckFactor_atTop", "High-frequency modes freeze out",
     "x/(e^x - 1) -> 0 as x -> infinity: the ultraviolet catastrophe is removed."),
]

# Lean file per theorem (default: FormalisationGap.lean)
LEAN_FILE = {
    "pauliX_mul_pauliZ_ne": "ConstructorTheory/QNumber.lean",
    "no_common_eigenvector": "ConstructorTheory/QNumber.lean",
    **{n: "ConstructorTheory/CTRestatement.lean" for n in (
        "functional_every_variable_info", "functional_no_superinformation",
        "conserved_change_impossible_both", "monotone_decrease_impossible", "irreversible_of",
        "thermo_irreversible_example")},
    **{n: "ConstructorTheory/ClosingTheGap.lean" for n in (
        "law_fails_iff", "fd_no_continuum_readout", "functional_fd_iff_finite_shells",
        "continuum_violates_fd", "ladder_fd", "no_cloning_overlap", "qclone_impossible_of_overlap",
        "qubit_basis_clone_possible", "qubit_rotated_clone_possible",
        "qubit_nonorthogonal_clone_impossible", "copying_law_breaks_in_qubit",
        "qubit_superinformation", "planckFactor_le_one", "tendsto_planckFactor_atTop")},
}

# Constructor-theoretic restatements (docs/formalisation-gap/CT_RESTATEMENT.md):
# slug -> (tag, short statement, source or reasoning)
CT = {
    "newton": ("Published", "Preparing position and momentum both sharp is impossible (superinformation)", "Deutsch-Marletto 2015, arXiv:1405.5563"),
    "liouville": ("Derived", "No phase-space-point attribute can be prepared or measured", "from row newton; hybrid argument Marletto-Vedral arXiv:1703.04325"),
    "tunnelling": ("Not expressible", "No CT task statement for finite-probability transmission", "CT_RESTATEMENT.md row 3"),
    "rayleigh-jeans": ("Conjecture", "Changing a mode's energy by less than hbar w is impossible", "principle VIII (Marletto arXiv:1608.02625) + quantised is-like classes (ours)"),
    "equipartition": ("Conjecture", "A mode with hbar w >> kT cannot be thermally excited by sub-quantum transfers", "as rayleigh-jeans"),
    "larmor": ("Conjecture", "Lowering a bound electron below its ground state is impossible", "principle VIII + lowest is-like class (ours)"),
    "photoelectric": ("Conjecture", "Ejecting an electron with h nu < phi is impossible at any intensity", "principle VIII + quantised exchange (ours)"),
    "vacuum": ("Derived", "Preparing a field mode with E and B both sharp is impossible", "D-M 2015 superinformation applied to field quadratures"),
    "dulong-petit": ("Conjecture", "As equipartition, for phonon modes", "as rayleigh-jeans"),
    "maxwell-boltzmann": ("Conjecture", "Distinguishing a configuration of identical particles from its swap is impossible", "ours; no CT derivation of BE/FD"),
    "gibbs": ("Conjecture", "No work can be extracted from mixing identical gases (identity task)", "Marletto arXiv:2009.04588 + identical particles (ours)"),
    "drude": ("Not expressible", "Conductivity is a coefficient, not a task", "CT_RESTATEMENT.md row 12"),
    "magnetism": ("Not expressible", "No CT restatement of magnetisation", "CT_RESTATEMENT.md row 13"),
    "third-law": ("Conjecture", "Cooling to the ground state in finitely many steps is impossible", "law of impotence in Marletto's style (ours)"),
    "fourier": ("Published", "Moving heat cold -> hot with no other change is impossible (second-law core)", "Marletto arXiv:1608.02625; PRL 128, 080401"),
    "navier-stokes": ("Derived", "A finite droplet has no continuum information variable", "Lean: no_continuum_info_variable_of_finite"),
    "einstein": ("Published", "If gravity can locally entangle two masses, it is non-classical", "Marletto-Vedral PRL 119, 240402; PRD 102, 086012"),
    "qft-uv": ("Not expressible", "No CT restatement of UV divergences", "CT_RESTATEMENT.md row 18"),
    "spin": ("Published", "Preparing S_x and S_z both sharp is impossible", "D-M 2015; Lean no_common_eigenvector"),
    "bell": ("Published", "Locally inaccessible information (entanglement) exists", "D-M 2015; Deutsch 2013 locality"),
    "measurement": ("Published", "Measuring without perturbing a complementary variable is impossible", "D-M 2015; Marletto 2016 probability"),
    "copying": ("Published", "Cloning a superinformation medium is impossible; single variables can be copied", "D-M 2015; Lean functional_no_superinformation (classical half)"),
}

# q-number restatements (docs/formalisation-gap/QNUMBER.md): slug -> (status, form, short statement)
QNUMBER = {
    "newton": ("Established", "FQ", "Heisenberg EoM with [x,p]=i hbar; Ehrenfest limit"),
    "liouville": ("Established", "FQ", "von Neumann equation; Moyal -> Poisson as hbar -> 0"),
    "tunnelling": ("Established", "FQ", "Schrodinger/Heisenberg with V(x); WKB transmission"),
    "rayleigh-jeans": ("Established", "FQ", "quantised EM field; Planck; RJ for n >> 1"),
    "equipartition": ("Established", "FQ", "(hbar w/2) coth(hbar w/2kT); kT limit"),
    "larmor": ("Established", "FQ", "QED bound states; Wigner-Weisskopf emission; correspondence"),
    "photoelectric": ("Established", "SC", "quantised electron in classical field suffices (Lamb-Scully)"),
    "vacuum": ("Established", "FQ", "vacuum fluctuations; Casimir pressure"),
    "dulong-petit": ("Established", "FQ", "phonons; Debye T^3; 3R at high T"),
    "maxwell-boltzmann": ("Established", "FQ", "grand-canonical density operator on Fock space; FD/BE"),
    "gibbs": ("Established", "FQ", "von Neumann entropy on symmetrised space"),
    "drude": ("Established", "FQ", "Kubo formula; Landauer; Bloch-Boltzmann limit"),
    "magnetism": ("Established", "FQ", "spin operators; Brillouin; Curie law"),
    "third-law": ("Established", "FQ", "discrete gapped spectrum; S -> k ln g0"),
    "fourier": ("Partial", "SC", "Green-Kubo exact, phonon Boltzmann SC; local law not derived"),
    "navier-stokes": ("Partial", "SC", "operator conservation laws exact; NS closure not derived; GP mean-field"),
    "einstein": ("Speculative", "SC", "semiclassical G = 8 pi G <T> vs quantised metric; BMV decides"),
    "qft-uv": ("Partial", "FQ", "renormalised EFT; UV completion unknown"),
    "spin": ("Established", "FQ", "spin operators, [Sx,Sy]=i hbar Sz; exact Ehrenfest precession"),
    "bell": ("Established", "FQ", "tensor-product observables; Tsirelson 2 sqrt 2"),
    "measurement": ("Established", "FQ", "von Neumann measurement unitary; Ozawa relation"),
    "copying": ("Established", "FQ", "unitarity forbids cloning non-orthogonal states"),
}


def lean_catalogue():
    """Parse the Lean `catalogue` list: name -> list of Lean constructor names."""
    src = LEAN.read_text()
    body = src.split("def catalogue", 1)[1].split("def tagCount", 1)[0]
    return [(n, [t.strip() for t in tags.split(",")])
            for n, tags in re.findall(r'\("([^"]+)",\s*\[([^\]]*)\]\)', body)]


def cross_check():
    lean = lean_catalogue()
    problems = []
    if len(lean) != len(LAWS):
        problems.append(f"length: Lean {len(lean)} vs table {len(LAWS)}")
    for (lname, ltags), law in zip(lean, LAWS):
        mine = [PATTERNS[c][0] for c in law[5]]
        if lname != law[1] or sorted(ltags) != sorted(mine):
            problems.append(f"mismatch: Lean {lname} {ltags} vs table {law[1]} {mine}")
    return problems


def node_law(law):
    slug, name, regime, repl, ev, tags = law
    return {
        "id": f"x.{slug}", "kind": "deadend", "status": "refuted",
        "title": name,
        "statement": f"Classical law, taken as exact. Fails in regime: {regime}. Replaced by: {repl}.",
        "lesson": "Failed assumption: " + ", ".join(PATTERNS[c][1] for c in tags) + ".",
        "evidence": [ev, "docs/formalisation-gap/CATALOGUE.md"],
        "links": [{"to": f"k.{c.lower()}", "rel": "supports"} for c in tags],
        "where": ["docs/formalisation-gap/CATALOGUE.md"],
        "created": TODAY, "updated": TODAY,
    }


def build():
    nodes = [node_law(l) for l in LAWS]
    for code, (_, title, stmt) in PATTERNS.items():
        n = sum(code in l[5] for l in LAWS)
        nodes.append({
            "id": f"k.{code.lower()}", "kind": "conjecture", "tier": "T5", "status": "open",
            "title": title, "statement": stmt,
            "test": f"Find a classical law that fails at the quantum level for a reason not covered by the six patterns; currently {n}/22 rows carry this tag.",
            "links": [{"to": "k.ben-thesis", "rel": "supports"}],
            "where": ["docs/formalisation-gap/PATTERN.md"], "created": TODAY, "updated": TODAY,
        })
    for nid, lean, title, stmt in LEAN_THEOREMS:
        nodes.append({
            "id": nid, "kind": "theorem", "tier": "T2", "status": "established",
            "title": title, "statement": stmt,
            "note": f"Lean: ConstructorTheory.{lean}. Kernel-checked by `lake build` in CI; harness/run_checks.py audits axioms. No human referee yet.",
            "review": {"state": "unreviewed"},
            "evidence": [LEAN_FILE.get(lean, "ConstructorTheory/FormalisationGap.lean"), "harness/results.tsv"],
            "links": [{"to": "src.lean-repo", "rel": "cites"}],
            "where": [LEAN_FILE.get(lean, "ConstructorTheory/FormalisationGap.lean")], "created": TODAY, "updated": TODAY,
        })
    nodes += [
        {"id": "k.ben-thesis", "kind": "conjecture", "tier": "T5", "status": "open",
         "title": "Ben's thesis: the breakdown shows the description is incorrect",
         "statement": "Classical laws are false-but-emergent approximations; the error lives in ontological assumptions encoded in the mathematics (continuum, joint sharpness, unlimited distinguishability), not in the calculus.",
         "test": "Exhibit a classical law whose quantum-level failure is NOT traceable to one of P1-P6 (would refute the 'single root cause' part).",
         "where": ["docs/formalisation-gap/THESIS.md"], "links": [{"to": "src.kuypers", "rel": "cites"}],
         "created": TODAY, "updated": TODAY},
        {"id": "h.quantum-also", "kind": "hunch", "tier": "T6", "status": "live",
         "title": "Quantum theory carries the same kind of assumptions",
         "statement": "Continuous Hilbert space, complex amplitudes and smooth spacetime are themselves encoded ontological assumptions; QFT/GR divergences are their failure signal.",
         "vivid": "Kuypers: as atomic theory fixed fluid divergences, a future theory may fix QFT's.",
         "links": [{"to": "src.kuypers", "rel": "cites"}, {"to": "x.qft-uv", "rel": "uses"}],
         "where": ["docs/formalisation-gap/THESIS.md"], "created": TODAY, "updated": TODAY},
        {"id": "q.nocloning-hilbert", "kind": "question", "status": "answered",
         "title": "Formalise quantum no-cloning in the task vocabulary",
         "statement": "Prove 'clone every state of a qubit' impossible in a Hilbert-space Theory model (Mathlib inner-product spaces).",
         "note": "Answered in ClosingTheGap.lean: isometric theory, no_cloning_overlap, qubit_superinformation.",
         "links": [{"to": "th.qubit-superinformation", "rel": "answers"}], "created": TODAY, "updated": TODAY},
        # Closing the gap: candidate principles (docs/formalisation-gap/CLOSING_THE_GAP.md)
        {"id": "k.c1-fd", "kind": "conjecture", "tier": "T5", "status": "open",
         "title": "C1 Finite distinguishability per action (FD)",
         "statement": "A substrate with energy <= E evolving for time t passes through at most ~2Et/(pi*hbar) perfectly distinguishable states (Margolus-Levitin) and, within radius R, holds at most ~2*pi*R*E/(hbar*c*ln2) bits (Bekenstein). Proposed as a constructor-theoretic principle, not a dynamical theorem.",
         "test": "Any substrate shown to perfectly distinguish more states than the bound allows refutes C1 (and quantum theory with it).",
         "links": [{"to": "th.fd-iff-discrete", "rel": "supports"}, {"to": "th.continuum-violates-fd", "rel": "supports"}],
         "where": ["docs/formalisation-gap/CLOSING_THE_GAP.md"], "created": TODAY, "updated": TODAY},
        {"id": "k.c2-si", "kind": "conjecture", "tier": "T4", "status": "open",
         "title": "C2 Superinformation + interoperability generate the q-number algebra",
         "statement": "Deutsch-Marletto superinformation plus the reconstruction axioms (Hardy; Chiribella-D'Ariano-Perinotti; Masanes-Mueller) single out complex Hilbert space, hence the q-number forms of the 18 'established' rows.",
         "test": "A consistent superinformation theory that is not quantum and also passes the reconstruction axioms would refute 'generate'.",
         "links": [{"to": "th.qubit-superinformation", "rel": "supports"}],
         "where": ["docs/formalisation-gap/CLOSING_THE_GAP.md"], "created": TODAY, "updated": TODAY},
        {"id": "k.c3-cost", "kind": "conjecture", "tier": "T5", "status": "open",
         "title": "C3 Quantitative possibility: possible to accuracy eps at cost >= f(eps)",
         "statement": "Attach resource costs to tasks (time, energy, steps) so that rates and coefficients become lower bounds on cost (third law: Masanes-Oppenheim).",
         "test": "A rate or coefficient (e.g. a tunnelling rate) that provably cannot be written as an optimal cost of any task refutes C3 for that row.",
         "where": ["docs/formalisation-gap/CLOSING_THE_GAP.md"], "created": TODAY, "updated": TODAY},
        {"id": "k.c4-schema", "kind": "conjecture", "tier": "T5", "status": "open",
         "title": "C4 Classical law = quantum law + possibility assumption X",
         "statement": "Every catalogue law rests on a class X of tasks that classical physics assumes possible; it fails exactly where X contains an impossible task.",
         "test": "A catalogue law with no such X, or one whose failure lies outside X, refutes C4.",
         "links": [{"to": "th.breakdown-exact", "rel": "supports"}, {"to": "th.copying-law-breaks", "rel": "instance-of"}],
         "where": ["docs/formalisation-gap/CLOSING_THE_GAP.md"], "created": TODAY, "updated": TODAY},
        {"id": "k.chosen", "kind": "conjecture", "tier": "T5", "status": "open",
         "title": "Chosen model: C4 frame with C1 + C2 as the two forbidden-task principles",
         "statement": "Classical laws assume two classes of tasks possible: copying arbitrary states (forbidden by superinformation) and distinguishing unboundedly many states with bounded action (forbidden by FD). Breakdown happens exactly at those tasks.",
         "test": "Find a catalogue row whose breakdown needs neither a forbidden copy/sharpening nor a forbidden fine distinction. Live candidates: Maxwell-Boltzmann and Gibbs (identical particles), which carry neither tag.",
         "links": [{"to": "k.c1-fd", "rel": "uses"}, {"to": "k.c2-si", "rel": "uses"}, {"to": "k.c4-schema", "rel": "uses"}],
         "where": ["docs/formalisation-gap/CLOSING_THE_GAP.md"], "created": TODAY, "updated": TODAY},
        {"id": "q.fd-from-ml", "kind": "question", "status": "open",
         "title": "Derive FD from the Margolus-Levitin bound in Lean",
         "statement": "In a finite-dimensional Hilbert-space Theory, prove that orthogonalisation takes time >= pi*hbar/(2E), so a bounded-energy, bounded-time task distinguishes finitely many states.",
         "created": TODAY, "updated": TODAY},
        {"id": "q.bell", "kind": "question", "status": "open",
         "title": "CHSH <= 2 for local models, Tsirelson for quantum",
         "statement": "Formalise the classical CHSH bound (finite, decidable) and state the quantum violation.",
         "created": TODAY, "updated": TODAY},
        {"id": "q.planck", "kind": "question", "status": "open",
         "title": "Equipartition vs discrete modes",
         "statement": "Prove that a discrete mode spectrum gives a finite total mean energy where equipartition diverges (Rayleigh-Jeans vs Planck).",
         "created": TODAY, "updated": TODAY},
        {"id": "src.kuypers", "kind": "source", "status": "established",
         "title": "Kuypers, Seeing Isn't Believing (13 Jul 2025)",
         "statement": "https://samuelkuypers.substack.com/p/seeing-isnt-believing", "created": TODAY, "updated": TODAY},
        {"id": "src.lean-repo", "kind": "source", "status": "established",
         "title": "ConstructorTheory Lean library",
         "statement": "ConstructorTheory/*.lean in this repository", "created": TODAY, "updated": TODAY},
        {"id": "m.labyrinth", "kind": "method", "status": "established",
         "title": "Labyrinth exploration (Naskręcki)",
         "statement": "https://github.com/nasqret/labyrinth-exploration (MIT): tiers, map, events, referees, escalation.",
         "created": TODAY, "updated": TODAY},
    ]
    for law in LAWS:
        slug = law[0]
        status, form, stmt = QNUMBER[slug]
        base = {"id": f"qn.{slug}", "title": f"q-number form: {law[1]} [{status}, {form}]",
                "statement": stmt, "links": [{"to": f"x.{slug}", "rel": "modifies"}],
                "where": ["docs/formalisation-gap/QNUMBER.md"], "created": TODAY, "updated": TODAY}
        if status == "Established":
            base.update(kind="theorem", tier="T1", status="established")
        elif status == "Partial":
            base.update(kind="question", status="partial")
        else:
            base.update(kind="conjecture", tier="T5", status="open",
                        test="BMV: observe (or bound) gravitationally induced entanglement between two masses in superposition.")
        nodes.append(base)
    for law in LAWS:
        slug = law[0]
        tag, stmt, src = CT[slug]
        base = {"id": f"ct.{slug}", "title": f"CT form: {law[1]} [{tag}]",
                "statement": stmt + ". Quantitative content of the law is lost in the CT form.",
                "evidence": [src, "docs/formalisation-gap/CT_LITERATURE.md"],
                "links": [{"to": f"x.{slug}", "rel": "modifies"}, {"to": "k.ben-thesis", "rel": "supports"}],
                "where": ["docs/formalisation-gap/CT_RESTATEMENT.md"], "created": TODAY, "updated": TODAY}
        if tag == "Published":
            base.update(kind="theorem", tier="T1", status="established")
        elif tag == "Derived":
            base.update(kind="theorem", tier="T2", status="established", review={"state": "unreviewed"})
        elif tag == "Conjecture":
            base.update(kind="conjecture", tier="T5", status="open",
                        test="Derive the impossibility from CT principles alone (no Hilbert space), or exhibit a CT-compliant theory where the task is possible.")
        else:
            base.update(kind="question", status="open")
        nodes.append(base)
    knowledge = {
        "schema": 1,
        "meta": {"title": "The formalisation gap", "eyebrow": "constructor-theory-lean · labyrinth map",
                 "subtitle": "22 classical laws that break at the quantum level (dead ends), six patterns (conjectures), q-number and constructor-theoretic restatements, Lean results (T2)."},
        "nodes": nodes,
    }
    sota = {
        "about": "Best formal result per question in the formalisation gap, with history.",
        "groups": ["Formalised", "Open"],
        "entries": [
            {"id": nid, "group": "Formalised", "cls": title, "result": stmt,
             "status": "proved in Lean (kernel-checked; no human referee)", "kind": "proved",
             "refs": [nid], "lit": [], "updated": TODAY}
            for nid, _, title, stmt in LEAN_THEOREMS
        ] + [
            {"id": "open-fd-ml", "group": "Open", "cls": "FD from Margolus-Levitin", "result": "not formalised",
             "status": "open", "kind": "partial", "refs": ["q.fd-from-ml"], "lit": [], "updated": TODAY},
        ],
    }
    (LAB / "knowledge.json").write_text(json.dumps(knowledge, indent=1, ensure_ascii=False) + "\n")
    (LAB / "sota.json").write_text(json.dumps(sota, indent=1, ensure_ascii=False) + "\n")
    assert set(QNUMBER) == {l[0] for l in LAWS}, "every law needs a q-number row"
    assert set(CT) == {l[0] for l in LAWS}, "every law needs a CT row"
    print("CT tags", dict(Counter(v[0] for v in CT.values())))
    print("q-number status", dict(Counter(v[0] for v in QNUMBER.values())))
    counts = Counter(c for l in LAWS for c in l[5])
    print("laws", len(LAWS), dict(counts))


if __name__ == "__main__":
    probs = cross_check()
    if probs:
        print("CROSS-CHECK FAILED:", *probs, sep="\n  ")
        sys.exit(1)
    print("cross-check OK: table matches Lean catalogue")
    build()
