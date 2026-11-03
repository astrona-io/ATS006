#!/usr/bin/env bash
set -u

NOTE="$HOME/handover.conf"
FACTS="$HOME/handover-facts.txt"

if [ ! -f "$NOTE" ]; then
  echo "FAIL: $NOTE does not exist"
  exit 1
fi

expected_note='blocked_ip=198.51.100.23
reviewed=yes
mode=lockdown
shift=handover'

actual_note=$(cat "$NOTE")
if [ "$actual_note" != "$expected_note" ]; then
  echo "FAIL: $NOTE does not have the expected content. Got:"
  echo "$actual_note"
  exit 1
fi

if [ ! -f "$FACTS" ]; then
  echo "FAIL: $FACTS does not exist"
  exit 1
fi

expected_facts='sort-numeric=-n
fstab-file-section=5'

actual_facts=$(cat "$FACTS")
if [ "$actual_facts" != "$expected_facts" ]; then
  echo "FAIL: $FACTS does not have the two expected lines. Got:"
  echo "$actual_facts"
  exit 1
fi

echo "PASS: handover.conf was edited correctly and handover-facts.txt holds both facts"
exit 0
