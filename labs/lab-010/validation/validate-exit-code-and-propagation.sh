#!/usr/bin/env bash
# Confirms probe.exit captured "0" and that run-check.sh itself exits
# with that same code -- proving $? was captured immediately and
# propagated correctly, not clobbered by an intervening command.

set -u

SCRIPT=/opt/monitor/run-check.sh
EXITFILE=/var/log/monitor/probe.exit

if [ ! -x "$SCRIPT" ]; then
  echo "FAIL: $SCRIPT is not executable, cannot verify exit code capture"
  exit 1
fi

"$SCRIPT" >/dev/null 2>&1
wrapper_exit=$?

if [ ! -s "$EXITFILE" ]; then
  echo "FAIL: $EXITFILE is missing or empty"
  exit 1
fi

captured=$(tr -d '[:space:]' < "$EXITFILE")

if [ "$captured" != "0" ]; then
  echo "FAIL: $EXITFILE contains '$captured', expected '0'"
  exit 1
fi

if [ "$wrapper_exit" -ne 0 ]; then
  echo "FAIL: run-check.sh itself exited with $wrapper_exit, expected 0 (it must propagate the probe's exit code)"
  exit 1
fi

echo "PASS: probe.exit correctly captured '0' and run-check.sh propagated the same exit code"
exit 0
