#!/usr/bin/env bash
# Bootstrap: builds the source "auto-verifier" repository at
# /repositories/auto-verifier with a main branch and three candidate
# branches (dev4, dev5, dev6), each setting a different
# user_registration_level in config.yaml. Only dev5 sets it to "open" --
# the value the student must locate before merging. This pre-stages the
# scenario only; the clone, inspection, merge, and logs/.keep commit are
# all left for the graded task.

set -eu

sudo mkdir -p /repositories
sudo chown -R "$(whoami):$(whoami)" /repositories

sudo mkdir -p /home/candidate/repositories
sudo chown -R "$(whoami):$(whoami)" /home/candidate

git config --global user.email "candidate@lab.local"
git config --global user.name "Candidate"
git config --global init.defaultBranch main

REPO=/repositories/auto-verifier
rm -rf "$REPO"
git init -q "$REPO"
git -C "$REPO" config user.email "bootstrap@lab.local"
git -C "$REPO" config user.name "Lab Bootstrap"

cat > "$REPO/README.md" <<'EOF'
# Auto-Verifier

Automated verification service configuration.
EOF

cat > "$REPO/config.yaml" <<'EOF'
service: auto-verifier
user_registration_level: closed
EOF

git -C "$REPO" add -A
git -C "$REPO" commit -q -m "initial commit"

git -C "$REPO" checkout -q -b dev4
sed -i 's/user_registration_level: closed/user_registration_level: invite_only/' "$REPO/config.yaml"
git -C "$REPO" commit -q -am "dev4: invite-only registration"

git -C "$REPO" checkout -q main
git -C "$REPO" checkout -q -b dev5
sed -i 's/user_registration_level: closed/user_registration_level: open/' "$REPO/config.yaml"
git -C "$REPO" commit -q -am "dev5: open registration for beta"

git -C "$REPO" checkout -q main
git -C "$REPO" checkout -q -b dev6
sed -i 's/user_registration_level: closed/user_registration_level: waitlist/' "$REPO/config.yaml"
git -C "$REPO" commit -q -am "dev6: waitlist registration mode"

git -C "$REPO" checkout -q main
