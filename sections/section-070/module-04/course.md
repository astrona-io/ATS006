# Certificate trust and expiry

A certificate can match its private key and still fail a client's checks. The client also checks the issuer chain, requested hostname and validity period. Practice those distinctions against a real HTTPS service.

<!-- astrona:playground -->

Read [verify and renew a service certificate](course-01-verify-and-renew.md), then complete the independent [TLS repair lab](../../../labs/lab-074/docs/question.md).

<!-- curriculum-practice -->
## Practice and assessment

- [TLS Trust and Expiry Repair](../../../labs/lab-074/docs/question.md): Diagnose certificate expiry separately from trust and hostname errors; Issue and deploy a certificate with a DNS SAN; Verify the live service and reject an unrelated authority.
- [Service Configuration Capstone Lab](../../../labs/lab-070/docs/question.md): Wrap a script as a systemd service that runs as its own non-root user; Change the restart delay with a drop-in override, not by editing the unit file; Issue a key and a self-signed certificate with a SAN and prove they match.
