#!/usr/bin/env bash
set -u

DIR=/opt/tls/internal-web-srv1
KEY="$DIR/internal.web-srv1.local.key"
CRT="$DIR/internal.web-srv1.local.crt"
CSR="$DIR/internal.web-srv1.local.csr"

# 1. Private key exists, is a valid 2048-bit RSA key, and is permission 600.
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

# 2. Certificate exists, valid ~365 days, correct CN and SAN.
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
if [[ "$subject" != *"internal.web-srv1.local"* ]]; then
  echo "FAIL: certificate subject does not contain internal.web-srv1.local (got: '$subject')"
  exit 1
fi

san=$(openssl x509 -in "$CRT" -noout -text 2>/dev/null | grep -A1 "Subject Alternative Name" | tail -1)
if [[ "$san" != *"DNS:internal.web-srv1.local"* ]]; then
  echo "FAIL: certificate SAN does not contain DNS:internal.web-srv1.local (got: '$san')"
  exit 1
fi

# 3. CSR exists and carries the matching SAN request.
if [[ ! -f "$CSR" ]]; then
  echo "FAIL: CSR not found at $CSR"
  exit 1
fi

csr_san=$(openssl req -in "$CSR" -noout -text 2>/dev/null | grep -A1 "Subject Alternative Name" | tail -1)
if [[ "$csr_san" != *"DNS:internal.web-srv1.local"* ]]; then
  echo "FAIL: CSR SAN does not contain DNS:internal.web-srv1.local (got: '$csr_san')"
  exit 1
fi

# 4. Key and certificate are a matching pair.
crt_modulus=$(openssl x509 -noout -modulus -in "$CRT" 2>/dev/null)
key_modulus=$(openssl rsa -noout -modulus -in "$KEY" 2>/dev/null)
if [[ -z "$crt_modulus" ]] || [[ "$crt_modulus" != "$key_modulus" ]]; then
  echo "FAIL: certificate modulus does not match private key modulus"
  exit 1
fi

echo "PASS: RSA key, SAN certificate, and CSR generated correctly and the key/cert pair matches"
exit 0
