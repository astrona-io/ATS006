#!/usr/bin/env bash
set -u

REPO=/home/candidate/repositories/auto-verifier

if [ ! -d "$REPO/.git" ]; then
  echo "FAIL: no cloned repository found at $REPO"
  exit 1
fi

branch=$(git -C "$REPO" branch --show-current 2>/dev/null)
if [ "$branch" != "main" ]; then
  echo "FAIL: repository is not checked out on main (current: '${branch:-detached}')"
  exit 1
fi

if [ ! -f "$REPO/config.yaml" ] || ! grep -q "^user_registration_level: open$" "$REPO/config.yaml"; then
  echo "FAIL: config.yaml on main does not contain 'user_registration_level: open' -- wrong branch merged (or none merged)"
  exit 1
fi

if grep -qE "invite_only|waitlist" "$REPO/config.yaml"; then
  echo "FAIL: config.yaml contains a value from dev4 or dev6 -- only dev5 should have been merged"
  exit 1
fi

dev5_tip=$(git -C "$REPO" rev-parse origin/dev5 2>/dev/null)
if [ -z "$dev5_tip" ] || ! git -C "$REPO" merge-base --is-ancestor "$dev5_tip" main 2>/dev/null; then
  echo "FAIL: dev5's commit is not an ancestor of main -- dev5 was not actually merged into main"
  exit 1
fi

if [ ! -f "$REPO/logs/.keep" ]; then
  echo "FAIL: logs/.keep does not exist in the working tree"
  exit 1
fi

if ! git -C "$REPO" ls-files --error-unmatch logs/.keep >/dev/null 2>&1; then
  echo "FAIL: logs/.keep exists on disk but is not tracked by git"
  exit 1
fi

last_msg=$(git -C "$REPO" log -1 --format=%s)
if [ "$last_msg" != "added log directory" ]; then
  echo "FAIL: HEAD commit message is '$last_msg', expected 'added log directory'"
  exit 1
fi

changed=$(git -C "$REPO" diff-tree --no-commit-id --name-only -r HEAD)
if [ "$changed" != "logs/.keep" ]; then
  echo "FAIL: the 'added log directory' commit changed more than just logs/.keep (changed: $changed)"
  exit 1
fi

echo "PASS: dev5 merged into main, and logs/.keep committed correctly"
exit 0
