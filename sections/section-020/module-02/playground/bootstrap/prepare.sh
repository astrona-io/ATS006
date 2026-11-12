#!/usr/bin/env bash
# Match the account used by astrona ssh, including its home and permissions.
sudo -H -u student bash <<'ASTRONA_STUDENT_SCRIPT'
# OS preparation for PLAYGROUND - Default Permissions with umask
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

as_learner mkdir -p "$LEARNER_HOME/umask-practice"

echo "[playground] ready. Try:  umask   touch ~/umask-practice/a   ls -l ~/umask-practice"
ASTRONA_STUDENT_SCRIPT
