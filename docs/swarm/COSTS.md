# Swarm pilot: cost estimate (Grok Build)

Ben's choice (26 Nov 2026): **"Just use Grok build."** The pilot runs xAI's official `grok` CLI headless on
the box. Prices and plan facts below were checked on **26 Nov 2026 (AEDT)**. **Nothing was bought, no key
created, no sign-in done.**

## 1. Two ways to pay

| Route | How it bills | Source |
|---|---|---|
| **Signed in with Ben's X subscription** (`grok login`) | No per-session fee. Usage comes out of the plan's **shared AI usage pool**, which "covers Chat, Imagine, Voice, and Bot" in Grok and Cursor; Build is listed in every paid tier. Premium = 4× Plus, Super 15×, Ultra 50×. **Pool sizes are not published.** The allowance **refreshes weekly**; past it you either wait or buy top-ups (a spend: needs Ben's OK). | https://x.ai/pricing |
| **API key** (`XAI_API_KEY`) | Per token, outside the pool. The CLI uses the key only when no sign-in session exists. | ~/.grok/docs/user-guide/02-authentication.md (installed with the CLI); https://docs.x.ai/developers/pricing |

API prices per 1M tokens (prompt under 200k tokens; **at 200k+ every token in that request costs double**):

| Model | Input | Cached input | Output | Status |
|---|---|---|---|---|
| `grok-4.7` | $2.00 | $0.50 | $6.00 | current; what x.ai/build says Grok Build runs on |
| `grok-4.6` | $2.00 | $0.50 | $6.00 | the CLI's listed default before sign-in (`grok models`) |
| `grok-4.5` (= alias `grok-build-latest`) | $2.00 | $0.30 | $6.00 | |
| `grok-build-0.1` | ($1.00 / $0.20 / $2.00) | | | **end of life 19 Nov 2026, no longer served** (https://docs.x.ai/developers/release-notes); its page now redirects |

Sources: https://docs.x.ai/docs/models, https://docs.x.ai/developers/pricing. US-regional endpoint: +10%.

## 2. Token burn per agent-hour (estimate)

No Grok session has run, so this is borrowed. Hugging Face's PyBot swarm used about **24k output and
20M input tokens per agent-hour** (appendix §1). A Lean agent that waits on a serialised ≈30–45 s build
should burn less, so the range below is **5M–20M input tokens per agent-hour**, 90% of it cached.
The launch script starts a **fresh session each round** so prompts stay under 200k tokens (no doubling).

| Model (API) | 5M input/h | 20M input/h | if prompts pass 200k |
|---|---|---|---|
| grok-4.7 | $3.39 / agent-hour | $13.14 / agent-hour | ×2 |
| grok-4.5 | $2.49 / agent-hour | $9.54 / agent-hour | ×2 |

## 3. API-key scenarios (USD, tokens only; the box costs nothing extra)

| Scenario | Agent-hours | grok-4.7 | grok-4.5 |
|---|---|---|---|
| Smoke: 3 agents × 2 h | 6 | $20 – $79 | $15 – $57 |
| Box-realistic: 2 agents × 24 h | 48 | $163 – $631 | $120 – $458 |
| Low: 5 agents × 24 h (needs builds queued; more than the box should run) | 120 | $407 – $1,577 | $299 – $1,145 |

## 4. On the plan pool: free per session, but it drains Ben's Grok Bot budget

- **The same weekly pool powers Ben's Grok Bot agents (including this one), Grok chat and Cursor.**
  A swarm that runs for hours can empty it, and then his bots slow down or stop until the weekly refresh,
  unless he buys a top-up.
- The pool size is unpublished, so the swarm's share cannot be computed in advance. At API prices one
  agent-hour is worth roughly **$3–13**; a $30/month Premium plan is unlikely to absorb many of those
  per week. Treat any run longer than an hour as able to exhaust the week's pool.
- `grok usage` from the shell says it cannot show the plan's usage yet ("Run /usage inside grok
  instead"), and headless JSON often **omits cost on pool/OAuth sessions**. So the script caps
  **tokens** (which headless JSON always reports), not dollars.

**How it is capped** (`swarm/grok/launch.sh`, ceilings the script enforces whatever is passed):

| Cap | Default | Ceiling |
|---|---|---|
| Concurrent agents | 1 | 3 |
| Wall clock for the whole swarm | 20 min | 24 h |
| Agent turns per round (`--max-turns`) | 30 | 80 |
| Wall clock per round (`timeout`) | 20 min | 60 min |
| Total tokens for the whole swarm (`TOKEN_BUDGET`, checked after each round) | 3M | set by Ben |
| Kill switch | `launch.sh stop` | touches `STOP`, kills every process group |

**Calibrate first:** Ben reads `/usage` in an interactive `grok` session, the script runs one agent for
≤20 minutes, Ben reads `/usage` again. The difference, set against the tokens in `ledger.tsv`, tells us
what share of the weekly pool an agent-hour costs. Only then pick `TOKEN_BUDGET` for anything longer.

## Appendix (superseded 26 Nov 09:20 AEDT): Legion + DeepSeek / HF router estimate

Kept for comparison. Ben chose Grok Build instead ("Just use Grok build").

Prices were fetched on **26 Nov 2026 (AEDT)**. Re-read them before any launch. **Nothing has been
bought, no account was opened and no API key was created.** Every option below needs Ben's
explicit OK first (his rule: no subscription or spend without his OK).

### 1. What the Hugging Face report tells us about token use

Source: *Scaling Swarms to Thousands of Agents* (Patiño, Tunstall, Burtenshaw, von Werra,
Hugging Face, 25 Nov 2026), https://huggingface.co/spaces/HuggingFaceSwarms/scaling-swarms, and
the Legion repo https://github.com/huggingface/legion (commit e04645b, 25 Nov 2026).

| Figure | Value | Where |
|---|---|---|
| Output tokens, whole PyBot run (to 13 Nov 10:17 UTC) | 3.16 billion: 71% work, 23% context compaction, 6% board posts | report, "Where the output tokens went" chart data |
| Agent-hours over the same period | ≈134,000 (integrated from the chart's agent-count series) | report, merging chart data |
| **Output tokens per agent-hour** | **≈23,000** mean, ≈24,000 median (range 17k–90k; higher when a wave starts) | derived from the two rows above |
| Cost of 10 PyBot agents on DeepSeek-V4.1-Flash via HF Inference Providers | **about $60 an hour**, "nearly all of it tokens" | `legion/experiments/pybot/README.md` |
| Price used there | $0.30 input / $1.20 output / $0.30 cached per 1M tokens (router provider novita, 6 Nov) | `legion/experiments/pybot/spec.yaml` |
| **Input tokens per agent-hour (derived)** | **≈20 million**: ($6.00 − 0.024M × $1.20) ÷ $0.30 per M | derived from the two rows above |
| 1,000-agent run inference | self-hosted vLLM, one 8-GPU node was enough (a second was idle) | report, "Swarm control" |
| Sandboxes and workers | `cpu-basic`; a 1,000-agent run needed about 108 workers and 1,000 sandboxes | pybot README |

So each agent re-reads its own long context on every call: input dominates by about 800 to 1.
**The price that matters is the price of cached input.** A provider that discounts prompt-cache
hits is roughly 10× cheaper than one that bills every input token in full.

Assumptions used below (state them to Ben):
- 24k output and 20M input tokens per agent-hour, the same as PyBot. Lean agents will wait on
  `lake build` (≈40 s incremental on the box, longer on a 2-vCPU sandbox), which should *lower*
  tokens per hour, so this is conservative.
- DeepSeek prompt-cache hit rate of 90% in the base case and 80% in the pessimistic case.
  Agent loops append to a fixed prefix, so a high hit rate is expected but unmeasured here.
- DeepSeek peak hours are 01:00–04:00 and 06:00–10:00 UTC on weekdays (12:00–15:00 and
  17:00–21:00 AEDT). A week-long average is 21% peak, so the blended price is 0.604 × peak.
  **A weekend run is entirely off-peak (half price).**

### 2. Model prices (per 1M tokens, fetched 26 Nov 2026)

| Option | Input (cache miss) | Cached input | Output | Source |
|---|---|---|---|---|
| DeepSeek API `deepseek-flash` (= DeepSeek-V4.1-Flash-1017), peak | $0.30 | $0.006 | $1.20 | https://api-docs.deepseek.com/quick_start/pricing |
| same, off-peak | $0.15 | $0.003 | $0.60 | same |
| DeepSeek API `deepseek-v4-pro` (V4-Pro-0813), peak | $1.32 | $0.044 | $3.96 | same |
| HF router, DeepSeek-V4.1-Flash via deepinfra (cheapest full-price listing) | $0.098 | not listed | $0.294 | https://router.huggingface.co/v1/models |
| HF router, DeepSeek-V4.1-Flash via together / fireworks / parasail | $0.30 | not listed | $1.20 | same |
| HF router, Qwen3.8-27B via deepinfra (Legion's example model) | $0.15 | not listed | $1.875 | same |
| HF router, DeepSeek-V4-Pro via deepinfra | $1.30 | not listed | $2.60 | same |

Legion talks to the HF router or to any OpenAI-compatible URL (`inference.urls`), so the DeepSeek
API should work through `urls: [https://api.deepseek.com/v1]`. **That path is untested**: Legion's
docs only show the router, vLLM, SGLang, llama.cpp and Ollama.

### 3. Cost per agent-hour

| Option | $/agent-hour |
|---|---|
| A. DeepSeek API flash, 90% cache hits, blended peak/off-peak | **$0.45** |
| B. DeepSeek API flash, 80% cache hits, all peak (pessimistic) | $1.32 |
| C. DeepSeek API V4-Pro, 90% cache hits, blended | $2.13 |
| D. HF router flash via deepinfra (no cache discount) | $1.97 |
| E. HF router flash via together/fireworks (Legion's default price) | $6.03 |
| F. HF router Qwen3.8-27B via deepinfra | $3.04 |

### 4. Compute and hosting

| Piece | Option | Price | Note |
|---|---|---|---|
| Agent sandboxes (one per agent) | HF Sandboxes / Jobs `cpu-basic`: 2 vCPU, 16 GB RAM, 50 GB disk | $0.000167/min = **$0.01/h** | https://huggingface.co/api/jobs/hardware. Mathlib's cache is 7.3 GB, so it fits; builds are slow on 2 vCPU |
| | `cpu-upgrade`: 8 vCPU, 32 GB | $0.03/h | for the steward or a shared build box |
| Legion worker jobs | `cpu-basic`, about one per 10 agents | $0.01/h | pybot README |
| Controller | Ben's box (`compute: local`, agents in HF Sandboxes, as in Legion's mini-swarm) | $0 | |
| Message board | msgboard on a CPU Basic Space | free | https://huggingface.co/pricing |
| Run state | private HF storage bucket | small | |
| Ben's box alone | 8 vCPU, 15 GB RAM (10–12 GB already in use), no Docker | — | **cannot host 10–20 agent containers**; fine for the controller and the judge |

HF Jobs and Sandboxes are pay-as-you-go but need a **positive credit balance** on the HF account
(https://huggingface.co/docs/huggingface_hub/guides/jobs). Compute is a rounding error next to tokens:
about $3 for the low scenario and about $12 for the high one.

### 5. Scenarios (tokens + compute, USD)

| Scenario | Agent-hours | A. DeepSeek flash (base) | B. flash, pessimistic | C. V4-Pro | D. router deepinfra | E. router $0.30/$1.20 |
|---|---|---|---|---|---|---|
| Smoke test: 3 agents × 2 h | 6 | **$3** | $8 | $13 | $12 | $36 |
| **Low: 10 agents × 24 h** | 240 | **$111** | $322 | $515 | $476 | $1,451 |
| Mid: 15 agents × 36 h | 540 | **$248** | $723 | $1,159 | $1,070 | $3,264 |
| High: 20 agents × 48 h | 960 | **$440** | $1,285 | $2,059 | $1,901 | $5,801 |

### 6. Recommendation

1. **Smoke test first**: 3 agents (one per lane) for 2 hours on the DeepSeek API, with a $15 hard cap.
   It measures the real tokens per agent-hour, the cache hit rate and the build time. Re-cost after it.
2. Then the **low scenario** (10 agents × 24 h) on a weekend, which is all off-peak, with
   `limits.budget_usd: 150` in Legion **and** a DeepSeek prepaid balance of no more than the cap
   (a prepaid balance is a hard stop that does not depend on our code).
3. Use V4-Pro only for the derivation lane if the smoke test shows Flash cannot write Mathlib-grade
   Lean. A mixed run (3 Pro + 7 Flash, 24 h, blended) is about $230.
