#!/usr/bin/env bash
set -eu
sudo mkdir -p /etc/systemd/system/lfcs-memory.service.d
sudo tee /etc/systemd/system/lfcs-memory.service.d/resources.conf >/dev/null <<'EOF'
[Service]
MemoryHigh=96M
MemoryMax=128M
EOF
sudo systemctl daemon-reload
sudo systemctl restart lfcs-memory.service
sleep 5
