# Solution Walkthrough

You make a key, a self-signed certificate with a SAN (Subject Alternative Name) and a CSR (certificate signing request) for `internal.web-srv1.local`, then prove the key and certificate belong together. The grader checks the key's size and mode, the certificate's validity, subject and SAN, the SAN in the CSR, and that the key and certificate share one modulus.

## Step 1: Generate the key and lock it down

Move into the working folder, generate a 2048-bit RSA key, and restrict it at once:

```sh
cd /opt/tls/internal-web-srv1
openssl genrsa -out internal.web-srv1.local.key 2048
chmod 600 internal.web-srv1.local.key
```

A private key that other users can read defeats the point of having one, so `chmod 600` comes straight after the key.

## Step 2: Write a configuration file that carries the SAN

The SAN is an X.509 extension, not a Distinguished Name field, so `-subj` can never set it. A configuration file can. Save this as `openssl-internal.cnf` in `/opt/tls/internal-web-srv1`:

```ini
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
```

`req_extensions` is read when `openssl req` makes a CSR, and `x509_extensions` when it makes a self-signed certificate. Setting both lets one file serve the next two steps.

## Step 3: Generate the self-signed certificate

Use the file:

```sh
openssl req -new -x509 \
  -key internal.web-srv1.local.key \
  -out internal.web-srv1.local.crt \
  -days 365 \
  -config openssl-internal.cnf
```

`-x509` makes `openssl` sign the request itself and write a finished certificate instead of a request. Always pass `-days`: the default validity differs between builds and is often much shorter than you want.

## Step 4: Generate the CSR

Use the same key and the same file, without `-x509`:

```sh
openssl req -new \
  -key internal.web-srv1.local.key \
  -out internal.web-srv1.local.csr \
  -config openssl-internal.cnf
```

Dropping only `-x509` gives you an unsigned request instead of a finished certificate.

## Step 5: Check the certificate and the CSR

Then check the result:

```sh
openssl x509 -in internal.web-srv1.local.crt -noout -dates
openssl x509 -in internal.web-srv1.local.crt -noout -subject
openssl x509 -in internal.web-srv1.local.crt -noout -text | grep -A1 "Subject Alternative Name"
openssl req -in internal.web-srv1.local.csr -noout -text | grep -A1 "Subject Alternative Name"
```

`notBefore` and `notAfter` should be about 365 days apart. The subject should contain `internal.web-srv1.local`, and both the certificate and the CSR should show `DNS:internal.web-srv1.local` under `Subject Alternative Name`. Also check the key's mode with `stat -c '%a' internal.web-srv1.local.key`: it must print `600`.

## Step 6: Prove the key and certificate match

Compare the modulus of both files:

```sh
openssl x509 -noout -modulus -in internal.web-srv1.local.crt | openssl md5
openssl rsa   -noout -modulus -in internal.web-srv1.local.key | openssl md5
```

The two hashes must be identical: that proves a real pair. Comparing two encoded blocks by eye tells you nothing. If the hashes ever differ, the usual cause is a key generated again after the certificate was made. Make the certificate again from the *current* key, not a new key.

## Step 7: Submit

When every check looks right, send the lab for grading from your own machine:

```sh
astrona submit -c labs/lab-073
```
