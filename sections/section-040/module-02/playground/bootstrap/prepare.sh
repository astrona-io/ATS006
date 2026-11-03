#!/usr/bin/env bash
# OS preparation for PLAYGROUND - Branches, Clone and Merge
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
if [ ! -d /repositories/crew-manifest/.git ]; then
    as_learner bash -c '
set -e
git init -q -b main /repositories/crew-manifest
cd /repositories/crew-manifest
echo "crew manifest" > README.txt
git add README.txt && git commit -q -m "Start the manifest"
for name in alpha bravo charlie; do
    git checkout -q -b "feature-$name" main
    echo "$name team" > "$name.txt"
    git add "$name.txt" && git commit -q -m "Add the $name team"
done
git checkout -q main
'
fi

echo "[playground] ready. Try:  git clone /repositories/crew-manifest ~/crew-copy"
