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
]


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
            "evidence": ["ConstructorTheory/FormalisationGap.lean", "harness/results.tsv"],
            "links": [{"to": "src.lean-repo", "rel": "cites"}],
            "where": ["ConstructorTheory/FormalisationGap.lean"], "created": TODAY, "updated": TODAY,
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
        {"id": "q.nocloning-hilbert", "kind": "question", "status": "open",
         "title": "Formalise quantum no-cloning in the task vocabulary",
         "statement": "Prove 'clone every state of a qubit' impossible in a Hilbert-space Theory model (Mathlib inner-product spaces).",
         "next": ["needs a Theory whose constructors are unitaries"], "created": TODAY, "updated": TODAY},
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
    knowledge = {
        "schema": 1,
        "meta": {"title": "The formalisation gap", "eyebrow": "constructor-theory-lean · labyrinth map",
                 "subtitle": "22 classical laws that break at the quantum level (dead ends), six patterns (conjectures), Lean results (T2)."},
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
            {"id": "open-nocloning", "group": "Open", "cls": "quantum no-cloning", "result": "not formalised",
             "status": "open", "kind": "partial", "refs": ["q.nocloning-hilbert"], "lit": [], "updated": TODAY},
        ],
    }
    (LAB / "knowledge.json").write_text(json.dumps(knowledge, indent=1, ensure_ascii=False) + "\n")
    (LAB / "sota.json").write_text(json.dumps(sota, indent=1, ensure_ascii=False) + "\n")
    counts = Counter(c for l in LAWS for c in l[5])
    print("laws", len(LAWS), dict(counts))


if __name__ == "__main__":
    probs = cross_check()
    if probs:
        print("CROSS-CHECK FAILED:", *probs, sep="\n  ")
        sys.exit(1)
    print("cross-check OK: table matches Lean catalogue")
    build()
