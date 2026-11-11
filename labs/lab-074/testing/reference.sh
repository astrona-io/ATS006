#!/usr/bin/env bash
set -euo pipefail
sudo openssl req -new -key /etc/nginx/tls/status.key -subj /CN=status.lab.internal -out /opt/lab-ca/status.csr
sudo openssl ca -batch -config /opt/lab-ca/ca.conf -in /opt/lab-ca/status.csr -out /etc/nginx/tls/status.crt -days 30
sudo nginx -t
sudo systemctl reload nginx
