# Question

Solve this question on: `terminal` (playing the role of `web-srv1` from the scenario)

An internal-only service needs TLS for the hostname `internal.web-srv1.local`. Working inside `/opt/tls/internal-web-srv1` (already created for you), you're asked to:

1. Generate a 2048-bit RSA private key at `internal.web-srv1.local.key` and immediately restrict its permissions to `600`.
2. Generate a self-signed X.509 certificate at `internal.web-srv1.local.crt`, valid for 365 days, with `CN=internal.web-srv1.local` **and** a proper SAN entry (`DNS:internal.web-srv1.local`) — the SAN entry is required, not optional, since it can't be set through `-subj` alone.
3. Separately, generate a CSR at `internal.web-srv1.local.csr` for the same key and hostname (including the same SAN request), as if it were being submitted to an internal CA.
4. Prove the private key and the self-signed certificate are a matching pair by comparing their RSA modulus values.
