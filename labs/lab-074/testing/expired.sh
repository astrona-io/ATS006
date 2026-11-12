#!/usr/bin/env bash
set -eu
sudo cp /opt/lab-ca/expired.crt /etc/nginx/tls/status.crt
sudo systemctl restart nginx
