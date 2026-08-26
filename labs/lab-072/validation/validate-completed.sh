#!/usr/bin/env bash
set -u

RECORD=/var/lib/ats006-lab072/original-nginx-unit.sha256
VENDOR_PATH_FILE=/var/lib/ats006-lab072/vendor-unit-path.txt

if [[ ! -f "$RECORD" ]] || [[ ! -f "$VENDOR_PATH_FILE" ]]; then
  echo "FAIL: bootstrap record of the original vendor unit checksum is missing"
  exit 1
fi

VENDOR_UNIT=$(cat "$VENDOR_PATH_FILE")

# 1. Vendor unit file must remain byte-for-byte unmodified.
if ! sha256sum -c "$RECORD" >/dev/null 2>&1; then
  echo "FAIL: vendor unit file $VENDOR_UNIT has been modified since bootstrap"
  exit 1
fi

# 2. A drop-in override file must exist under nginx.service.d/.
dropin_count=$(sudo find /etc/systemd/system/nginx.service.d -maxdepth 1 -name '*.conf' 2>/dev/null | wc -l)
if [[ "$dropin_count" -lt 1 ]]; then
  echo "FAIL: no drop-in override file found under /etc/systemd/system/nginx.service.d/"
  exit 1
fi

# 3. Effective merged configuration reflects both changes.
restart_policy=$(systemctl show nginx -p Restart --value)
if [[ "$restart_policy" != "on-failure" ]]; then
  echo "FAIL: effective Restart= is '$restart_policy', expected 'on-failure'"
  exit 1
fi

env_list=$(systemctl show nginx -p Environment --value)
if [[ "$env_list" != *"APP_ENV=production"* ]]; then
  echo "FAIL: effective Environment does not include APP_ENV=production (got: '$env_list')"
  exit 1
fi

# 4. Service is still up and running under the new configuration.
active_state=$(systemctl is-active nginx 2>/dev/null)
if [[ "$active_state" != "active" ]]; then
  echo "FAIL: nginx.service is not active (state: '$active_state')"
  exit 1
fi

echo "PASS: nginx.service overridden via drop-in with vendor unit left untouched"
exit 0
