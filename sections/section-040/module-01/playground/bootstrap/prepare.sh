#!/usr/bin/env bash
# OS preparation for PLAYGROUND - Git Fundamentals
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

# --- packages the module uses -----------------------------------------------
for package in git; do
    dpkg -s "$package" >/dev/null 2>&1 || sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "$package"
done

as_learner git config --global user.name "Candidate"
as_learner git config --global user.email "candidate@example.com"
as_learner git config --global init.defaultBranch main

sudo mkdir -p /repositories
sudo git init --bare -b main /repositories/ship-log.git >/dev/null
sudo chown -R "$LEARNER:$LEARNER" /repositories
as_learner mkdir -p "$LEARNER_HOME/projects"

echo "[playground] ready. Try:  cd ~/projects && git init demo   git remote add origin /repositories/ship-log.git"
