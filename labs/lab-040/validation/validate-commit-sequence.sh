#!/usr/bin/env bash
# Confirms the exact, ordered sequence of commit messages reachable from
# main on the shared upstream, oldest to newest -- the single strictest
# check that the whole capstone story landed in the right order.

set -u

UPSTREAM=/repositories/deploy-configs.git

if [ ! -d "$UPSTREAM" ]; then
  echo "FAIL: bare upstream repository $UPSTREAM is missing"
  exit 1
fi

actual=$(git -C "$UPSTREAM" log --reverse --format=%s main 2>/dev/null)
expected=$'initial commit\nenable feature flag for canary rollout\nadd scripts directory\nadd default timeout to app.conf\nincrease retry limit to 10'

if [ "$actual" != "$expected" ]; then
  echo "FAIL: main's commit sequence does not match the expected end-to-end story"
  echo "--- expected ---"
  echo "$expected"
  echo "--- actual ---"
  echo "$actual"
  exit 1
fi

echo "PASS: main's commit history matches the expected 5-commit sequence exactly"
exit 0
