# Working with SSL Certificates — Keys, Self-Signed Certs, CSRs, and Verification

Almost every service you'll ever stand up eventually needs to speak TLS — an internal API, an admin panel, a monitoring dashboard nobody wants sitting on plain HTTP. `openssl` is the tool that produces every piece of the puzzle: the private key, a self-signed certificate for internal use, a CSR to hand to a real certificate authority, and the verification step that proves a key and a certificate actually belong together before you wire them into a service and watch it refuse to start.

Think of the private key as a physical house key you cut yourself, and the certificate as a notarized document saying "whoever holds the matching key is who they claim to be." A self-signed certificate is you notarizing that document yourself — fine for internal use where you already trust yourself, but not something a stranger's browser will trust by default. A CSR is the unsigned draft of that same document, handed to an actual notary (a Certificate Authority) to review and stamp before it becomes trusted more broadly.

## Generating the Private Key

```bash
openssl genrsa -out service.key 2048
```

`genrsa` is the older, RSA-specific key generator; the `2048` here is a positional argument (the key size in bits), not a flag. Modern OpenSSL documentation steers new usage toward the newer, algorithm-agnostic equivalent:

```bash
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out service.key
```

`genpkey` can produce RSA, EC, Ed25519, and other key types through one uniform interface, which is why it's the forward-looking choice — but `genrsa` still works, is extremely common in existing scripts and tutorials, and both are worth recognizing on sight. Either produces a PEM-encoded private key file. Immediately lock down its permissions:

```bash
chmod 600 service.key
```

A private key readable by other users on the system defeats the entire point of having one — this step is easy to forget under a default umask and should become reflexive immediately after generation, not an afterthought.

## The SAN Problem: Why `-subj` Isn't Enough

A Subject Alternative Name (SAN) is the field that modern TLS clients — including every mainstream browser — actually check when validating a hostname. The legacy Common Name (CN) field is effectively ignored by clients today, so a certificate without a SAN entry is a certificate that will be silently rejected in practice, even though it looks complete.

Here's the trap: SAN is an X.509 **extension**, not a core Distinguished Name attribute, and OpenSSL's `-subj` command-line flag only sets DN attributes (`CN=`, `O=`, `C=`, etc.) — there's no way to attach an extension through `-subj` alone. Extensions require an OpenSSL config file:

```bash
cat > openssl-service.cnf << 'EOF'
[req]
default_bits       = 2048
prompt             = no
default_md         = sha256
distinguished_name = dn
req_extensions     = req_ext
x509_extensions    = req_ext

[dn]
C  = US
O  = Internal Services
CN = grafana.internal.example.com

[req_ext]
subjectAltName = @alt_names

[alt_names]
DNS.1 = grafana.internal.example.com
EOF
```

Two directives matter for covering both use cases from one file: `req_extensions = req_ext` is read when generating a CSR (`-new` without `-x509`), while `x509_extensions = req_ext` is read when generating a self-signed certificate directly (`-new -x509`). The `subjectAltName = @alt_names` line points at a separate `[alt_names]` section listing one or more `DNS.n = ...` entries — this indirection is what lets a single config cleanly support multiple SAN entries if a service ever needs more than one hostname. Since OpenSSL 1.1.1, there's also a one-off shortcut for a single SAN entry without a full config file: `-addext "subjectAltName=DNS:grafana.internal.example.com"` on the command line — useful for quick, throwaway certificates, though a config file scales better once you need more than one extension.

## Self-Signed Certificate vs. CSR: Same Machinery, Different Output

Both come from the same `openssl req -new` command family, which builds a request structure — subject fields, the public key, requested extensions — and signs it. The difference is *who* signs it and what comes out the other end.

A CSR signs the request with only the *applicant's own* private key and stops there — it's an unsigned request waiting for an external CA to review and issue an actual certificate from it:

```bash
openssl req -new \
  -key service.key \
  -out service.csr \
  -config openssl-service.cnf
```

Adding `-x509` to the same invocation short-circuits that entire external step — OpenSSL immediately self-signs the request and emits a finished, usable certificate instead of a request:

```bash
openssl req -new -x509 \
  -key service.key \
  -out service.crt \
  -days 365 \
  -config openssl-service.cnf
```

Always specify `-days` explicitly. Without it, OpenSSL falls back to a much shorter default that varies by build and distro — fine for a five-minute test, a bad surprise for anything meant to last.

## Reading a Certificate's Fields

```bash
openssl x509 -in service.crt -noout -dates
```

`-dates` prints `notBefore` and `notAfter`, the two fields defining the validity window. `-noout` suppresses printing the raw PEM block itself — worth remembering, since forgetting it dumps the entire base64 certificate body to your terminal on top of whatever field you actually wanted.

```bash
openssl x509 -in service.crt -noout -subject
openssl x509 -in service.crt -noout -text | grep -A1 "Subject Alternative Name"
```

`-subject` surfaces the Distinguished Name; the SAN extension lives further down in the full `-text` dump, under the `X509v3 Subject Alternative Name` block specifically — it is not part of the subject line itself, which is exactly why `-subj`-only generation misses it.

## Proving a Key and Certificate Actually Match

A certificate embeds a public key. A private key file contains the mathematical components — for RSA, the modulus — that correspond to that same public key. Since the modulus is unique per keypair, extracting it from both files and comparing is a fast, standard, network-free way to prove a real pairing:

```bash
openssl x509 -noout -modulus -in service.crt | openssl md5
openssl rsa   -noout -modulus -in service.key | openssl md5
```

Identical hashes confirm the certificate's embedded public key and the private key's corresponding component are the same keypair. MD5 here is used purely as a quick equality-check digest — not for any cryptographic security property — and this exact idiom is standard enough to be worth memorizing outright. An equivalent, slightly more direct check skips the hashing step entirely:

```bash
diff <(openssl x509 -noout -modulus -in service.crt) \
     <(openssl rsa   -noout -modulus -in service.key)
```

An empty diff means the raw modulus lines are byte-identical. This check matters more than it looks — a certificate generated against an old key, after the key file was regenerated without also regenerating the certificate, will produce two files that both look perfectly valid on their own and fail to work together the moment they're wired into a real service.

## Self-Check and Verification

To prove you understand the SSL certificate lifecycle:

1. Generate a 2048-bit RSA private key with either `genrsa` or `genpkey`, then immediately `chmod 600` it.
2. Write an OpenSSL config file with `[req]`, `[dn]`, `[req_ext]`, and `[alt_names]` sections for a hostname of your choosing.
3. Generate a self-signed certificate valid for 365 days using `-new -x509` and your config file.
4. Generate a CSR for the same key and hostname, dropping only `-x509` from the previous command.
5. Confirm the certificate's `notBefore`/`notAfter` dates, subject, and SAN entry with `openssl x509 -noout -dates`, `-subject`, and `-text`.
6. Confirm the CSR requested the same SAN with `openssl req -in <file>.csr -noout -text | grep -A1 "Subject Alternative Name"`.
7. Prove the key and certificate match using the modulus-hash comparison, then confirm the same result with the `diff` shortcut.
