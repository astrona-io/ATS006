#!/usr/bin/env bash
# OS preparation for PLAYGROUND - Shell Scripting Basics
# Runs once when the environment comes up. It seeds a small practice scene.
# There is no task and no grading: poke at it freely.
set -euo pipefail

LEARNER=candidate
if ! id "$LEARNER" >/dev/null 2>&1; then
    sudo useradd -m -s /bin/bash "$LEARNER"
fi
LEARNER_HOME=$(getent passwd "$LEARNER" | cut -d: -f6)

as_learner() {
    sudo -u "$LEARNER" "$@"
}

as_learner mkdir -p "$LEARNER_HOME/inbox/archive" "$LEARNER_HOME/scripts"
as_learner bash -c 'seq 1 2 > "$HOME/inbox/alpha.txt"; seq 1 5 > "$HOME/inbox/bravo.txt"; seq 1 9 > "$HOME/inbox/charlie.txt"; echo "service started" > "$HOME/inbox/service.log"'

echo "[playground] ready. Try:  ls ~/inbox   wc -l ~/inbox/*.txt"
