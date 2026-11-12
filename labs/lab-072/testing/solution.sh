#!/usr/bin/env bash
set -euo pipefail
sudo mkdir -p /etc/systemd/system/nginx.service.d
sudo tee /etc/systemd/system/nginx.service.d/override.conf >/dev/null <<'REFERENCE_FILE'
[Service]
Restart=on-failure
RestartSec=5
Environment=APP_ENV=production
REFERENCE_FILE
sudo systemctl daemon-reload
sudo systemctl restart nginx

