#!/usr/bin/env bash
set -u

BLOCKING="$HOME/blocking-command.txt"
NEXT="$HOME/next-command.txt"

if [ ! -f "$BLOCKING" ]; then
  echo "FAIL: $BLOCKING does not exist"
  exit 1
fi

expected_blocking="sudo ufw deny from 198.51.100.23"
actual_blocking=$(cat "$BLOCKING")
if [ "$actual_blocking" != "$expected_blocking" ]; then
  echo "FAIL: $BLOCKING content is '$actual_blocking', expected '$expected_blocking'"
  exit 1
fi

if [ ! -f "$NEXT" ]; then
  echo "FAIL: $NEXT does not exist"
  exit 1
fi

expected_next="sudo ufw status numbered"
actual_next=$(cat "$NEXT")
if [ "$actual_next" != "$expected_next" ]; then
  echo "FAIL: $NEXT content is '$actual_next', expected '$expected_next'"
  exit 1
fi

echo "PASS: both recovered history commands are correct"
exit 0
