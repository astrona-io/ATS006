#!/usr/bin/env bash
# Match the account used by astrona ssh, including its home and permissions.
sudo -H -u student bash <<'ASTRONA_STUDENT_SCRIPT'
set -u

TOP="$HOME/top-sources.txt"
STATUSES="$HOME/attacker-statuses.txt"

if [ ! -f "$TOP" ]; then
  echo "FAIL: $TOP does not exist"
  exit 1
fi

# Leading spaces in front of the count are allowed, so normalise them.
actual_top=$(awk '{print $1, $2}' "$TOP")
expected_top='4 198.51.100.23
1 203.0.113.50'

if [ "$actual_top" != "$expected_top" ]; then
  echo "FAIL: $TOP must list '<count> <ip>' with the busiest address first. Got:"
  echo "$actual_top"
  exit 1
fi

if [ ! -f "$STATUSES" ]; then
  echo "FAIL: $STATUSES does not exist"
  exit 1
fi

actual_status=$(cat "$STATUSES")
expected_status='200
401'

if [ "$actual_status" != "$expected_status" ]; then
  echo "FAIL: $STATUSES must hold the status codes 200 and 401, each once, sorted. Got:"
  echo "$actual_status"
  exit 1
fi

echo "PASS: top-sources.txt and attacker-statuses.txt are correct"
exit 0
ASTRONA_STUDENT_SCRIPT
