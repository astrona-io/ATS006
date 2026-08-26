#!/usr/bin/env bash
# Confirms probe.err contains only the probe's stderr content (the
# PROBE_DIAG line), with no stdout leaked in and no PROBE_WARN line --
# the latter would only appear if CHECK_ID was incorrectly exported.

set -u

SCRIPT=/opt/monitor/run-check.sh
ERR=/var/log/monitor/probe.err

if [ ! -x "$SCRIPT" ]; then
  echo "FAIL: $SCRIPT is not executable, cannot verify probe.err"
  exit 1
fi

"$SCRIPT" >/dev/null 2>&1

if [ ! -s "$ERR" ]; then
  echo "FAIL: $ERR is missing or empty"
  exit 1
fi

if ! grep -q "PROBE_DIAG: probe invoked with PROBE_MODE=strict" "$ERR"; then
  echo "FAIL: $ERR does not contain the expected PROBE_DIAG line with PROBE_MODE=strict"
  exit 1
fi

if grep -q "PROBE_OK" "$ERR"; then
  echo "FAIL: $ERR contains stdout content -- stderr was not isolated"
  exit 1
fi

if grep -q "PROBE_WARN" "$ERR"; then
  echo "FAIL: $ERR contains a PROBE_WARN line -- CHECK_ID was leaked to the probe (it must stay shell-local)"
  exit 1
fi

echo "PASS: probe.err contains only the probe's stderr content, with no CHECK_ID leak"
exit 0
