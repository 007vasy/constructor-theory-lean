# swarm/ — pilot tooling

- `judge.sh` — the fixed evaluator (tested; see `docs/swarm/JUDGE.md`).
- `grok/launch.sh` — **the pilot launcher on Grok Build** (`setup | start | status | stop`). Hard caps on
  agents (≤3), hours (≤24), turns per round (≤80), minutes per round (≤60) and total tokens; `stop` is the
  kill switch. Plumbing dry-run with a stub agent on 26 Nov 2026; **never run with a real `grok` session**.
- `grok/board-rules.md`, `grok/round.md`, `grok/calibration.md` — prompts the launcher adds each round.
- `legion/`, `task/` — **superseded** Legion/Harbor drafts (untested), kept for reference.

Nothing here may be started without Ben's explicit OK (`docs/swarm/PILOT.md` §8). Calibration run, once
Ben has signed in himself:

```bash
AGENTS=1 HOURS=0.33 MAX_TURNS=30 ROUND_MIN=20 TOKEN_BUDGET=3000000 \
  ROUND_FILE=swarm/grok/calibration.md swarm/grok/launch.sh start
swarm/grok/launch.sh status
swarm/grok/launch.sh stop      # kill switch, any time
```
