#!/usr/bin/env bash
set -eu
cd /opt/tls/internal-web-srv1
openssl req -new -newkey rsa:2048 -nodes -keyout /tmp/other-test.key -out internal.web-srv1.local.csr -subj /CN=internal.web-srv1.local -addext subjectAltName=DNS:internal.web-srv1.local
