# The formalisation gap — method: the ecdsa.fail setup applied to physics

## What ecdsa.fail is

Ben wrote "ecds.fail". `https://ecds.fail` does not resolve (HTTP 500 through a fetch
proxy, no connection from the box). The site meant is almost certainly
**[ecdsa.fail](https://ecdsa.fail)**, an Eigen Labs / Yukon Research project. It calls itself
"a benchmark arena for cracking ECDSA. Run your autoresearch harness, verify against the
benchmark, and submit your score". The open challenge repo is
[ecdsafail/ecdsafail-challenge](https://github.com/ecdsafail/ecdsafail-challenge).

Participants (mostly people running AI-agent "autoresearch" loops) all use the same setup:

1. **A frozen harness, the "contract".** `main.rs`, `circuit.rs`, `sim.rs` and the curve code
   can't be edited. Only `src/point_add/` can.
2. **One candidate.** A reversible quantum circuit for one secp256k1 point addition.
3. **Hard validity gates, checked before any score.** Classical correctness on 9024 test points
   (inputs come from a Fiat–Shamir hash of the circuit, so it can't be tuned to the test set);
   **reversibility** (every ancilla uncomputed to |0⟩); **phase cleanliness**; and
   **forward∘reverse = identity**. "There are no loopholes."
4. **One scalar score.** Average Toffoli count × peak qubits, lower is better, tracked as a
   Pareto frontier.
5. **An append-only log.** Each run adds a row to `results.tsv` with the commit,
   metrics, OK/FAIL, and a free-text note on what was tried.
6. **Shared memory notes.** `src/point_add/memory/*.md` record what worked and why. Because
   many agents contribute, notes are "leads: verify claims and re-run before relying on them".

## The translation (an analogy, labelled as such)

| ecdsa.fail | Here |
|---|---|
| Frozen harness / contract | Experimental record: black-body spectra, heat capacities, Stern–Gerlach, Bell tests, Casimir, droplet pinch-off. Not editable. |
| Candidate circuit | A classical law, written as an equation |
| Validity gates (correctness, reversibility, phase, identity) | Gates on each law: (a) the right numbers in the quantum regime? (b) finite where nature is finite? (c) consistent with information-theoretic constraints (no-cloning, no signalling, Bell)? (d) a correct classical limit for the replacement? |
| Fiat–Shamir test inputs | The regime is chosen by nature, not by the theorist. No per-case patching. |
| `results.tsv` row | One row per law in `CATALOGUE.md`: OK/FAIL, regime, replacement, a note naming the failed assumption |
| Score / Pareto frontier | Laws are ranked by how *few* assumptions explain *many* failures. The pattern search is a compression problem. |
| Memory notes = leads, re-verify | `PATTERN.md`. Each pattern is a claim checked against every row, and the counts are re-run in Lean (`continuum_most_common`). |

## The reversibility gate isn't a coincidence

ecdsa.fail's strictest gate is that a quantum computation must be **reversible and leave no
garbage**: uncompute every ancilla, leak no phase. That gate *is* a quantum law that classical
computing ignores. Landauer, unitarity and no-cloning mean you can't freely copy intermediate
values and discard them. So the harness Ben pointed at already encodes pattern **P4**
(distinguishability and copying are restricted).
