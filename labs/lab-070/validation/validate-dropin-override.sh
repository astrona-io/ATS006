#!/usr/bin/env bash
# Confirms RestartSec=10 was applied via a systemctl edit drop-in under
# healthcheck.service.d/, not by editing the base unit file.

set -u

DROPIN_DIR=/etc/systemd/system/healthcheck.service.d

dropin_count=$(sudo find "$DROPIN_DIR" -maxdepth 1 -name '*.conf' 2>/dev/null | wc -l)
if [[ "$dropin_count" -lt 1 ]]; then
  echo "FAIL: no drop-in override file found under $DROPIN_DIR"
  exit 1
fi

if ! sudo grep -rqE '^RestartSec=10\b' "$DROPIN_DIR"; then
  echo "FAIL: no drop-in file under $DROPIN_DIR sets RestartSec=10"
  exit 1
fi

if sudo grep -qE '^RestartSec=' /etc/systemd/system/healthcheck.service; then
  echo "FAIL: RestartSec= found in the base unit file -- it must only be set via the drop-in"
  exit 1
fi

echo "PASS: RestartSec=10 applied via drop-in override, base unit left untouched"
exit 0
