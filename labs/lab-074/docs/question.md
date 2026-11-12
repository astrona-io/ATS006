# Repair an expired TLS service

**Learner work: 10–15 minutes.** Package installation is separate from task time.

NGINX serves `status.lab.internal:8443` on this VM. The certificate has expired. The training CA is `/opt/lab-ca/ca.crt`; its signing key and configuration exist only in this disposable VM. A real CA would keep its signing key off the application host.

1. Inspect `/etc/nginx/tls/status.crt` for its issuer, subject, SAN and validity dates. Try a request with `curl --cacert`, `--resolve status.lab.internal:8443:127.0.0.1` and the HTTPS URL. Explain why adding the trusted CA alone does not fix expiry.
2. Generate a CSR using the existing private key `/etc/nginx/tls/status.key`. Issue a replacement through `/opt/lab-ca/ca.conf` with a 30-day lifetime. Preserve the DNS SAN and private-key mode 600.
3. Install the certificate at `/etc/nginx/tls/status.crt`, check NGINX configuration and reload the service. Verify the response `certificate service ready` using the lab CA and hostname. An unrelated CA at `/opt/lab-ca/unrelated.crt` must still fail verification. Keep verification enabled; do not use `curl -k`.
4. Reboot the VM and repeat the trusted request before submitting. The certificate must have at least seven days remaining.
<!-- curriculum-links -->

## Related lessons and assessment

Read [module-04](../../../sections/section-070/module-04/course.md).

The grader checks:

- Verify live TLS trust, hostname, lifetime and rejection of an unrelated authority.

Use the inspection commands in the solution to check your work. Submit when you have finished; submission ends this environment.
