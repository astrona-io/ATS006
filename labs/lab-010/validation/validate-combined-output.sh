#!/usr/bin/env bash
# Confirms probe.combined captured both stdout and stderr content,
# proving the wrapper used the correct "> file 2>&1" ordering.

set -u

SCRIPT=/opt/monitor/run-check.sh
COMBINED=/var/log/monitor/probe.combined

if [ ! -x "$SCRIPT" ]; then
  echo "FAIL: $SCRIPT is not executable, cannot verify probe.combined"
  exit 1
fi

"$SCRIPT" >/dev/null 2>&1

if [ ! -s "$COMBINED" ]; then
  echo "FAIL: $COMBINED is missing or empty"
  exit 1
fi

if ! grep -q "PROBE_OK: service healthy under strict mode" "$COMBINED"; then
  echo "FAIL: $COMBINED is missing the expected stdout line -- redirection order likely reversed (2>&1 before the file redirect)"
  exit 1
fi

if ! grep -q "PROBE_DIAG: probe invoked with PROBE_MODE=strict" "$COMBINED"; then
  echo "FAIL: $COMBINED is missing the expected stderr line"
  exit 1
fi

echo "PASS: probe.combined contains both stdout and stderr content"
exit 0
