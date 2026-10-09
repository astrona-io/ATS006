# Read and Verify a Certificate

Astronaut, a badge that looks fine can still be wrong: dated badly, missing a name, or stamped with a seal the ship no longer has. Before a service ever uses a certificate, read what is printed on it and prove it belongs to your private key. In TLS (Transport Layer Security) `openssl` does both, without any network at all.

The commands below need the private key `service.key`, the self-signed certificate `service.crt` and the certificate signing request `service.csr` in your current folder, all made for `grafana.internal.example.com`.

## Read a certificate's fields

`openssl x509` reads a certificate and prints the parts you ask for. Ask for one part at a time, and tell it not to print the whole encoded certificate.

### Dates: the validity window

Run:

```sh
openssl x509 -in service.crt -noout -dates
```

`-dates` prints `notBefore` and `notAfter`, the two fields that set the validity window. `-noout` stops `openssl` printing the raw PEM block (the encoded certificate text) itself. If you forget it, the whole certificate body lands in your terminal on top of the field you wanted.

### Subject and SAN

Now read the name fields and the SAN (Subject Alternative Name, the names printed on the badge):

```sh
openssl x509 -in service.crt -noout -subject
openssl x509 -in service.crt -noout -text | grep -A1 "Subject Alternative Name"
```

`-subject` shows the Distinguished Name, the name fields such as `CN=`. The SAN is further down in the full `-text` output, under the `X509v3 Subject Alternative Name` block. It is not part of the subject line, which is exactly why making a certificate with only `-subj` misses it.

### Check the SAN in the request

Run the same check on the CSR (the certificate signing request), with `openssl req` instead of `openssl x509`:

```sh
openssl req -in service.csr -noout -text | grep -A1 "Subject Alternative Name"
```

You should see the same `DNS:grafana.internal.example.com` entry that you put in `[alt_names]`, so the request asks for the same name as the certificate.

## Prove a key and a certificate match

A certificate carries a public key. A private key file holds the mathematical parts that belong to that same public key. For RSA keys, one of those parts is the **modulus**, and it is unique for each key pair. So you can pull the modulus out of both files and compare them.

### Compare the modulus hashes

Run:

```sh
openssl x509 -noout -modulus -in service.crt | openssl md5
openssl rsa   -noout -modulus -in service.key | openssl md5
```

The first line reads the modulus from the certificate, the second from the private key, and `openssl md5` turns each into a short hash. Identical hashes prove that the certificate's public key and the private key are the same key pair.

MD5 (Message Digest 5) is used here only as a quick way to compare two long values, not for any security property. This exact pair of commands is standard enough to learn by heart.

### Compare the modulus directly

An equivalent, slightly more direct check skips the hashing:

```sh
diff <(openssl x509 -noout -modulus -in service.crt) \
     <(openssl rsa   -noout -modulus -in service.key)
```

`diff` compares the two raw modulus lines. Empty output means they are identical.

### Why this check matters

This check matters more than it looks. Suppose someone generated the key again but forgot to generate the certificate again. You now have two files that each look perfectly valid on their own, and they fail together the moment a real service tries to use them. The modulus check catches that in a second.

> [!TIP]
> If the hashes differ, the usual cause is a key generated again after the certificate was made. Make the certificate again from the *current* key; do not make yet another key.

## Common pitfalls

> [!WARNING]
> - **Forgetting `-noout`.** The whole encoded certificate fills your terminal.
> - **Looking for the SAN in `-subject`.** It is an extension; find it in the `-text` output under `X509v3 Subject Alternative Name`.
> - **Comparing two certificate files by eye.** Two encoded blocks tell you nothing; compare the modulus.
> - **Reading `openssl md5` as security.** It is only a quick way to compare; the modulus is what proves the pair.
> - **Making a new key when the check fails.** Make the certificate again from the key you already have.

## Your mission: SSL Certificate Generation Lab

You can now make a key, a self-signed certificate with a SAN, and a CSR, and prove the key and certificate belong together. The mission asks you to do exactly that for the internal hostname `internal.web-srv1.local`.

Start the mission:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-073
```

Open a terminal on the lab machine:

```sh
astrona ssh ats-006-lab-073
```

Read the task in the [question](../../../labs/lab-073/docs/question.md) and solve it on your own first. When you think you are done, send it for grading:

```sh
astrona submit -c labs/lab-073
```

When the mission is done, remove it:

```sh
astrona destroy ats-006-lab-073
```
