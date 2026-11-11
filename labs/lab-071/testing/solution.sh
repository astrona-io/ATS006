#!/usr/bin/env bash
set -euo pipefail
sudo useradd --system --no-create-home --shell /usr/sbin/nologin metrics
sudo chown metrics:metrics /var/log/metrics-collector
sudo tee /etc/systemd/system/metrics-collector.service >/dev/null <<'REFERENCE_FILE'
[Unit]
Description=Metrics Collector Service
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=metrics
Group=metrics
ExecStart=/opt/metrics/collector.sh
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
REFERENCE_FILE
sudo systemctl daemon-reload
sudo systemctl enable --now metrics-collector.service

