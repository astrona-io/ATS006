#!/usr/bin/env bash
# Match the account used by astrona ssh, including its home and permissions.
sudo -H -u student bash <<'ASTRONA_STUDENT_SCRIPT'
set -euo pipefail
sudo -n bash <<'BOOTSTRAP_ROOT'
set -euo pipefail
apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y sysstat python3
install -d /usr/local/share/lfcs /opt/course
cat >/usr/local/bin/lfcs-memory-worker.py <<'WORKER'
import time
payload = bytearray(64 * 1024 * 1024)
for offset in range(0, len(payload), 4096):
    payload[offset] = 1
while True:
    time.sleep(1)
WORKER
cp /usr/local/bin/lfcs-memory-worker.py /usr/local/share/lfcs/memory-worker.reference
cat >/etc/systemd/system/lfcs-memory.service <<'UNIT'
[Unit]
Description=LFCS memory diagnosis workload
[Service]
ExecStart=/usr/bin/python3 /usr/local/bin/lfcs-memory-worker.py
MemoryAccounting=yes
MemoryMax=32M
Restart=on-failure
RestartSec=2
[Install]
WantedBy=multi-user.target
UNIT
systemctl daemon-reload
systemctl enable --now lfcs-memory.service
BOOTSTRAP_ROOT
ASTRONA_STUDENT_SCRIPT
