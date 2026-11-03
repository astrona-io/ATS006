#!/usr/bin/env bash
# OS preparation for PLAYGROUND - Reconciling with an Upstream Repository
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
sudo chown "$LEARNER:$LEARNER" /repositories
if [ ! -d /repositories/mission-plan.git ]; then
    as_learner bash -c '
set -e
git init -q --bare -b main /repositories/mission-plan.git
git clone -q /repositories/mission-plan.git "$HOME/.seed-mission-plan" 2>/dev/null
cd "$HOME/.seed-mission-plan"
echo "mission plan" > plan.txt
git add plan.txt && git commit -q -m "First plan"
git push -q origin main
cd .. && rm -rf .seed-mission-plan
'
fi

echo "[playground] ready. Try:  git clone /repositories/mission-plan.git ~/copy-one"
