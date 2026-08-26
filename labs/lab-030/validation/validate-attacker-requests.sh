#!/usr/bin/env bash
set -u

ACCESS_LOG=/var/log-collector/incident/access.log
EXTRACTED=/var/log-collector/incident/attacker-requests.log

if [ ! -f "$EXTRACTED" ]; then
  echo "FAIL: $EXTRACTED does not exist"
  exit 1
fi

expected='198.51.100.23 - - [21/Aug/2026:03:14:02 +0000] "POST /admin/login HTTP/1.1" 401 128 "-" "curl/7.81.0"
198.51.100.23 - - [21/Aug/2026:03:14:05 +0000] "POST /admin/login HTTP/1.1" 401 128 "-" "curl/7.81.0"
198.51.100.23 - - [21/Aug/2026:03:14:09 +0000] "POST /admin/login HTTP/1.1" 200 512 "-" "curl/7.81.0"'

actual=$(cat "$EXTRACTED")

if [ "$actual" != "$expected" ]; then
  echo "FAIL: $EXTRACTED content does not match the expected 3 matching lines exactly"
  exit 1
fi

actual_lines=$(wc -l < "$ACCESS_LOG" | tr -d '[:space:]')
if [ "$actual_lines" != "5" ]; then
  echo "FAIL: $ACCESS_LOG has $actual_lines lines, expected 5 -- the source file must not be modified or truncated"
  exit 1
fi

echo "PASS: attacker-requests.log contains exactly the 3 matching lines, and access.log is untouched"
exit 0
