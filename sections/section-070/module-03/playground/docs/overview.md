# Overview: PLAYGROUND - SSL Certificates with openssl

This is a **playground**, not a lab. The environment starts clean, runs
`bootstrap/prepare.sh`, and then waits. There is no task, no `astrona submit`,
and no pass or fail. Explore, break things, `astrona destroy`, start over.

## What is in the box

- A qemu Ubuntu 24.04 virtual machine, reached with `astrona ssh tls-playground`.
- `openssl` installed.
- An empty folder `~/tls-practice`.

## Things to try

- Create a private key and a self-signed certificate with a subject alternative name.
- Read the certificate with `openssl x509 -in <file> -noout -text`.
- Create a signing request and check that the key and certificate match.

## When you are done

```sh
astrona destroy tls-playground
```
