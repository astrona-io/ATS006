#!/usr/bin/env bash
# OS preparation for PLAYGROUND - Command Aliases
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

as_learner mkdir -p "$LEARNER_HOME/scrap"
as_learner bash -c 'cd "$HOME/scrap" && touch one.tmp two.tmp three.tmp'

echo "[playground] ready. Try:  alias   alias ll='ls -l'   type ll"
