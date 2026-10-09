# Wrap-Up: Mission Debrief

Well flown, astronaut. Your ship now has a secret seal, a badge with the right names on it, and an application form for the badge office, and you can prove the seal and the badge belong together. Look back at what you learned, check yourself, and land cleanly.

## What you learned

This module was about the files TLS (Transport Layer Security) needs, and how `openssl` makes and checks each one.

**From [Private Keys and Subject Alternative Names](./course-01-private-keys-and-subject-alternative-names.md):**

- `openssl genrsa -out service.key 2048` and `openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out service.key` both make a 2048-bit RSA key.
- Run `chmod 600` on the key straight away.
- Modern clients check the SAN (Subject Alternative Name), not the Common Name.
- The SAN is an extension, so `-subj` cannot set it. Use a configuration file (or `-addext` for one entry).
- `req_extensions` is read for a CSR, `x509_extensions` for a self-signed certificate.

**From [Self-Signed Certificates and Signing Requests](./course-02-self-signed-certificates-and-signing-requests.md):**

- `openssl req -new` without `-x509` makes a CSR (certificate signing request) for a certificate authority to sign.
- Adding `-x509` makes `openssl` sign it at once and write a self-signed certificate.
- Always set `-days`.

**From [Read and Verify a Certificate](./course-03-read-and-verify-a-certificate.md):**

- `openssl x509 -noout -dates`, `-subject` and `-text | grep -A1 "Subject Alternative Name"` read the dates, the subject and the SAN.
- `openssl req -in <file>.csr -noout -text` reads a CSR.
- Identical modulus hashes from `openssl x509 -noout -modulus` and `openssl rsa -noout -modulus` prove a key and certificate match; `diff` on the raw modulus does the same.

## Your missions

You proved the skill in a graded mission, right after the part that taught it:

| Mission | After the part | What you proved |
| --- | --- | --- |
| [SSL Certificate Generation Lab](../../../labs/lab-073/docs/question.md) | Read and Verify a Certificate | made a locked-down key, a self-signed certificate with a SAN and a CSR, and proved the key and certificate match |

If you skipped it, go back to it now. The exam asks for exactly this skill.

## Practise on your own

Run the whole chain once more from memory, for a hostname of your own choosing:

1. Generate a 2048-bit RSA key with `genrsa` or `genpkey`, then `chmod 600` it.
2. Write an OpenSSL configuration file with `[req]`, `[dn]`, `[req_ext]` and `[alt_names]` sections.
3. Generate a self-signed certificate valid for 365 days with `-new -x509` and your configuration file.
4. Generate a CSR for the same key and hostname, dropping only `-x509`.
5. Check the certificate's dates, subject and SAN, and the SAN in the CSR.
6. Prove the key and certificate match with the modulus hashes, then with `diff`.

## Check yourself

Try to answer each question before you open the answer.

<details>
<summary>1. In <code>openssl genrsa -out service.key 2048</code>, what is <code>2048</code>?</summary>

A positional argument: the key size in bits. It is not a flag.
</details>

<details>
<summary>2. Why does a certificate made with only <code>-subj "/CN=..."</code> fail in modern clients?</summary>

Modern clients check the SAN, and `-subj` only sets Distinguished Name fields. The SAN is an extension, so it needs a configuration file or `-addext`.
</details>

<details>
<summary>3. Your configuration file has <code>req_extensions = req_ext</code> but no <code>x509_extensions</code>. Which file misses the SAN?</summary>

The self-signed certificate. `req_extensions` is read for a CSR; `x509_extensions` is read for `-new -x509`.
</details>

<details>
<summary>4. What is the only change between the CSR command and the self-signed certificate command?</summary>

Adding `-x509` (plus `-days` for the validity, and an output file name for the certificate). Same key, same configuration file.
</details>

<details>
<summary>5. Why always pass <code>-days</code>?</summary>

Without it, OpenSSL uses a much shorter default that differs between builds and distributions.
</details>

<details>
<summary>6. Where do you find the SAN in a certificate?</summary>

In `openssl x509 -in <file> -noout -text`, under `X509v3 Subject Alternative Name`. It is not in the `-subject` line.
</details>

<details>
<summary>7. The modulus hashes of your key and certificate differ. What most likely happened, and what is the fix?</summary>

The key was generated again after the certificate was made. Make the certificate again from the current key.
</details>

## Clean up

Each mission runs in its own training ship. When you are done with this module, remove any mission that is still running.

First, see what is still running:

```sh
astrona list
```

Remove the mission. The command takes its **name**, not its folder path:

```sh
astrona destroy ats-006-lab-073
```

Then check that everything is gone:

```sh
astrona list
```

```text
No astrona labs running.
```

If you practised in a folder of your own, delete `service.key`, `service.crt`, `service.csr` and `openssl-service.cnf` when you are done. A private key you no longer need should not stay lying around.

> *Seal first, names in the configuration file, and the modulus to prove the pair.*
