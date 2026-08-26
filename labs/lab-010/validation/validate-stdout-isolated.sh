#!/usr/bin/env bash
# Confirms probe.out contains only the probe's stdout content -- no
# stderr lines (PROBE_DIAG/PROBE_WARN) leaked in.

set -u

SCRIPT=/opt/monitor/run-check.sh
OUT=/var/log/monitor/probe.out

if [ ! -x "$SCRIPT" ]; then
  echo "FAIL: $SCRIPT is not executable, cannot verify probe.out"
  exit 1
fi

"$SCRIPT" >/dev/null 2>&1

if [ ! -s "$OUT" ]; then
  echo "FAIL: $OUT is missing or empty"
  exit 1
fi

if ! grep -q "PROBE_OK: service healthy under strict mode" "$OUT"; then
  echo "FAIL: $OUT does not contain the expected PROBE_OK line"
  exit 1
fi

if grep -qE "PROBE_DIAG|PROBE_WARN|PROBE_DEGRADED" "$OUT"; then
  echo "FAIL: $OUT contains stderr content -- stdout was not isolated"
  exit 1
fi

echo "PASS: probe.out contains only the probe's stdout content"
exit 0
