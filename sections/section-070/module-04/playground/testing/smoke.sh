#!/usr/bin/env bash
set -eu
sudo nginx -t
systemctl is-active nginx
sudo openssl x509 -in /etc/nginx/tls/status.crt -noout -dates
