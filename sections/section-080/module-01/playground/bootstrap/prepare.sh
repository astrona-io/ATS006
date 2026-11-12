#!/usr/bin/env bash
# Match the account used by astrona ssh, including its home and permissions.
sudo -H -u student bash <<'ASTRONA_STUDENT_SCRIPT'
set -euo pipefail
sudo -n bash <<'BOOTSTRAP_ROOT'
set -euo pipefail
apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y sysstat python3
install -d /usr/local/share/lfcs /opt/course
cat >/usr/local/bin/lfcs-cpu-worker.py <<'WORKER'
import hashlib
while True:
    hashlib.sha256(b'x' * 65536).digest()
WORKER
cp /usr/local/bin/lfcs-cpu-worker.py /usr/local/share/lfcs/cpu-worker.reference
cat >/etc/systemd/system/lfcs-cpu.service <<'UNIT'
[Unit]
Description=LFCS cpu diagnosis workload
[Service]
ExecStart=/usr/bin/python3 /usr/local/bin/lfcs-cpu-worker.py
CPUAccounting=yes
[Install]
WantedBy=multi-user.target
UNIT
systemctl daemon-reload
systemctl enable --now lfcs-cpu.service
BOOTSTRAP_ROOT
ASTRONA_STUDENT_SCRIPT
