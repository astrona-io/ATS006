# Solution Guide: SSL Certificate Generation

This guide generates a key, a SAN-bearing self-signed certificate, and a CSR for `internal.web-srv1.local`.

---

## Step 1: Move into the working directory and generate the key

```bash
cd /opt/tls/internal-web-srv1
openssl genrsa -out internal.web-srv1.local.key 2048
chmod 600 internal.web-srv1.local.key
```

Locking down permissions immediately matters — a world-readable private key defeats the entire point of having one.

---

## Step 2: Write a config file to carry the SAN extension

```bash
cat > openssl-internal.cnf << 'EOF'
[req]
default_bits       = 2048
prompt             = no
default_md         = sha256
distinguished_name = dn
req_extensions     = req_ext
x509_extensions    = req_ext

[dn]
C  = US
O  = Internal Lab
CN = internal.web-srv1.local

[req_ext]
subjectAltName = @alt_names

[alt_names]
DNS.1 = internal.web-srv1.local
EOF
```

SAN is an X.509 extension, not a Distinguished Name field, so `-subj` alone can never set it — a config file (or `-addext`) is required. `req_extensions` is read for CSRs, `x509_extensions` for self-signed certs; setting both covers both steps below from one file.

---

## Step 3: Generate the self-signed certificate

```bash
openssl req -new -x509 \
  -key internal.web-srv1.local.key \
  -out internal.web-srv1.local.crt \
  -days 365 \
  -config openssl-internal.cnf
```

`-x509` is what turns this into a finished, usable certificate instead of a request. Always pass `-days` explicitly — the OpenSSL default validity window varies by build and is often far shorter than intended.

---

## Step 4: Generate the CSR

```bash
openssl req -new \
  -key internal.web-srv1.local.key \
  -out internal.web-srv1.local.csr \
  -config openssl-internal.cnf
```

Same key, same config — dropping only `-x509` produces an unsigned request instead of a finished certificate.

---

## Step 5: Verify the certificate's fields

```bash
openssl x509 -in internal.web-srv1.local.crt -noout -dates
openssl x509 -in internal.web-srv1.local.crt -noout -subject
openssl x509 -in internal.web-srv1.local.crt -noout -text | grep -A1 "Subject Alternative Name"
```

---

## Step 6: Prove the key and certificate match

```bash
openssl x509 -noout -modulus -in internal.web-srv1.local.crt | openssl md5
openssl rsa   -noout -modulus -in internal.web-srv1.local.key | openssl md5
```

> **Note:** Identical hashes here are what prove a real pairing — visually comparing two PEM blocks tells you nothing. If the hashes ever don't match, the most common cause is the key having been regenerated after the certificate was created; the fix is to regenerate the certificate from the *current* key, not to generate a new key.
