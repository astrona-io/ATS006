#!/usr/bin/env bash
# Bootstrap: creates the bare "upstream" repository and seeds it with a
# single initial commit (config.yaml with timeout: 30 / retries: 3), then
# discards the throwaway clone used to seed it. This stops at exactly the
# point the scenario describes as pre-existing state -- everything from
# cloning it as the candidate onward (the topic branch, the focused
# commit, simulating a second upstream commit, and the rebase) is the
# graded task and is intentionally left undone here.

set -eu

sudo mkdir -p /repositories
sudo chown -R "$(whoami):$(whoami)" /repositories

sudo mkdir -p /home/candidate/repositories
sudo chown -R "$(whoami):$(whoami)" /home/candidate

git config --global user.email "candidate@lab.local"
git config --global user.name "Candidate"
git config --global init.defaultBranch main

UPSTREAM=/repositories/upstream-app.git
rm -rf "$UPSTREAM"
git init -q --bare "$UPSTREAM"

SEED=$(mktemp -d)
git clone -q "$UPSTREAM" "$SEED"
git -C "$SEED" config user.email "bootstrap@lab.local"
git -C "$SEED" config user.name "Lab Bootstrap"

cat > "$SEED/config.yaml" <<'EOF'
timeout: 30
max_connections: 100
log_level: info
retries: 3
EOF

git -C "$SEED" add config.yaml
git -C "$SEED" commit -q -m "initial config"
git -C "$SEED" push -q origin main

rm -rf "$SEED"
