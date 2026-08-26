#!/usr/bin/env bash
# Confirms the final main tip on the shared upstream contains BOTH the
# student's retry-limit bump and the simulated teammate's timeout
# commit together -- proof the rebase actually reconciled the two lines
# of work rather than one silently overwriting the other.

set -u

UPSTREAM=/repositories/deploy-configs.git

if [ ! -d "$UPSTREAM" ]; then
  echo "FAIL: bare upstream repository $UPSTREAM is missing"
  exit 1
fi

expected=$'feature_flag: enabled\nretry_limit: 10\nmax_connections: 100\nlog_level: info\ntimeout: 60'
actual=$(git -C "$UPSTREAM" show main:app.conf 2>/dev/null)

if [ "$actual" != "$expected" ]; then
  echo "FAIL: main's app.conf does not match the expected final content"
  echo "--- expected ---"
  echo "$expected"
  echo "--- actual ---"
  echo "$actual"
  exit 1
fi

if ! git -C "$UPSTREAM" log --format=%s main 2>/dev/null | grep -qx "increase retry limit to 10"; then
  echo "FAIL: no commit on main with the message 'increase retry limit to 10'"
  exit 1
fi

if ! git -C "$UPSTREAM" log --format=%s main 2>/dev/null | grep -qx "add default timeout to app.conf"; then
  echo "FAIL: no commit on main with the message 'add default timeout to app.conf' -- the simulated teammate push is missing"
  exit 1
fi

echo "PASS: main's app.conf reflects both the retry-limit bump and the simulated teammate's timeout commit"
exit 0
