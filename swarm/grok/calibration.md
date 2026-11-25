
This is the calibration round. Do exactly one thing, then stop:
create `ConstructorTheory/Swarm/ThirdTask.lean` that states the third forbidden task (T3) as a
constructor-theoretic definition: for a substrate of n identical particles, the task "distinguish a
configuration from its image under a permutation" is impossible. Reuse the vocabulary of
`ConstructorTheory/Possibility.lean` and `ConstructorTheory/IdenticalParticles.lean`. Prove one small
sanity lemma (for example that the definition holds for the `Sym2` substrate already in the repo).
Do not edit `ConstructorTheory.lean`. Run `ctl-judge`, commit only on `JUDGE PASS`, post one line on
`derive.md`, and end with a 3-line summary.

How to work (the round ends without warning after the turn limit):
- By turn 8, write a first version of the file. Build just that file with
  `ctl-build ConstructorTheory.Swarm.ThirdTask` and fix errors; plain `ctl-build` does not build it,
  because nothing imports it.
- Keep the statement small; a definition plus a one-line lemma is enough. Write a line in your notes
  file after each build so the next round can pick up where you stopped.
