#!/usr/bin/env bash
# Confirms no deleted-but-open audit-svc file descriptors remain --
# either truncated live via /proc/PID/fd or cleared by a service restart.

set -u

leaked=$(sudo lsof +L1 2>/dev/null | grep -i audit || true)

if [[ -n "$leaked" ]]; then
  echo "FAIL: a deleted-but-open audit-svc file descriptor is still held: $leaked"
  exit 1
fi

echo "PASS: no deleted-but-open audit-svc file descriptors remain"
exit 0
