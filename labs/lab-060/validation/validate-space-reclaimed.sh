#!/usr/bin/env bash
# Confirms /var/log/audit-svc usage has dropped substantially from its
# near-100% baseline set up by bootstrap.

set -u

MOUNT=/var/log/audit-svc
used_pct=$(df --output=pcent "$MOUNT" 2>/dev/null | tail -1 | tr -dc '0-9')

if [[ -z "$used_pct" ]]; then
  echo "FAIL: could not read df usage for $MOUNT"
  exit 1
fi

if (( used_pct > 50 )); then
  echo "FAIL: $MOUNT is still ${used_pct}% full - space was not reclaimed"
  exit 1
fi

echo "PASS: $MOUNT usage is down to ${used_pct}% - space reclaimed"
exit 0
