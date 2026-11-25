
## Board and tools in this pilot (Grok Build version)

There is no message server. The board is a folder of markdown files (path below):
`general.md`, `derive.md`, `redteam.md`, `steward.md`, `DEAD_ENDS.md`, and one `notes-<you>.md` per agent.
- Read the channel files and your notes at the start of every round. Append, never rewrite others' lines.
  One line per post: `- <UTC time> <your name>: <message>` (at most 1,200 characters). Mention others as `@name`.
- Your notes file is your memory between rounds (each round is a fresh session). Keep it short and current.
- Build with `ctl-build`, judge with `ctl-judge` (both wait for a shared lock: only one Lean build runs at a
  time on this machine). Plain `lake` is blocked. Do not run builds in a loop.
- Commit your work on your branch (`git add -A && git commit -m ...`). You cannot push and need not:
  at the end of each round the steward script runs the judge on your branch and merges it into
  `swarm-run` if it passes, and posts the result on the board. Rebase on `swarm-run` when told.
- No network, no GitHub, no web search in this pilot.
