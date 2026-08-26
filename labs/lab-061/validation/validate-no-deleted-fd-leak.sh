#!/usr/bin/env bash
# Confirms no deleted-but-open reporting-app file descriptors remain --
# either truncated live via /proc/PID/fd or cleared by a service restart.

set -u

leaked=$(sudo lsof +L1 2>/dev/null | grep -i reporting || true)

if [[ -n "$leaked" ]]; then
  echo "FAIL: a deleted-but-open reporting-app file descriptor is still held: $leaked"
  exit 1
fi

echo "PASS: no deleted-but-open reporting-app file descriptors remain"
exit 0
