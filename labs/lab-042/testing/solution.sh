#!/usr/bin/env bash
set -euo pipefail
git clone /repositories/auto-verifier /home/candidate/repositories/auto-verifier
cd /home/candidate/repositories/auto-verifier

for b in dev4 dev5 dev6; do
  echo "== $b =="
  git show origin/$b:config.yaml | grep user_registration_level
done

git switch main
git merge origin/dev5

grep user_registration_level config.yaml

mkdir -p logs
touch logs/.keep

git add logs/.keep
git status
git commit -m "added log directory"

git branch --show-current
git log -1 --format=%s

