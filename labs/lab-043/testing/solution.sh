#!/usr/bin/env bash
set -euo pipefail
git clone /repositories/upstream-app.git /home/candidate/repositories/upstream-app
cd /home/candidate/repositories/upstream-app
git branch -vv

git switch -c fix-timeout-value

sed -i 's/timeout: 30/timeout: 90/' config.yaml
git diff
git add config.yaml
git commit -m "increase timeout to 90s"

git log main..fix-timeout-value --oneline
git diff main..fix-timeout-value

git clone /repositories/upstream-app.git /tmp/someone-else
cd /tmp/someone-else
sed -i 's/retries: 3/retries: 5/' config.yaml
git add config.yaml
git commit -m "bump retry count for flaky network"
git push origin main
cd /home/candidate/repositories/upstream-app
rm -rf /tmp/someone-else

git fetch origin
git log main..origin/main --oneline
git rebase origin/main

git log --oneline --graph --all
cat config.yaml

git log -2 --format=%s fix-timeout-value

