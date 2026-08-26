#!/usr/bin/env bash
# Confirms scripts/.keep was committed to main (using the .keep
# placeholder convention for an otherwise-empty directory) with the
# exact expected commit message, and that the commit only touched
# scripts/.keep.

set -u

UPSTREAM=/repositories/deploy-configs.git

if [ ! -d "$UPSTREAM" ]; then
  echo "FAIL: bare upstream repository $UPSTREAM is missing"
  exit 1
fi

if ! git -C "$UPSTREAM" log --format=%s main 2>/dev/null | grep -qx "add scripts directory"; then
  echo "FAIL: no commit on main with the message 'add scripts directory'"
  exit 1
fi

commit=$(git -C "$UPSTREAM" log --format=%H --grep="^add scripts directory$" main | head -1)
if [ -z "$commit" ]; then
  echo "FAIL: could not resolve the 'add scripts directory' commit"
  exit 1
fi

if ! git -C "$UPSTREAM" show "$commit":scripts/.keep >/dev/null 2>&1; then
  echo "FAIL: scripts/.keep is not present in the tree at the 'add scripts directory' commit"
  exit 1
fi

changed=$(git -C "$UPSTREAM" diff-tree --no-commit-id --name-only -r "$commit")
if [ "$changed" != "scripts/.keep" ]; then
  echo "FAIL: the 'add scripts directory' commit changed more than just scripts/.keep (changed: $changed)"
  exit 1
fi

echo "PASS: scripts/.keep committed on main with the exact expected message"
exit 0
