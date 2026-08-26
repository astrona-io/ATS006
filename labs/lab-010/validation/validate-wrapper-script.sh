#!/usr/bin/env bash
# Confirms run-check.sh exists, is executable, exports PROBE_MODE=strict
# for the child probe, and never exports CHECK_ID (which must stay
# shell-local to the wrapper itself).

set -u

SCRIPT=/opt/monitor/run-check.sh

if [ ! -f "$SCRIPT" ]; then
  echo "FAIL: $SCRIPT does not exist"
  exit 1
fi

if [ ! -x "$SCRIPT" ]; then
  echo "FAIL: $SCRIPT is not executable"
  exit 1
fi

if ! grep -Eq '^[[:space:]]*export[[:space:]]+PROBE_MODE=strict[[:space:]]*$' "$SCRIPT"; then
  echo "FAIL: $SCRIPT must export PROBE_MODE=strict so the child probe inherits it"
  exit 1
fi

if grep -Eq '^[[:space:]]*export[[:space:]]+CHECK_ID\b' "$SCRIPT"; then
  echo "FAIL: $SCRIPT must not export CHECK_ID -- it should remain shell-local to the wrapper"
  exit 1
fi

if ! grep -Eq '^[[:space:]]*CHECK_ID=nightly-001[[:space:]]*$' "$SCRIPT"; then
  echo "FAIL: $SCRIPT must define CHECK_ID=nightly-001"
  exit 1
fi

echo "PASS: run-check.sh is executable and scopes PROBE_MODE/CHECK_ID correctly"
exit 0
