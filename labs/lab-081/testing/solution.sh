#!/usr/bin/env bash
set -eu
sudo mkdir -p /etc/systemd/system/lfcs-cpu.service.d
sudo tee /etc/systemd/system/lfcs-cpu.service.d/resources.conf >/dev/null <<'EOF'
[Service]
CPUQuota=25%
CPUAccounting=yes
EOF
sudo systemctl daemon-reload
sudo systemctl restart lfcs-cpu.service
printf 'lfcs-cpu.service\n' | sudo tee /opt/course/cpu-service >/dev/null
