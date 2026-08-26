#!/usr/bin/env bash
# Confirms the TLS private key and self-signed certificate for
# healthcheck.internal.local exist with the correct properties.

set -u

DIR=/opt/healthcheck/tls
KEY="$DIR/healthcheck.key"
CRT="$DIR/healthcheck.crt"

if [[ ! -f "$KEY" ]]; then
  echo "FAIL: private key not found at $KEY"
  exit 1
fi

key_perms=$(stat -c '%a' "$KEY" 2>/dev/null)
if [[ "$key_perms" != "600" ]]; then
  echo "FAIL: private key permissions are '$key_perms', expected '600'"
  exit 1
fi

key_bits=$(openssl rsa -in "$KEY" -noout -text 2>/dev/null | grep -m1 "Private-Key" | grep -oE '[0-9]+')
if [[ "$key_bits" != "2048" ]]; then
  echo "FAIL: private key is ${key_bits:-unknown} bits, expected 2048"
  exit 1
fi

if [[ ! -f "$CRT" ]]; then
  echo "FAIL: certificate not found at $CRT"
  exit 1
fi

not_before=$(openssl x509 -in "$CRT" -noout -startdate 2>/dev/null | cut -d= -f2)
not_after=$(openssl x509 -in "$CRT" -noout -enddate 2>/dev/null | cut -d= -f2)
if [[ -z "$not_before" ]] || [[ -z "$not_after" ]]; then
  echo "FAIL: could not read certificate validity dates"
  exit 1
fi

start_epoch=$(date -d "$not_before" +%s 2>/dev/null)
end_epoch=$(date -d "$not_after" +%s 2>/dev/null)
days_valid=$(( (end_epoch - start_epoch) / 86400 ))
if (( days_valid < 360 || days_valid > 370 )); then
  echo "FAIL: certificate validity is ${days_valid} days, expected ~365"
  exit 1
fi

subject=$(openssl x509 -in "$CRT" -noout -subject 2>/dev/null)
if [[ "$subject" != *"healthcheck.internal.local"* ]]; then
  echo "FAIL: certificate subject does not contain healthcheck.internal.local (got: '$subject')"
  exit 1
fi

san=$(openssl x509 -in "$CRT" -noout -text 2>/dev/null | grep -A1 "Subject Alternative Name" | tail -1)
if [[ "$san" != *"DNS:healthcheck.internal.local"* ]]; then
  echo "FAIL: certificate SAN does not contain DNS:healthcheck.internal.local (got: '$san')"
  exit 1
fi

echo "PASS: healthcheck.key and healthcheck.crt are correctly generated"
exit 0
