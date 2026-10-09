# Working with SSL Certificates

Astronaut, almost every station you set up will one day need to talk over an encrypted channel: an internal web service, an administration panel, a monitoring dashboard nobody wants on plain web traffic. That encryption is called **TLS** (Transport Layer Security, the newer name for SSL, Secure Sockets Layer). It needs two things on your ship: a secret seal, and an ID badge stamped with that seal.

The **private key** is the ship's secret seal: it never leaves the ship. The **certificate** is the ship's ID badge, stamped with that seal, saying "whoever holds the matching seal is who they claim to be". A **self-signed certificate** is a badge the ship stamped for itself. A **CSR** (certificate signing request) is the badge application form you send to a **certificate authority**, the badge office that stamps badges others trust. One tool makes every piece: `openssl`.

## Learning objectives

After this module you can:

- Generate a 2048-bit RSA private key with `openssl genrsa` or `openssl genpkey`, and lock it down with `chmod 600`.
- Explain why a certificate needs a SAN (Subject Alternative Name) entry, and why `-subj` cannot add one.
- Write an OpenSSL configuration file with `[req]`, `[dn]`, `[req_ext]` and `[alt_names]` sections.
- Generate a self-signed certificate with `openssl req -new -x509 ... -days 365`.
- Generate a CSR from the same key and configuration file by dropping `-x509`.
- Read a certificate's dates, subject and SAN with `openssl x509 -noout`.
- Prove that a key and a certificate are a matching pair by comparing their RSA modulus.

## Before you start

Every mission starts with a pre-flight check, astronaut. Make sure you have the knowledge this module expects and a machine to practise on.

### What you should already know

- **File permissions in octal.** `chmod 600 file` lets only the owner read and write the file, and nobody else anything.
- **How to save a file in the terminal**, for example with `nano` or `vim`.
- **What a hostname is**: the name a machine is reached by, such as `grafana.internal.example.com`.

### What you need

A terminal on an Ubuntu 24.04 machine with bash and `openssl`. A running lab machine works too: start one with `astrona run` and open a terminal on it with `astrona ssh`. Work in an empty folder of your own, so the files you create are easy to find and remove.

## How this module is laid out

1. [Private Keys and Subject Alternative Names](./course-01-private-keys-and-subject-alternative-names.md): generating the key, and the configuration file that carries the SAN.
2. [Self-Signed Certificates and Signing Requests](./course-02-self-signed-certificates-and-signing-requests.md): one `openssl req` command, two different results.
3. [Read and Verify a Certificate](./course-03-read-and-verify-a-certificate.md): reading the fields, and proving a key and a certificate belong together.
   - Mission: [SSL Certificate Generation Lab](../../../labs/lab-073/docs/question.md)
4. [Wrap-Up: Mission Debrief](./course-04-wrap-up.md)

## Why this matters

The exam asks you to produce working key and certificate files by hand. Small slips cause big failures: a key other users can read, a certificate without a SAN that every modern client quietly rejects, or a certificate made from an old key that will not work with the new one. This module shows you how to make each file and how to prove it is right before a service ever uses it.
