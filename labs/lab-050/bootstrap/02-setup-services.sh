#!/usr/bin/env bash
# Bootstrap (Part 2): seeds /opt/services with a config file, a
# deliberately restricted-permission secrets file (to test -p
# preservation), a stable data file that never changes during the lab
# (used to prove the incremental backup skips unchanged files), and a
# disposable data/tmp/ directory that must never be backed up. Does NOT
# create /backup or /restore, and does NOT perform any part of the
# graded backup/restore task itself.

set -eu

sudo mkdir -p /opt/services/config
sudo mkdir -p /opt/services/data/tmp

cat <<'EOF' | sudo tee /opt/services/config/app.conf > /dev/null
service_name=inventory-api
log_level=info
EOF

cat <<'EOF' | sudo tee /opt/services/config/secrets.conf > /dev/null
api_key=REDACTED-EXAMPLE-KEY
EOF
sudo chmod 600 /opt/services/config/secrets.conf
sudo chown root:root /opt/services/config/secrets.conf

cat <<'EOF' | sudo tee /opt/services/data/ledger-2026-Q2.csv > /dev/null
period,total_units,total_value
2026-Q2,18420,915230.50
EOF

echo "cached-render-$$" | sudo tee /opt/services/data/tmp/render-cache-1.tmp > /dev/null
echo "cached-render-$$" | sudo tee /opt/services/data/tmp/render-cache-2.tmp > /dev/null
