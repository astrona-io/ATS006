# Certificate trust and expiry

A certificate can match its private key and still fail a client's checks. The client also checks the issuer chain, requested hostname and validity period. Practice those distinctions against a real HTTPS service.

<!-- astrona:playground -->

Read [verify and renew a service certificate](course-01-verify-and-renew.md), then complete the independent [TLS repair lab](../../../labs/lab-074/docs/question.md).
