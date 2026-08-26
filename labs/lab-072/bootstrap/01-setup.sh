#!/usr/bin/env bash
# Bootstrap: installs the vendor-packaged nginx.service and records a
# checksum of the untouched vendor unit file so validation can later prove
# it was never hand-edited. Does NOT create the drop-in override -- that is
# the graded task.

set -eu

if ! command -v nginx >/dev/null 2>&1; then
  sudo apt-get update -y
  sudo apt-get install -y nginx
fi

sudo systemctl enable --now nginx

VENDOR_UNIT=/usr/lib/systemd/system/nginx.service
if [ ! -f "$VENDOR_UNIT" ]; then
  VENDOR_UNIT=/lib/systemd/system/nginx.service
fi

sudo mkdir -p /var/lib/ats006-lab072
sha256sum "$VENDOR_UNIT" | sudo tee /var/lib/ats006-lab072/original-nginx-unit.sha256 > /dev/null
echo "$VENDOR_UNIT" | sudo tee /var/lib/ats006-lab072/vendor-unit-path.txt > /dev/null
