#!/usr/bin/env python3
"""Verifier for the formalisation gap: one OK/FAIL row per formal claim.

Claim tested: every Lean theorem the map cites (harness/build_map.py, LEAN_THEOREMS) exists in
the built library and depends on no axioms beyond Lean's standard three (no sorryAx, nothing new).

This plays the role of the ecdsa.fail harness: a fixed evaluator that the candidate cannot
edit, and an append-only results.tsv (timestamp, commit, item, OK/FAIL, metrics, note). It then
logs one labyrinth event and rebuilds the map, following nasqret's labyrinth-exploration loop
("test, and log at once").

Usage (after `lake build`):  python3 harness/run_checks.py [--note "what I tried"] [--no-log]
"""
import argparse
import os
import re
import subprocess
import sys
import tempfile
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "harness"))
from build_map import LEAN_THEOREMS, cross_check  # noqa: E402

STANDARD = {"propext", "Classical.choice", "Quot.sound"}
RESULTS = ROOT / "harness" / "results.tsv"
HEADER = "timestamp\tcommit\titem\tstatus\taxioms\tnote\n"


def commit():
    sha = os.environ.get("GITHUB_SHA")
    if sha:
        return sha[:12]
    try:
        return subprocess.check_output(["git", "rev-parse", "--short=12", "HEAD"], cwd=ROOT,
                                       stderr=subprocess.DEVNULL, text=True).strip()
    except Exception:
        return "local"


def audit():
    src = "import ConstructorTheory\n" + "".join(
        f"#print axioms ConstructorTheory.{lean}\n" for _, lean, _, _ in LEAN_THEOREMS)
    with tempfile.NamedTemporaryFile("w", suffix=".lean", delete=False, dir=ROOT) as fh:
        fh.write(src)
        path = fh.name
    try:
        out = subprocess.run(["lake", "env", "lean", path], cwd=ROOT, capture_output=True, text=True)
    finally:
        os.unlink(path)
    text = out.stdout + out.stderr
    rows = []
    for nid, lean, _, _ in LEAN_THEOREMS:
        m = re.search(rf"'ConstructorTheory\.{re.escape(lean)}' (depends on axioms: \[([^\]]*)\]|does not depend on any axioms)", text)
        if not m:
            rows.append((nid, "FAIL", "-", "not found or did not elaborate"))
            continue
        axioms = {a.strip() for a in (m.group(2) or "").split(",") if a.strip()}
        ok = axioms <= STANDARD
        rows.append((nid, "OK" if ok else "FAIL", ",".join(sorted(axioms)) or "none",
                     "standard axioms only" if ok else "non-standard axioms: " + ",".join(sorted(axioms - STANDARD))))
    if out.returncode != 0:
        rows.append(("lean", "FAIL", "-", text.strip().splitlines()[-1][:200] if text.strip() else "lean failed"))
    return rows


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--note", default="")
    ap.add_argument("--no-log", action="store_true", help="print only; do not touch results.tsv or events")
    args = ap.parse_args()
    probs = cross_check()
    rows = [("table-vs-lean", "FAIL" if probs else "OK", "-", "; ".join(probs) or "Python table == Lean catalogue")]
    rows += audit()
    ts = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    c = commit()
    for r in rows:
        print("\t".join(r))
    failed = [r for r in rows if r[1] != "OK"]
    if not args.no_log:
        new = not RESULTS.exists()
        with open(RESULTS, "a") as fh:
            if new:
                fh.write(HEADER)
            for item, status, ax, note in rows:
                fh.write("\t".join([ts, c, item, status, ax, (note + (" | " + args.note if args.note else "")).replace("\t", " ")]) + "\n")
        summary = f"run_checks at {c}: {len(rows) - len(failed)}/{len(rows)} OK" + (f" ({args.note})" if args.note else "")
        subprocess.run([sys.executable, str(ROOT / "labyrinth" / "lab.py"), "event", "monitor", summary,
                        "--nodes", ",".join(nid for nid, *_ in LEAN_THEOREMS),
                        "--evidence", "harness/results.tsv"], check=True)
        subprocess.run([sys.executable, str(ROOT / "labyrinth" / "lab.py"), "build"], check=True)
    sys.exit(1 if failed else 0)


if __name__ == "__main__":
    main()
