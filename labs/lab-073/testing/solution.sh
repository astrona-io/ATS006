#!/usr/bin/env bash
set -euo pipefail
cd /opt/tls/internal-web-srv1
openssl genrsa -out internal.web-srv1.local.key 2048
chmod 600 internal.web-srv1.local.key
openssl req -new -x509 -key internal.web-srv1.local.key -out internal.web-srv1.local.crt -days 365 -subj /CN=internal.web-srv1.local -addext subjectAltName=DNS:internal.web-srv1.local
openssl req -new -key internal.web-srv1.local.key -out internal.web-srv1.local.csr -subj /CN=internal.web-srv1.local -addext subjectAltName=DNS:internal.web-srv1.local
