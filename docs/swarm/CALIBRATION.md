# Calibration run, 26 Nov 2026 (1 agent, Grok Build)

Command, on Ben's workstation (ben-WRX80D8-2T: 128 cores, 61 GB RAM), from `swarm-pilot` e579228:
`AGENTS=1 HOURS=0.33 TOKEN_BUDGET=3000000 ROUND_FILE=swarm/grok/calibration.md swarm/grok/launch.sh start`.
The CLI was grok 1.0.92 (model `grok-4.7-build`), signed in to Ben's plan, with sandbox profile `ctlswarm`.
A preflight check showed that `~/.ssh` is denied, the network is blocked, and writes outside the worktree are blocked.

## Result
- The run started at 09:33:14 AEDT. The token budget stopped it at 09:50:28 AEDT, 17 min 14 s wall time.
- Output: `ConstructorTheory/Swarm/ThirdTask.lean` (T3 as `ThirdForbiddenTask` plus the `Sym2` sanity lemma).
  - The agent wrote it on turn 30 of round 2. It never built it, committed it or posted.
  - It compiled first time.
- The operator committed it, judged it and merged it into `swarm-run`:
  `JUDGE PASS: build ok, run_checks 46/46 OK, base 0c9adf2, head 3368640`. It is now PR #8 (opened against `next-steps`; retargeted to main after PR #6 merged).

| round | wall | turns | stop | total tokens | uncached in | cached in | out (reasoning) | cost (API $) |
|---|---|---|---|---|---|---|---|---|
| 1 | 7:32 | 30 | max turns | 1,752,700 | 74,470 | 1,651,584 | 26,646 | 1.13 |
| 2 | 9:42 | 30 | max turns | 1,519,758 | 71,949 | 1,412,864 | 34,945 (30,567) | 1.06 |
| **total** | 17:14 | 60 | budget | 3,272,458 | 146,419 | 3,064,448 | 61,591 | **2.19** |

Each round is about 30 model calls, made of about 75 tool calls.

The cost field matches the grok-4.7 API list prices ($2 per 1M uncached input, $0.50 per 1M cached, $6 per 1M output). The run drew on Ben's shared plan pool, and plan usage cannot be read from the shell, so the cost is an API-equivalent figure.

**Per agent-hour:** about 11.4M tokens, of which 10.7M cached, 0.51M uncached input and 214k output. That is about 209 model calls and **about $7.6 API-equivalent**.
- This is the top of the earlier $3.4–13.1 band.
- Output per hour is about 9× PyBot's DeepSeek agents, because this model is reasoning-heavy.
- 95% of input tokens were cache hits.

**Memory and judge:**
- The grok process peaked at 1.15 GB RSS.
- Available RAM never fell below 51.7 GB. No Lean process ran during the agent rounds.
- Judge on the workstation:
  - cold: 39 s wall
  - warm: 5.5 s wall, 3.0 GB peak RSS
  - building one module: 2 s, 0.95 GB

## Bugs found and fixed (PR #7)
1. **The judge passed new files without compiling them.** `lake build` builds only what `ConstructorTheory.lean` imports. The judge now also runs `lake build <Module>` for every added or changed `ConstructorTheory/**.lean`.
2. **The steward could never merge.**
   - `git branch -f swarm-run` fails because `swarm-run` is checked out in `repo/`.
   - The steward also skipped untracked or uncommitted work, because it checked the diff before committing leftovers.
   - It now commits leftovers first and merges inside `repo/`. A stub test confirmed this works.
3. **Agents ran out of turns before writing anything.**
   - In round 1 the agent spent all 30 turns reading Mathlib and Lake sources and wrote no notes. Round 2 repeated the same exploration.
   - `board-rules.md` now gives the turn budget, says to write code by turn 10 and update notes every 10 turns, and explains `ctl-build <Module>`.
   - `calibration.md` says the same.
4. These were found earlier in this run:
   - `-p` conflicts with `--prompt-file`. The fix also adds a 0-token failure guard.
   - bwrap failed on deny paths that don't exist.
   - The build lock now lives in its own directory.

## Concurrency recommendation (workstation)
- **RAM is not the limit.**
  - Each agent uses about 1.2 GB.
  - One Lean build at a time (under the lock) uses at most about 3 GB.
  - So 8 agents need about 13 GB of the 50 GB free.
- **The build lock is not the limit.** A warm judge takes about 5 s; a cold one takes about 40 s.
- **The limit is the plan pool, at about $7.6 API-equivalent per agent-hour.**
  - 3 agents × 2 h ≈ 68M tokens ≈ $46.
  - 4 × 8 h ≈ $245.
  - 8 × 24 h ≈ $1,460.
- **Next step, only with Ben's OK:**
  - 3 agents × 2 h, `TOKEN_BUDGET=70000000`, `MAX_TURNS=40`.
  - Before going higher, check the plan's `/usage` interactively before and after.
