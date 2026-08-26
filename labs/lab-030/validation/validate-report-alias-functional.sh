#!/usr/bin/env bash
set -u

report_output=$(bash -ic 'report' 2>/dev/null | tr -d '[:space:]')

if [ "$report_output" != "2" ]; then
  echo "FAIL: the 'report' alias printed '$report_output', expected '2' (the number of redacted lines in service.log)"
  exit 1
fi

echo "PASS: the report alias runs correctly and prints the right redacted-line count"
exit 0
