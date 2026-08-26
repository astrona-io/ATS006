#!/usr/bin/env bash
# Confirms the base unit file at /etc/systemd/system/healthcheck.service has
# the correct directives, and does NOT itself set RestartSec (that value
# must live only in the Part 2 drop-in).

set -u

UNIT_FILE=/etc/systemd/system/healthcheck.service

if [[ ! -f "$UNIT_FILE" ]]; then
  echo "FAIL: base unit file not found at $UNIT_FILE"
  exit 1
fi

if ! id healthcheck >/dev/null 2>&1; then
  echo "FAIL: system user 'healthcheck' does not exist"
  exit 1
fi

healthcheck_uid=$(id -u healthcheck)
if (( healthcheck_uid >= 1000 )); then
  echo "FAIL: 'healthcheck' user has UID $healthcheck_uid, expected a system UID (< 1000)"
  exit 1
fi

owner=$(stat -c '%U:%G' /var/log/healthcheck 2>/dev/null)
if [[ "$owner" != "healthcheck:healthcheck" ]]; then
  echo "FAIL: /var/log/healthcheck owned by '$owner', expected 'healthcheck:healthcheck'"
  exit 1
fi

if ! sudo grep -q '^ExecStart=/opt/healthcheck/healthcheck.sh' "$UNIT_FILE"; then
  echo "FAIL: base unit ExecStart= does not reference /opt/healthcheck/healthcheck.sh"
  exit 1
fi

if ! sudo grep -qE '^User=healthcheck' "$UNIT_FILE"; then
  echo "FAIL: base unit does not set User=healthcheck"
  exit 1
fi

if ! sudo grep -qE '^Restart=on-failure' "$UNIT_FILE"; then
  echo "FAIL: base unit does not set Restart=on-failure"
  exit 1
fi

if ! sudo grep -q 'network-online.target' "$UNIT_FILE"; then
  echo "FAIL: base unit does not reference network-online.target"
  exit 1
fi

if sudo grep -qE '^RestartSec=' "$UNIT_FILE"; then
  echo "FAIL: base unit file itself sets RestartSec= -- that value must live only in the drop-in override, not the base unit"
  exit 1
fi

echo "PASS: base healthcheck.service unit is correctly authored"
exit 0
