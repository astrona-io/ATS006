#!/usr/bin/env bash
set -u

REPO=/home/candidate/repositories/upstream-app
UPSTREAM=/repositories/upstream-app.git

if [ ! -d "$REPO/.git" ]; then
  echo "FAIL: no cloned repository found at $REPO"
  exit 1
fi

origin_url=$(git -C "$REPO" remote get-url origin 2>/dev/null)
if [ "$origin_url" != "$UPSTREAM" ]; then
  echo "FAIL: origin remote is not set to $UPSTREAM (got: '${origin_url:-none}')"
  exit 1
fi

if ! git -C "$REPO" show-ref --verify --quiet refs/heads/fix-timeout-value; then
  echo "FAIL: local branch fix-timeout-value does not exist"
  exit 1
fi

topic_msg=$(git -C "$REPO" log -1 --format=%s fix-timeout-value)
if [ "$topic_msg" != "increase timeout to 90s" ]; then
  echo "FAIL: fix-timeout-value's tip commit message is '$topic_msg', expected 'increase timeout to 90s'"
  exit 1
fi

config=$(git -C "$REPO" show fix-timeout-value:config.yaml 2>/dev/null)
if ! echo "$config" | grep -q "^timeout: 90$"; then
  echo "FAIL: config.yaml on fix-timeout-value does not contain 'timeout: 90'"
  exit 1
fi
if ! echo "$config" | grep -q "^retries: 5$"; then
  echo "FAIL: config.yaml on fix-timeout-value does not contain 'retries: 5' -- upstream's simulated commit was not reconciled in"
  exit 1
fi

# Confirm a rebase happened, not a merge: the topic commit must have
# exactly one parent, and that parent must be the simulated upstream
# commit -- proving the topic commit was replayed on top, not merged in
# alongside it.
parent_count=$(git -C "$REPO" log -1 --format=%P fix-timeout-value | wc -w)
if [ "$parent_count" -ne 1 ]; then
  echo "FAIL: fix-timeout-value's tip commit has $parent_count parents -- expected 1 (a merge commit was created instead of a rebase)"
  exit 1
fi

parent_msg=$(git -C "$REPO" log -1 --format=%s fix-timeout-value~1)
if [ "$parent_msg" != "bump retry count for flaky network" ]; then
  echo "FAIL: fix-timeout-value's commit is not based directly on the simulated upstream commit (parent message: '$parent_msg')"
  exit 1
fi

if [ ! -d "$UPSTREAM" ]; then
  echo "FAIL: bare upstream repository $UPSTREAM is missing"
  exit 1
fi

upstream_msg=$(git -C "$UPSTREAM" log -1 --format=%s main 2>/dev/null)
if [ "$upstream_msg" != "bump retry count for flaky network" ]; then
  echo "FAIL: upstream's main tip commit is '$upstream_msg', expected the simulated 'bump retry count for flaky network' push"
  exit 1
fi

echo "PASS: fix-timeout-value was rebased cleanly onto the simulated upstream commit"
exit 0
