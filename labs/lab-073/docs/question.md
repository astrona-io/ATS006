# Question

Solve this question on: `terminal` (playing the role of `web-srv1` from the scenario)

Astronaut, an internal-only station needs TLS (Transport Layer Security) for the hostname `internal.web-srv1.local`. It needs a secret seal (a private key), an ID badge (a certificate) and a badge application form (a certificate signing request, or CSR). Work inside `/opt/tls/internal-web-srv1`, which already exists and belongs to you:

1. Generate a 2048-bit RSA private key at `internal.web-srv1.local.key` and restrict its permissions to `600`.
2. Generate a self-signed X.509 certificate at `internal.web-srv1.local.crt`, valid for 365 days, with `CN=internal.web-srv1.local` **and** a SAN (Subject Alternative Name) entry `DNS:internal.web-srv1.local`. The SAN entry is required: `-subj` alone cannot set it.
3. Separately, generate a CSR at `internal.web-srv1.local.csr` for the same key and hostname, with the same SAN request, as if you were sending it to an internal certificate authority.
4. Prove that the private key and the self-signed certificate are a matching pair by comparing their RSA modulus values.
