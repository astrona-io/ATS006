#!/usr/bin/env bash
set -euo pipefail
git clone /repositories/deploy-configs.git /home/candidate/deploy-configs
cd /home/candidate/deploy-configs

for b in env-staging env-canary env-prod; do
  echo "== $b =="
  git show origin/$b:app.conf | grep feature_flag
done

git switch main
git merge origin/env-canary

mkdir -p scripts
touch scripts/.keep
git add scripts/.keep
git commit -m "add scripts directory"

git push -u origin main

git switch -c bump-retry-limit
sed -i 's/retry_limit: 3/retry_limit: 10/' app.conf
git add app.conf
git commit -m "increase retry limit to 10"

git clone /repositories/deploy-configs.git /tmp/someone-else
cd /tmp/someone-else
echo "timeout: 60" >> app.conf
git add app.conf
git commit -m "add default timeout to app.conf"
git push origin main
cd /home/candidate/deploy-configs
rm -rf /tmp/someone-else

git fetch origin
git switch bump-retry-limit
git rebase origin/main

git switch main
git merge origin/main
git merge bump-retry-limit
git push origin main

git -C /repositories/deploy-configs.git log --reverse --format=%s main

git -C /repositories/deploy-configs.git show main:app.conf

