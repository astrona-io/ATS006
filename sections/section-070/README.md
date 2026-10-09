# Service Configuration: systemd Units & SSL Certificates

Astronaut, this section is about the stations on your ship that must always be staffed, and the badges they wear when they talk to the outside. Two very different jobs live here, and the exam expects you to be fluent in both.

The first job belongs to **systemd**, the ship's duty officer: it starts every station, watches it and restarts it. You will turn a plain, unwatched script into a real **service** with its own duty card, the **unit file**, and you will change a packaged service's behaviour with a sticky note on its card, a **drop-in override**, instead of editing the file the package owns. The second job belongs to `openssl`: almost every service you set up will one day need TLS (Transport Layer Security), and `openssl` makes the private key (the ship's secret seal), the certificate (its ID badge) and the CSR (certificate signing request, the badge application form).

None of this is trivia. A unit file with the wrong `Restart=` value, or an `After=` line that does not really pull in the network, passes a quick look and fails the first time the network is slow. A drop-in applied the wrong way (the `ExecStart=` trap above all) can add a second command instead of replacing the first. And a certificate without a SAN (Subject Alternative Name) entry is quietly rejected by almost every client today.

**Exam topics covered:** Create, configure and troubleshoot services; work with SSL certificates

---

## What You Will Master

- Writing a unit file from scratch with `[Unit]`, `[Service]` and `[Install]` sections to wrap a script.
- Why `After=` only orders units, and why it needs `Wants=` to pull in `network-online.target`.
- Running a service as a dedicated system user, and choosing a `Restart=` policy and a `RestartSec=` delay.
- The difference between `start`, `enable` and `enable --now`, and why every unit file change needs `daemon-reload`.
- Diagnosing a unit that will not start with `journalctl -u <unit> -b`, including `status=203/EXEC` and a start rate limit.
- Changing a vendor unit with `systemctl edit` without touching the package-owned file, and when to use `--full`.
- How drop-ins merge: single values, additive `Environment=`, and clearing `ExecStart=` with an empty line.
- Applying an override with `restart`, proving it with `systemctl cat` and `systemctl show`, and undoing it with `systemctl revert`.
- Generating an RSA private key and locking it down with `chmod 600`.
- Writing an OpenSSL configuration file that carries a SAN, and making a self-signed certificate and a CSR from it.
- Reading a certificate's dates, subject and SAN, and proving a key and certificate match by their modulus.

---

## Modules In This Section

Work through the modules in this order. Each part teaches one idea. A mission (a graded lab) comes right after the part it practises, and the last page of each module is a wrap-up. The capstone at the end uses everything in the section at once.

### [Wrapping a Script as a systemd Service](module-01/course.md)

3 parts and 1 mission:

1. [Anatomy of a Unit File](module-01/course-01-anatomy-of-a-unit-file.md)
2. [Load, Start and Enable a Service](module-01/course-02-load-start-and-enable-a-service.md)
   - Mission: [systemd Unit Creation Lab](../../labs/lab-071/docs/question.md)
3. [Diagnose a Unit That Will Not Start](module-01/course-03-diagnose-a-unit-that-will-not-start.md)
4. [Wrap-Up: Mission Debrief](module-01/course-04-wrap-up.md)

### [Overriding a Vendor systemd Unit with systemctl edit](module-02/course.md)

2 parts and 1 mission:

1. [Write a Drop-In Override](module-02/course-01-write-a-drop-in-override.md)
2. [Apply, Prove and Revert an Override](module-02/course-02-apply-prove-and-revert-an-override.md)
   - Mission: [systemd Unit Override Lab](../../labs/lab-072/docs/question.md)
3. [Wrap-Up: Mission Debrief](module-02/course-03-wrap-up.md)

### [Working with SSL Certificates](module-03/course.md)

3 parts and 1 mission:

1. [Private Keys and Subject Alternative Names](module-03/course-01-private-keys-and-subject-alternative-names.md)
2. [Self-Signed Certificates and Signing Requests](module-03/course-02-self-signed-certificates-and-signing-requests.md)
3. [Read and Verify a Certificate](module-03/course-03-read-and-verify-a-certificate.md)
   - Mission: [SSL Certificate Generation Lab](../../labs/lab-073/docs/question.md)
4. [Wrap-Up: Mission Debrief](module-03/course-04-wrap-up.md)

### Knowledge check

Test your reasoning before the capstone: **[Section 070 Knowledge Check: Service Configuration](./quiz.md)**.

### Capstone

Your final mission for this section: **[Service Configuration Capstone Lab](../../labs/lab-070/docs/question.md)**. You wrap a health-check script as a service, change its restart delay with a drop-in, and give it a key and a self-signed certificate with a SAN.
