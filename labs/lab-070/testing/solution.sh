#!/usr/bin/env bash
set -euo pipefail
sudo useradd --system --no-create-home --shell /usr/sbin/nologin healthcheck
sudo chown healthcheck:healthcheck /var/log/healthcheck
sudo tee /etc/systemd/system/healthcheck.service >/dev/null <<'REFERENCE_FILE'
[Unit]
Description=Healthcheck Service
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=healthcheck
Group=healthcheck
ExecStart=/opt/healthcheck/healthcheck.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
REFERENCE_FILE
sudo mkdir -p /etc/systemd/system/healthcheck.service.d
sudo tee /etc/systemd/system/healthcheck.service.d/override.conf >/dev/null <<'REFERENCE_FILE'
[Service]
RestartSec=10
REFERENCE_FILE
cd /opt/healthcheck/tls
openssl genrsa -out healthcheck.key 2048
chmod 600 healthcheck.key
cat >openssl-healthcheck.cnf <<'REFERENCE_FILE'
[req]
default_bits       = 2048
prompt             = no
default_md         = sha256
distinguished_name = dn
x509_extensions    = req_ext

[dn]
C  = US
O  = Internal Lab
CN = healthcheck.internal.local

[req_ext]
subjectAltName = @alt_names

[alt_names]
DNS.1 = healthcheck.internal.local
REFERENCE_FILE
openssl req -new -x509 -key healthcheck.key -out healthcheck.crt -days 365 -config openssl-healthcheck.cnf
sudo systemctl daemon-reload
sudo systemctl enable --now healthcheck.service

