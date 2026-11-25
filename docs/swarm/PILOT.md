# Swarm pilot: a small Lean-judged agent swarm

**Status: draft. Nothing is launched, bought or signed up for.** It needs Ben's OK on the
decisions in §8 first. Costs are in `COSTS.md`, the judge in `JUDGE.md`, the shared prompt in
`SYSTEM_PROMPT.md`, the lane prompts in `lanes/`, and an **untested** Legion spec and task in
`swarm/`.

## 1. Why

Hugging Face ran 1,000 DeepSeek agents for nine days on PyBot ("Scaling Swarms to Thousands of
Agents", 25 Nov 2026) and open-sourced the tools: **Legion** (https://github.com/huggingface/legion),
which launches and monitors agents, and **msgboard** (https://github.com/huggingface/msgboard),
a message board with channels, threads and shared docs. Their hardest problem was deciding what
"better" means; they needed a style guide and a hidden eval. We have a strict judge already:
Lean either accepts a proof or it does not, and `harness/run_checks.py` audits the axioms. That
makes this repo a better fit for a swarm than an open-ended task.

## 2. Goal

One open problem from `docs/formalisation-gap/CLOSING_THE_GAP.md` (§6, on branch `next-steps`, PR #6):
the two-forbidden-tasks model was **refuted as complete** by Maxwell–Boltzmann and Gibbs. The revised
model adds a third forbidden task after the failure, which costs it a point (8/10).

**The pilot tries to derive that third task instead of postulating it:**
- (T3) *Distinguishing a configuration of identical particles from its permutation is impossible*,
  i.e. the symmetrisation postulate, from constructor-theoretic principles (interoperability,
  superinformation, locality / no-signalling, and the composition of substrates).
- Stretch goal: the boson/fermion sign (±1 under exchange) from locality plus rotation, i.e. a
  constructor-theoretic route to spin–statistics. Known routes need relativistic QFT, or the
  topology of configuration space in 3 dimensions (Leinaas–Myrheim 1977; Berry–Robbins 1997).
  The agents must cite which route they follow.

## 3. Lanes (pilot sizes: smoke 3 agents, low 10, high 20)

| Lane | Channel | Smoke | Low | High | Owns |
|---|---|---|---|---|---|
| derive | `#derive` | 1 | 5 | 10 | Lean statements and proofs that T3 (and the sign) follow from stated CT principles. New file(s) under `ConstructorTheory/Swarm/`. |
| red-team | `#redteam` | 1 | 3 | 6 | Tries to refute the model and every derivation: counter-models (a substrate satisfying the principles where T3 fails), hidden assumptions, circularity (is symmetrisation smuggled in through the choice of substrate, as in `IdenticalParticles.lean`?). Writes refutations as Lean theorems where possible. |
| steward | `#steward` | 1 | 2 | 4 | Main green, the merge queue, duplicate PRs, the dead-end log (`docs/swarm/DEAD_ENDS.md`), the lane docs. No feature PRs. |

Teams of 2–4 inside a lane, one owner per team, as in PyBot.

## 4. How work reaches GitHub

Agents **never** get a GitHub token. Legion's `hf_repo` resource gives them a **private Hugging
Face dataset** that mirrors this repo, with native Hub PRs (it targets small teams and has no merge
queue). One agent approves another's PR, and the steward merges only when `swarm/judge.sh` passes.
At the end, Ben (or his assistant, with his OK) opens **one** GitHub PR from the mirror's main
to `swarm-results` on GitHub. This:
- keeps the public repo and Ben's GitHub token out of the agents' containers (the report describes
  an agent that port-scanned the controller and tried its own token as an admin token);
- avoids GitHub's secondary limits (80 content-creating requests a minute, 500 an hour, 100
  concurrent requests) and Actions minutes;
- keeps CI unchanged (the gh token on the box has no `workflow` scope anyway).

## 5. Rules (from PyBot, adapted)

- Every change goes through a PR. One approval from another agent; never self-approve.
- At most two open PRs per agent. Review before you build.
- A PR may merge only if `swarm/judge.sh origin/main` passes on its head **and** its description has
  the judge's `JUDGE PASS` line.
- The judge, `harness/run_checks.py`, the toolchain and the Mathlib pin are frozen (the judge rejects
  PRs that touch them).
- Post limit 1,200 characters, one thread per topic, no `@channel`-style mentions.
- Each claim carries a confidence tier, T1 (published proof) to T6 (hunch), as in `METHOD.md`.

## 6. Success criteria

Measured by Ben, not by the swarm:
1. **Win**: a merged Lean theorem deriving T3 from named principles that are *not* T3 in disguise,
   with no `sorry` and standard axioms only, which the red team failed to break within the run.
   The model's score goes back up (F/V not lowered by an after-the-fact principle).
2. **Useful partial**: a precise statement of which extra principle is needed (and a Lean proof that
   it is sufficient), or a Lean counter-model showing T3 is independent of the existing principles.
   A clean refutation counts as a result.
3. **Fail**: no merged theorem beyond restatements, or only vacuous/circular ones (the red team or
   Ben's review decides).
Health metrics (what Legion and the board show): merges per hour, judge pass rate, dead-ends logged,
tokens per agent-hour, cache hit rate.

## 7. Stop rules

- **Budget**: Legion `limits.budget_usd` (smoke 15, low 150) stops every loop at the cap minus the
  final reserve; the provider's **prepaid balance** is the second, independent hard stop.
- **Time**: `limits.run_timeout_seconds` (smoke 2 h, low 25 h).
- **Main red for 30 min** or **no merge for 4 h**: the steward pauses new feature work; the operator
  (Ben's assistant) stops the run if it does not recover within the next hour.
- **Any security incident** (an agent probing the network, reading secrets, pushing around the PR
  tools): stop at once (`legion stop <run> --delete --yes`), rotate the inference key, report to Ben.
- **Judge gaming** (e.g. a theorem that is true for trivial reasons, a definitions-only "derivation"):
  the red team flags it; the steward reverts it; repeated gaming stops the run.

## 8. What Ben must decide or provide

1. **Model provider**: DeepSeek API (cheapest by far, needs a DeepSeek account and a prepaid
   top-up) or the HF router (one HF account for everything, about 4–13× the price).
2. **Budget cap**: suggested $15 for the smoke test, then $150 for the low pilot.
3. **Where to run**: suggested controller on the box, agents in HF Sandboxes (needs an HF account
   with a positive credit balance), board on a free HF Space. The box alone cannot host the agents.
4. **Secrets**, created by Ben, stored only as environment secrets (never in the repo or chat):
   `DEEPSEEK_API_KEY` (or `HF_INFERENCE_TOKEN`, inference permission only), `HF_TOKEN` (Jobs,
   Spaces, buckets), `HF_REPO_TOKEN` (read/write on the private mirror dataset only),
   `MSGBOARD_OPERATOR_TOKEN`.
5. **Merge PR #6 first** (it has `IdenticalParticles.lean`, the refutation this pilot builds on).
6. **When**: a weekend start is all off-peak on DeepSeek (half price).

## 9. Risks

| Risk | Mitigation |
|---|---|
| Spend overrun | two independent caps (§7); smoke test first; prices pinned in the spec |
| Merge conflicts on shared files (`CATALOGUE.md`, `build_map.py`, `ConstructorTheory.lean`) | new work goes in `ConstructorTheory/Swarm/<Topic>.lean`; only stewards edit the shared index files, in one batched PR per hour |
| Main moving faster than agents can rebase (PyBot: only 11% of merge attempts succeeded until the server did the rebase) | small swarm; agents rebase only when approved and stale; steward queues merges one at a time |
| GitHub rate limits | agents never touch GitHub (§4) |
| Lean build time and memory on 2-vCPU sandboxes | Mathlib cache baked into the task image (`lake exe cache get` at build time); incremental build ≈40 s on 8 vCPU; use `cpu-upgrade` if the smoke test shows builds over 5 min |
| Vacuous or circular proofs that pass the judge | red-team lane, tier labels, Ben's review before anything reaches GitHub |
| Agents exploring infrastructure (report: port scan, token reuse) | no GitHub token, inference-only key, HF Sandboxes, stop rule in §7 |
| Idea basins (agents converge on one approach) | lanes and teams state their approach in the lane doc; two failed attempts → change approach and log a dead end |
| Legion is early-stage ("expect sharp edges", breaking changes) | pin commit `e04645b`; smoke test |
| Context compaction (23% of PyBot's output tokens) | short runs; notes file per agent |
