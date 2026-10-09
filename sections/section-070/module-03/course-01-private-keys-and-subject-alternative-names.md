# Private Keys and Subject Alternative Names

Astronaut, before a ship can wear an ID badge, it needs a secret seal to stamp it with. In TLS (Transport Layer Security, the encryption behind HTTPS) that seal is the **private key**, and it never leaves the ship. This part makes a private key with `openssl`, locks it down, and then writes the configuration file that puts the right names on the badge.

## Generate the private key

`openssl` can make a key in two ways: an older command just for RSA (an encryption method named after its inventors Rivest, Shamir and Adleman), and a newer one that works for every key type. Both give you the same kind of file.

### The older command: `genrsa`

Run:

```sh
openssl genrsa -out service.key 2048
```

`genrsa` is the older key generator, made only for RSA. The `2048` here is a positional argument (the key size in bits), not a flag.

### The newer command: `genpkey`

Modern OpenSSL documentation points new work to a newer command that handles every key type:

```sh
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out service.key
```

`genpkey` can make RSA, EC (elliptic curve), Ed25519 and other key types through one shared set of options, which is why it is the forward-looking choice. `genrsa` still works and is very common in existing scripts and guides, so recognise both on sight. Either one writes a private key in PEM format (a text file that starts with a `-----BEGIN` line).

### Lock the key down at once

Straight after you generate the key, run:

```sh
chmod 600 service.key
```

Now only the owner can read or change the file. A private key that other users on the machine can read defeats the whole point of having one, like leaving the ship's seal on a public table. Depending on the tool version and your `umask` (the default lock setting on new files), a new file can end up readable by others. Set the mode yourself instead of trusting the default.

> [!TIP]
> Make `chmod 600` the very next command after every key you generate. Exam graders check the key's mode, and it costs nothing to do it straight away.

## The SAN problem: why `-subj` is not enough

A key alone is not a badge. The badge must name the ship, and modern clients only read one place for that name. This section explains which place, and why the quick `-subj` flag cannot fill it.

### Clients check the SAN, not the Common Name

A **Subject Alternative Name** (SAN) is the field that modern TLS clients, including every mainstream browser, actually check when they validate a hostname. Think of it as the names printed on the ship's badge.

The older Common Name (CN) field is effectively ignored by clients today. So a certificate without a SAN entry is quietly rejected in practice, even though it looks complete.

### `-subj` only sets name fields, not extensions

Here is the trap. A SAN is an X.509 **extension** (X.509 is the standard format for certificates), not a core part of the Distinguished Name, the set of name fields such as `CN=`, `O=` and `C=`.

OpenSSL's `-subj` command-line flag only sets those Distinguished Name fields. There is no way to attach an extension through `-subj` alone. Extensions need an OpenSSL configuration file.

## Write the OpenSSL configuration file

The configuration file holds the name fields and the SAN in one place. You write it once and use it for both a self-signed certificate and a signing request.

### Save the configuration file

Save this as `openssl-service.cnf`:

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
O  = Internal Services
CN = grafana.internal.example.com

[req_ext]
subjectAltName = @alt_names

[alt_names]
DNS.1 = grafana.internal.example.com
```

`openssl` reads this file only when you pass it with `-config openssl-service.cnf` to `openssl req`, which makes the certificate or the request.

### What each section does

Two lines let one file cover both uses:

- `req_extensions = req_ext` is read when `openssl req` makes a CSR (a certificate signing request): `-new` without `-x509`.
- `x509_extensions = req_ext` is read when `openssl req` makes a self-signed certificate directly: `-new -x509`.

The line `subjectAltName = @alt_names` points to a separate `[alt_names]` section that lists one or more `DNS.n = ...` entries. This extra step is what lets one file cleanly hold several SAN entries if a service ever needs more than one hostname.

### A shortcut for one SAN entry

Since OpenSSL 1.1.1 there is also a one-off shortcut for a single SAN entry without a full configuration file. Add this to the `openssl req` command line:

```text
-addext "subjectAltName=DNS:grafana.internal.example.com"
```

It is handy for quick, throwaway certificates. A configuration file scales better once you need more than one extension.

## Common pitfalls

> [!WARNING]
> - **Forgetting `chmod 600` on the key.** Do not trust the default mode; set it yourself.
> - **Reading `2048` in `genrsa` as a flag.** It is a positional argument: the key size in bits, at the end.
> - **Trusting the Common Name.** Modern clients check the SAN; a certificate without one is rejected.
> - **Trying to set the SAN with `-subj`.** `-subj` only sets name fields. Use a configuration file or `-addext`.
> - **Setting only `req_extensions`.** It is read for a CSR, not for a self-signed certificate; add `x509_extensions` too.
