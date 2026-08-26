#!/usr/bin/env bash
set -u

SERVICE_LOG=/var/log-collector/incident/service.log

if [ ! -f "$SERVICE_LOG" ]; then
  echo "FAIL: $SERVICE_LOG does not exist"
  exit 1
fi

expected='REDACTED - INCIDENT #4471
service.auth attempt=normal user=admin FAILED
service.web attempt=bruteforce user=admin FAILED
service.auth attempt=bruteforce user=admin SUCCESS
REDACTED - INCIDENT #4471
service.cache attempt=bruteforce status=FAILED'

actual=$(cat "$SERVICE_LOG")

if [ "$actual" != "$expected" ]; then
  echo "FAIL: $SERVICE_LOG content does not match the expected redacted result exactly"
  exit 1
fi

echo "PASS: service.log was redacted exactly where required and nowhere else"
exit 0
