#!/usr/bin/env bash
# UNTESTED DRAFT verifier. Harbor reads the reward from /logs/verifier/reward.txt.
# Reward 1 if the agent's clone of the mirror's main passes the judge at the end of its trial.
# The real quality signal is Ben's review of merged work; this reward only says main stayed green.
mkdir -p /logs/verifier
cd "${HOME}/ctl" 2>/dev/null || { echo 0 > /logs/verifier/reward.txt; exit 0; }
git fetch -q origin && git checkout -q origin/main
if swarm/judge.sh origin/main; then echo 1 > /logs/verifier/reward.txt; else echo 0 > /logs/verifier/reward.txt; fi
