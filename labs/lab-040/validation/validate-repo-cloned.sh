#!/usr/bin/env bash
# Confirms the deploy-configs repository was cloned to the expected path
# and points at the shared bare upstream.

set -u

REPO=/home/candidate/deploy-configs
UPSTREAM=/repositories/deploy-configs.git

if [ ! -d "$REPO/.git" ]; then
  echo "FAIL: no cloned repository found at $REPO"
  exit 1
fi

origin_url=$(git -C "$REPO" remote get-url origin 2>/dev/null)
if [ "$origin_url" != "$UPSTREAM" ]; then
  echo "FAIL: origin remote is not set to $UPSTREAM (got: '${origin_url:-none}')"
  exit 1
fi

echo "PASS: deploy-configs cloned to $REPO with origin pointing at $UPSTREAM"
exit 0
