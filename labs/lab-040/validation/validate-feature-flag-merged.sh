#!/usr/bin/env bash
# Confirms that env-canary specifically (feature_flag: enabled) was
# merged into main on the shared upstream, and not env-staging/env-prod.

set -u

UPSTREAM=/repositories/deploy-configs.git

if [ ! -d "$UPSTREAM" ]; then
  echo "FAIL: bare upstream repository $UPSTREAM is missing"
  exit 1
fi

app_conf=$(git -C "$UPSTREAM" show main:app.conf 2>/dev/null)
if [ -z "$app_conf" ]; then
  echo "FAIL: could not read app.conf from main on the upstream repository"
  exit 1
fi

if ! echo "$app_conf" | grep -q "^feature_flag: enabled$"; then
  echo "FAIL: main's app.conf does not contain 'feature_flag: enabled' -- wrong branch merged (or none)"
  exit 1
fi

if echo "$app_conf" | grep -qE "staging_only|matches production default"; then
  echo "FAIL: main's app.conf still shows content from env-staging or env-prod"
  exit 1
fi

canary_tip=$(git -C "$UPSTREAM" rev-parse env-canary 2>/dev/null)
if [ -z "$canary_tip" ] || ! git -C "$UPSTREAM" merge-base --is-ancestor "$canary_tip" main 2>/dev/null; then
  echo "FAIL: env-canary's commit is not an ancestor of main -- it was not actually merged"
  exit 1
fi

echo "PASS: env-canary was merged into main and app.conf shows feature_flag: enabled"
exit 0
