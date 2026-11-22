# Submission package: AI for Math Fund — Seed Grant (Renaissance Philanthropy / XTX Markets)

> **NOT SUBMITTED.** Needs Ben's explicit OK. Prepared 22 Nov 2026 (Australia/Melbourne).

| | |
|---|---|
| Programme page | https://www.renaissancephilanthropy.org/ai-for-math-fund |
| Seed-grant RFP | https://docs.google.com/document/d/1WOTctEoNMOypKb3XB01pldDPHo2wN2ZFhZhjkXwOCc0/edit |
| Application form | https://renphil.fillout.com/t/6ZKnnnAPd9us (Fillout webform, no account needed) |
| Offer | Up to US$100,000, up to 12 months |
| Eligibility | Individuals, teams, institutions, nonprofits, industry (for-profits need a public-benefit statement). Open globally except sanctioned jurisdictions. Form offers organisation type "Individual". |
| Deadline | Rolling. **Applications paused 15 Dec 2026 – 15 Jan 2027.** Submit by 14 Dec 2026 (US time) or wait until mid-January. Decision within 4 weeks. |
| Conditions | All code open-source; datasets open; preprints on arXiv; acknowledge the Fund. Submitted material is **not confidential**. |
| Fit | 5/5 — Lean formalisation + AI-assisted proof development is exactly the "Early-stage research or prototypes" theme. |

## Field-by-field answers

**Project Lead First / Last Name:** [BEN TO FILL]
**Project Lead Professional Title:** [e.g. Founder, CTOR Labs — BEN TO CONFIRM]
**Project Lead Email:** [BEN TO FILL]
**City / Country of Residence:** Melbourne / Australia [BEN TO CONFIRM]
**Organisation Type:** `Individual` *or* `Non-US for-profit` (if applying as CTOR Labs) — [BEN TO CHOOSE]
**Institution/Organisation Name / Org country:** [CTOR Labs or leave as individual]
**Have you received AI for Math Fund support before?** No
**Add additional team member:** No (no collaborators are claimed)

**Project Title:** Bridging classical and quantum physics with constructor theory: a machine-checked programme

**Categories (check all that apply):** Early-stage research or prototypes; Tools or infrastructure experiments

**In 3–5 sentences, summarise your project idea and the problem it addresses** (≤500 chars):
> An open Lean 4 library formalising constructor theory, which states physical laws as possible/impossible tasks, used to explain why 22 classical laws fail at the quantum level. Core vocabulary, a 22-law catalogue and 14 axiom-audited theorems exist. Next: a Hilbert-space model proving no-cloning and Bell violation, a candidate principle for energy quantisation, and the gravity-witness argument, with AI adversarial review of every statement.

**Key Objectives: 2–4 objectives** (≤1000 chars):
> 1. Build a finite-dimensional Hilbert-space model of constructor theory in Lean/Mathlib and prove that it has superinformation, hence no-cloning and a CHSH value above 2.
> 2. Formulate candidate constructor-theoretic principles for energy quantisation (the open gap behind 14 of our 22 catalogued laws) and test each in Lean with a model and a countermodel; publish negative results too.
> 3. State the Marletto–Vedral gravity-witness argument formally and prove its finite-dimensional core: a classical mediator cannot entangle two quantum systems by local operations.
> 4. Make AI adversarial review reproducible: an independent model tries to show each Lean statement does not match the cited physics claim; every finding is logged with the axiom audit.

**Implementation: plan and key milestones** (≤1000 chars):
> Existing base: Lean 4 + Mathlib library with CI; milestone 1 vocabulary (tasks, constructors, composition, countermodels); the "formalisation gap" catalogue; a verification harness adapted from Naskręcki's labyrinth-exploration that audits axioms and logs OK/FAIL rows.
> Months 0–3: qubit constructor model; superinformation and no-cloning theorems.
> Months 3–6: CHSH violation; gravity-witness statement and finite core.
> Months 6–10: energy-quantisation candidates, models, countermodels, per-law verdicts.
> Months 10–12: catalogue update, arXiv preprint, public release.
> Every theorem must build in CI and pass the axiom audit (no sorry, no added axioms). AI agents draft proofs; a second model reviews statements against sources.

**Team Fit** (≤500 chars):
> [BEN TO EDIT] Solo project lead ([NAME], [ROLE]) working AI-first: coding agents draft Lean and Lean checks every claim. In ~2 days the project produced ~1,300 lines of Lean, 14 axiom-audited theorems and CI, now public at [PUBLIC REPO LINK]. No collaborators or endorsements are claimed. [ADD BACKGROUND IN MATHS/PHYSICS/SOFTWARE.]

**For-profit public-benefit statement** (only if Org Type is for-profit; ≤300 chars):
> All code is Apache-2.0 and public; notes and preprints go on arXiv. The library is new research work, not a product, and creates a free formal reference for constructor theory and quantum foundations.

**Estimated project duration:** 6-12 months *(or 12 months)*

**Total Budget Requested:** [BEN TO SET — suggestion below]
Suggested split for a US$[40,000–60,000] request (illustrative only, Ben decides):
- **Personnel:** [project-lead time, e.g. X months part-time at $Y]
- **Other Direct Costs:** AI model/API credits for adversarial review and proof search [e.g. $10,000]; CI/compute [small]; external Lean/physics expert review hours [e.g. $5,000–10,000]
- **Travel:** [optional, e.g. one Lean/quantum-foundations workshop]
- **Equipment:** none
- **Indirect Costs:** none / [≤ what RFP allows]

**Optional supplementary materials:** upload `PROPOSAL.md` exported to PDF.

## What Ben must decide or provide
1. OK to submit (and to share the material, which the funder treats as non-confidential).
2. **Make the repo public** (the Fund requires open-source outputs; reviewers need to see it).
3. Name, title, email, organisation type (Individual vs CTOR Labs), budget figure.
