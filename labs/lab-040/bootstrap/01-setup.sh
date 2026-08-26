#!/usr/bin/env bash
# Bootstrap: creates the bare "deploy-configs" upstream repository, seeds
# main with a single initial commit, and creates three candidate
# environment branches (env-staging, env-canary, env-prod) off that same
# commit, each setting app.conf's feature_flag differently. Only
# env-canary sets feature_flag: enabled -- the value the student must
# locate and merge. This pre-stages the scenario only; cloning, merging,
# the scripts/.keep commit, the topic branch, the simulated teammate
# push, and the rebase are all left for the graded task.

set -eu

sudo mkdir -p /repositories
sudo chown -R "$(whoami):$(whoami)" /repositories

sudo mkdir -p /home/candidate
sudo chown -R "$(whoami):$(whoami)" /home/candidate

git config --global user.email "candidate@lab.local"
git config --global user.name "Candidate"
git config --global init.defaultBranch main

UPSTREAM=/repositories/deploy-configs.git
rm -rf "$UPSTREAM"
git init -q --bare "$UPSTREAM"

SEED=$(mktemp -d)
git clone -q "$UPSTREAM" "$SEED"
git -C "$SEED" config user.email "bootstrap@lab.local"
git -C "$SEED" config user.name "Lab Bootstrap"

cat > "$SEED/README.md" <<'EOF'
# deploy-configs

Shared deployment configuration for the platform team.
EOF

cat > "$SEED/app.conf" <<'EOF'
feature_flag: disabled
retry_limit: 3
max_connections: 100
log_level: info
EOF

git -C "$SEED" add -A
git -C "$SEED" commit -q -m "initial commit"
git -C "$SEED" push -q origin main

git -C "$SEED" checkout -q -b env-staging
sed -i 's/feature_flag: disabled/feature_flag: staging_only/' "$SEED/app.conf"
git -C "$SEED" commit -q -am "restrict feature flag to staging only"
git -C "$SEED" push -q origin env-staging

git -C "$SEED" checkout -q main
git -C "$SEED" checkout -q -b env-canary
sed -i 's/feature_flag: disabled/feature_flag: enabled/' "$SEED/app.conf"
git -C "$SEED" commit -q -am "enable feature flag for canary rollout"
git -C "$SEED" push -q origin env-canary

git -C "$SEED" checkout -q main
git -C "$SEED" checkout -q -b env-prod
sed -i 's/feature_flag: disabled/feature_flag: disabled  # matches production default/' "$SEED/app.conf"
git -C "$SEED" commit -q -am "confirm feature flag stays disabled in prod"
git -C "$SEED" push -q origin env-prod

rm -rf "$SEED"
