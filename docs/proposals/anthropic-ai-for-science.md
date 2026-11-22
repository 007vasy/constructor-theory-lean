# Submission package: Anthropic AI for Science Program

> **NOT SUBMITTED.** Needs Ben's explicit OK. Prepared 22 Nov 2026 (Australia/Melbourne).

| | |
|---|---|
| Programme page | https://support.claude.com/en/articles/11199177-anthropic-s-ai-for-science-program |
| Rules | https://www.anthropic.com/ai-for-science-program-rules (updated 20 Oct 2026) |
| Application form | https://docs.google.com/forms/d/e/1FAIpQLSfwDGfVg2lHJ0cc0oF_ilEnjvr_r4_paYi7VLlr5cLNXASdvA/viewform |
| Offer | Help page: up to US$20,000 API credits for 6 months. The live form says credits are "extra usage credits" usable across Claude.ai tools, **max US$50,000**. The two pages disagree; treat $20k as safe. |
| Eligibility | "Researchers attached to research institutions", academic and nonprofit focus; physics and math are listed fields; priority on biology. Independent/for-profit applicants are not excluded by the rules but are weaker on "attached to a research institution". |
| Deadline | Rolling; reviewed on the **first Monday of each month** (next: Mon 7 Dec 2026, US time — submit by Fri 4 Dec Melbourne to be safe). No reply if unsuccessful. |
| Needs | A **Claude account Organization ID** (required field); PI approval email (Ben is the PI). |
| Fit | 3/5 — topic and the "adversarial review" use case fit well; affiliation is the weak point. |

## Field-by-field answers

**Which program?** Standard AI for Science program
**Name of primary contact:** [BEN TO FILL]
**Organization / institution:** [CTOR Labs / Independent researcher — BEN TO CHOOSE]
**Position or title:** [e.g. Founder and principal investigator]
**PI email:** [BEN TO FILL — PI is Ben]
**Website / Scholar / GitHub:** [PUBLIC REPO LINK — repo is private today]
**Where did you hear about this program?** Anthropic help centre
**Project title:** Bridging classical and quantum physics with constructor theory: a machine-checked programme
**Scientific fields:** Physics; Math
**Organization ID for credits:** [BEN TO CREATE/FIND — claude.ai > Settings]
**Claude.ai account type:** [Free / Pro / … — BEN]

**Research team (<100 words):**
> [BEN TO EDIT] [NAME], project lead, working AI-first: coding agents draft Lean 4 and Lean checks every claim. The existing library (~1,300 lines, CI, 14 axiom-audited theorems) formalises constructor theory's core vocabulary and catalogues 22 classical laws that fail at the quantum level, with operator and constructor-theoretic restatements. [ADD BACKGROUND.] No other team members or collaborators are claimed.

**Profiles of key team members:** [PUBLIC REPO LINK]; [BEN'S PROFILE LINK IF ANY]

**Research project (<500 words):** use the **250-word variant** in `PROPOSAL.md`, followed by this timeline paragraph:
> Six-month plan: months 1–2, a qubit constructor model in Lean/Mathlib with superinformation and no-cloning proved; months 3–4, CHSH violation and a formal statement of the Marletto–Vedral gravity-witness argument with its finite-dimensional core; months 5–6, candidate constructor-theoretic principles for energy quantisation tested against models and countermodels, plus a public write-up. Deliverables: open-source Lean modules, CI, axiom-audit logs, and a preprint.

**How Claude will be used (specific):**
> Three uses, each leaving an auditable artefact. (1) Adversarial statement review: for every Lean theorem, Claude independently reads the cited paper passage and the Lean statement and tries to show they differ — a hypothesis doing the real work, a definition weaker than the physics, or a vacuous model. This is the step Lean cannot check and the main risk in formalising physics. Findings are logged in the project's dead-end log. (2) Proof search and repair against Mathlib, with Lean as the only judge of correctness. (3) Literature cross-checks of the catalogue's 22 laws and 19 constructor-theory sources. Today the project uses a single model family to both write and check statements; a second, independent model removes that shared blind spot.

**Scientific impact (≤200 words):**
> Constructor theory claims to state physical laws without assuming continua, phase-space points or Hilbert spaces, but its results exist only as prose. A machine-checked library makes them testable. Concretely: a Lean proof that a finite-dimensional quantum model has superinformation, connecting Deutsch–Marletto's definitions to no-cloning and Bell violation; the first precise, tested candidates for an energy-quantisation principle, the gap behind 14 of the 22 classical breakdowns we catalogue; and a formal statement of the gravity-witness argument behind tabletop quantum-gravity proposals, making explicit which assumptions an experiment must secure. Negative results (a principle that fails) are equally publishable.

**Applications beyond pure discovery (≤200 words):**
> An open, reusable method for AI-assisted formalisation of physics: agents draft, Lean checks, an independent model red-teams the statements, and a harness audits axioms and logs every attempt. This transfers to other physics formalisation efforts. The library is also teaching material: each classical law sits next to the precise assumption that fails and the quantum replacement.

**Success metrics (≤100 words):**
> (1) Superinformation, no-cloning and CHSH>2 theorems build in CI with only standard axioms. (2) Gravity-witness core theorem with hypotheses mapped to the published argument. (3) ≥1 energy-quantisation principle with model, countermodel and per-law verdicts. (4) Number of statement–source mismatches found by Claude review and fixed. (5) Public preprint and release.

**Credits requested:** [BEN TO CONFIRM — suggest US$10,000]
> Suggested wording: "US$10,000 over six months: roughly two-thirds for adversarial statement review across ~50–100 theorems with long-context reading of source papers, one-third for proof search and repair loops."

**Biosecurity:** None of the above.
**Anything else:** "Code is open-source (Apache-2.0). The project is independent; no institutional affiliation or endorsement is claimed." [Adjust if Ben has an affiliation.]
**Terms:** Ben must tick "I agree" himself.

## What Ben must decide or provide
1. OK to submit; note Anthropic treats submissions as non-confidential.
2. A Claude account and its Organization ID (creating an account is Ben's call; no purchase needed).
3. Public repo link; name, title, email; credit figure; whether to apply as CTOR Labs or individual.
