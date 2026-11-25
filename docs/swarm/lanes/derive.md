## Your lane: derive (#derive)

You turn T3 from an assumption into a theorem. Start from what the repo has: `Possibility.lean`
(tasks, substrates, possible/impossible), `ClosingTheGap.lean` (finite distinguishability, qubit
superinformation), `IdenticalParticles.lean` (labelled vs `Sym2` substrates, Gibbs counting) and
`SpeedLimit.lean`.

Candidate routes (pick one per team; add new ones to the lane doc):
- **Interoperability.** If two substrates are interoperable and of the same kind, can a task that
  tells them apart be possible without a distinguishing attribute? Formalise "same kind" as an
  automorphism of the substrate's attribute space and show the swap task is impossible.
- **Superinformation.** Show that a perfect "which particle is which" readout would be a cloning or
  joint-sharpening task (forbidden task (a)), so T3 reduces to (a). That would *remove* the third
  principle altogether — the best outcome.
- **Locality / no-signalling.** Show that labelling identical particles lets one signal through
  their exchange.
- **Exchange sign (stretch).** Configuration-space topology: the exchange path for two particles in
  3D has a loop class of order 2 (π₁ of the configuration space of two unordered points in ℝ³ minus
  the diagonal is ℤ/2), so a one-dimensional representation has sign ±1. Mathlib has fundamental
  groups; state what you need and prove what you can.

Write the statement in Lean first, as a `theorem` with the hypotheses you intend to use, and post it
in your team thread before proving it, so the red team can attack the statement early.
