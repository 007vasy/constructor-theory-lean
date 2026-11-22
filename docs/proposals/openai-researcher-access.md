# Submission package: OpenAI Researcher Access Program (API credits)

> **NOT SUBMITTED.** Needs Ben's explicit OK. Prepared 22 Nov 2026 (Australia/Melbourne).

| | |
|---|---|
| Programme page | https://openai.com/form/researcher-access-program/ (overview: https://openai.com/science/researcher-access/) |
| Application | https://openai.smapply.org/prog/openai_researcher_access_program/ (SurveyMonkey Apply; **account required**; fields not visible without one) |
| Offer | Up to US$1,000 API credits, valid 12 months, public models only |
| Eligibility | Researchers affiliated with an academic institution, research organisation, or nonprofit that conducts research, in an API-supported country (Australia is). Encourages early-stage researchers with limited resources. |
| Priority areas | Responsible deployment, alignment, misuse, societal/economic impact, human–AI interaction, **generalisation to specialised fields**, multimodal. Science discovery is *not* a listed priority. |
| Deadline | Rolling; reviewed in **March, June, September, December**. Credits arrive 4–6 weeks after decision. Exact December cut-off not published; submit before end of November to aim for the December review. |
| Fit | 2/5 — small award, and the topic has to be framed as an AI-reliability question. |

## Framing

Pitch it under **"Generalization and transfer learning — how can we improve models' performance in
specialized fields?"** and **alignment/oversight**: *Can an independent model reliably detect when a
machine-checked formal statement does not say what the physics source claims?* The constructor-theory
library is the testbed.

## Draft answers (map to SM Apply fields once visible)

**Project title:** Auditing statement fidelity in AI-assisted formalisation of physics

**Research question:**
> When AI agents formalise physics in Lean, the proof checker guarantees the proof but not that the theorem means what the source says. We ask how well frontier models can act as adversarial reviewers of statement fidelity: given a published claim and a Lean statement, can the model find hypotheses that do the real work, definitions weaker than intended, or vacuous models — and how often does it raise false alarms?

**Method:**
> Testbed: an open Lean 4 library on constructor theory (~1,300 lines, 14 axiom-audited theorems, a 22-law catalogue with source mappings). We will (1) build a labelled set of faithful and deliberately perturbed statements (weakened hypotheses, swapped quantifiers, vacuous models); (2) measure detection and false-alarm rates of OpenAI models with and without the source passage; (3) use the best configuration to review new theorems in a Hilbert-space model (no-cloning, CHSH) and log every finding.

**Planned use of OpenAI products:** API calls to publicly available reasoning models for review and for proof-repair suggestions; Lean remains the only judge of proof correctness.

**Expected outputs:** open dataset of statement/perturbation pairs, evaluation script, results write-up, and the reviewed Lean modules (Apache-2.0).

**Credits requested:** US$1,000 (maximum).

**Researcher / affiliation:** [BEN TO FILL — this programme needs an academic, research-organisation or nonprofit affiliation. CTOR Labs may not qualify if it is a for-profit company. Do not overstate.]

## What Ben must decide or provide
1. OK to create a SurveyMonkey Apply account and submit.
2. An eligible affiliation (or accept the risk of rejection as an independent).
3. Public repo link; name, email.
