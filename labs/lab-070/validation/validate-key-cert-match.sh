#!/usr/bin/env bash
# Confirms the TLS private key and certificate are a cryptographically
# matching pair via RSA modulus comparison.

set -u

DIR=/opt/healthcheck/tls
KEY="$DIR/healthcheck.key"
CRT="$DIR/healthcheck.crt"

if [[ ! -f "$KEY" ]] || [[ ! -f "$CRT" ]]; then
  echo "FAIL: key and/or certificate missing, cannot compare"
  exit 1
fi

crt_modulus=$(openssl x509 -noout -modulus -in "$CRT" 2>/dev/null)
key_modulus=$(openssl rsa -noout -modulus -in "$KEY" 2>/dev/null)

if [[ -z "$crt_modulus" ]] || [[ -z "$key_modulus" ]]; then
  echo "FAIL: could not read modulus from key and/or certificate"
  exit 1
fi

if [[ "$crt_modulus" != "$key_modulus" ]]; then
  echo "FAIL: certificate modulus does not match private key modulus -- not a matching pair"
  exit 1
fi

echo "PASS: TLS private key and certificate are a matching pair"
exit 0
