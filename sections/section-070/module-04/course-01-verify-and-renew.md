# Verify and renew a service certificate

The playground's NGINX endpoint has an expired certificate signed by a private training CA. First inspect the certificate:

```bash
sudo openssl x509 -in /etc/nginx/tls/status.crt -noout -subject -issuer -dates -ext subjectAltName
```

The issuer identifies the signer, while the DNS subject alternative name identifies the service. `notBefore` and `notAfter` bound validity. A trusted issuer does not make an expired certificate valid.

Use the service hostname in the URL even though the request stays on this VM. `--resolve` sets a connection address while preserving the TLS server name and hostname check:

```bash
sudo curl --noproxy '*' --cacert /opt/lab-ca/ca.crt \
  --resolve status.lab.internal:8443:127.0.0.1 https://status.lab.internal:8443/
```

This request should fail against the initial fixture. `--cacert` supplies an authority to trust; `-k` disables verification and would conceal the fault. Check that the VM clock is sensible before interpreting validity errors.

The lab's `/opt/lab-ca/ca.conf` defines a `server` extension section containing `subjectAltName=DNS:status.lab.internal`, `extendedKeyUsage=serverAuth` and `basicConstraints=critical,CA:FALSE`. Inspect that named file before issuing anything. A CSR requests an identity; the signing policy decides which extensions the certificate receives.

```bash
sudo openssl req -new -key /etc/nginx/tls/status.key \
  -subj /CN=status.lab.internal -out /opt/lab-ca/status.csr
sudo openssl ca -batch -config /opt/lab-ca/ca.conf \
  -in /opt/lab-ca/status.csr -out /etc/nginx/tls/status.crt -days 30
sudo nginx -t
sudo systemctl reload nginx
```

The private key stays mode 600. Reusing it is appropriate for this expiry exercise; a suspected key compromise would require a new key and revocation handling. The CA signing key is colocated here only to make the sandbox self-contained.

Repeat the trusted request, then replace the CA path with `/opt/lab-ca/unrelated.crt`. The first must return the application body and the second must fail certificate verification. `openssl x509 -checkend 604800 -noout -in /etc/nginx/tls/status.crt` checks whether the on-disk certificate remains valid for seven days. It does not prove NGINX loaded that file; the live request checks the served certificate. Reboot and repeat to establish persistence.
