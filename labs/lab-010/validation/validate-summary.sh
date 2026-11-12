#!/usr/bin/env bash
# Match the account used by astrona ssh, including its home and permissions.
sudo -H -u student bash <<'ASTRONA_STUDENT_SCRIPT'
# Inspect protected state; user access checks select their target account explicitly.
sudo -n bash <<'GRADER_ROOT'
# Confirms run-check.sh builds probe.summary from its optional first
# argument, an if test and a for loop, and still works with no argument.

set -u

SCRIPT=/opt/monitor/run-check.sh
SUMMARY=/var/log/monitor/probe.summary

if [ ! -x "$SCRIPT" ]; then
  echo "FAIL: $SCRIPT is not executable, cannot verify probe.summary"
  exit 1
fi

if ! grep -Eq '(\$1|\$\{1[:}-])' "$SCRIPT"; then
  echo "FAIL: $SCRIPT does not read its first argument (\$1)"
  exit 1
fi

if ! grep -Eq '^[[:space:]]*if[[:space:]]' "$SCRIPT"; then
  echo "FAIL: $SCRIPT does not use an if test"
  exit 1
fi

if ! grep -Eq '^[[:space:]]*for[[:space:]]+[A-Za-z_][A-Za-z_0-9]*[[:space:]]+in[[:space:]]' "$SCRIPT"; then
  echo "FAIL: $SCRIPT does not use a for loop"
  exit 1
fi

rm -f "$SUMMARY"
"$SCRIPT" nightly-check >/dev/null 2>&1

expected='label=nightly-check
status=healthy
probe.out 1 lines
probe.err 1 lines
probe.combined 2 lines'

if [ ! -f "$SUMMARY" ]; then
  echo "FAIL: $SUMMARY was not created"
  exit 1
fi

actual=$(cat "$SUMMARY")
if [ "$actual" != "$expected" ]; then
  echo "FAIL: $SUMMARY does not match the expected five lines. Got:"
  echo "$actual"
  exit 1
fi

rm -f "$SUMMARY"
"$SCRIPT" >/dev/null 2>&1

first_line=$(head -n 1 "$SUMMARY" 2>/dev/null)
if [ "$first_line" != "label=manual" ]; then
  echo "FAIL: with no argument the first line must be 'label=manual', got '$first_line'"
  exit 1
fi

echo "PASS: probe.summary is built from the label argument, an if test and a for loop"
exit 0
GRADER_ROOT
ASTRONA_STUDENT_SCRIPT
