#!/usr/bin/env bash
set -euo pipefail
sudo openssl req -new -key /etc/nginx/tls/status.key -subj /CN=status.lab.internal -out /opt/lab-ca/status.csr
sudo openssl ca -batch -config /opt/lab-ca/ca.conf -in /opt/lab-ca/status.csr -out /etc/nginx/tls/status.crt -days 30
sudo nginx -t
sudo systemctl reload nginx
for attempt in $(seq 1 20); do
  if sudo curl --noproxy '*' --silent --show-error --fail --max-time 5 \
    --cacert /opt/lab-ca/ca.crt --resolve status.lab.internal:8443:127.0.0.1 \
    https://status.lab.internal:8443/; then
    exit 0
  fi
  sleep 1
done
exit 1
