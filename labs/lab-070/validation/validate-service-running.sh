#!/usr/bin/env bash
# Confirms healthcheck.service is active and enabled, and that the merged
# RestartSec=10 from the drop-in is actually the value systemd is enforcing
# on the live unit (proving daemon-reload + restart were actually run).

set -u

active_state=$(systemctl is-active healthcheck.service 2>/dev/null)
if [[ "$active_state" != "active" ]]; then
  echo "FAIL: healthcheck.service is not active (state: '$active_state')"
  exit 1
fi

enabled_state=$(systemctl is-enabled healthcheck.service 2>/dev/null)
if [[ "$enabled_state" != "enabled" ]]; then
  echo "FAIL: healthcheck.service is not enabled (state: '$enabled_state')"
  exit 1
fi

restart_usec=$(systemctl show healthcheck.service -p RestartUSec --value 2>/dev/null)
if [[ "$restart_usec" != "10s" ]] && [[ "$restart_usec" != "10000000" ]]; then
  echo "FAIL: effective RestartUSec is '$restart_usec', expected 10s (the drop-in override does not appear to be loaded)"
  exit 1
fi

echo "PASS: healthcheck.service is active, enabled, and the RestartSec=10 override is live"
exit 0
