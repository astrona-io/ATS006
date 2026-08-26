#!/usr/bin/env bash
# Confirms the reconciliation was done with a rebase, not a merge: main's
# final history on the shared upstream must contain zero merge commits
# (every commit has exactly one parent), proving the retry-limit commit
# was replayed on top of the teammate's timeout commit rather than
# joined to it with a two-parent merge commit.

set -u

UPSTREAM=/repositories/deploy-configs.git

if [ ! -d "$UPSTREAM" ]; then
  echo "FAIL: bare upstream repository $UPSTREAM is missing"
  exit 1
fi

merge_commits=$(git -C "$UPSTREAM" log --merges --oneline main 2>/dev/null)
if [ -n "$merge_commits" ]; then
  echo "FAIL: found merge commit(s) on main -- reconciliation should have been a rebase, resulting in a linear history:"
  echo "$merge_commits"
  exit 1
fi

echo "PASS: main's history is fully linear with no merge commits"
exit 0
