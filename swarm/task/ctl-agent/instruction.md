<!-- UNTESTED DRAFT Harbor task. The real instructions come from docs/swarm/SYSTEM_PROMPT.md and the lane prompt. -->
Work on the constructor-theory-lean swarm project as described in your system prompt and lane prompt.
Clone the private mirror into `ctl` in your working directory with the hf_repo tools, link the
pre-built Mathlib packages (`ln -s /opt/mathlib-packages ctl/.lake/packages`), and run
`swarm/judge.sh origin/main` once to check your setup before starting.
