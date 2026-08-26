# Section 070: Service Configuration: systemd Units & SSL Certificates

Welcome to Section 070. Two very different administrative problems live in this section, and the LFCS exam expects fluency in both.

The first problem: you have been handed a plain, unmanaged script — no restart-on-crash, no boot persistence, no clean way to see whether it's even alive. Turning that script into a real systemd service, and troubleshooting it when it refuses to start, is one of the single most common tasks a working Linux administrator performs. The second problem: a vendor package ships its own systemd unit, and you need to change its runtime behavior without editing the file the package manager owns — because a hand-edit is a landmine waiting for the next `apt upgrade`. And running alongside both: nearly every service you stand up eventually needs TLS, and `openssl` is the tool that generates the private key, the certificate, and the CSR that make that possible.

None of this is optional exam trivia. A unit file with the wrong `Restart=` value or an `After=` that doesn't actually create a dependency will pass a casual glance and fail the very first time the network is slow. A drop-in override applied incorrectly (the `ExecStart=` clearing gotcha, chief among them) can silently duplicate a directive rather than replace it. And a certificate generated without a SAN entry will be silently rejected by any TLS client that ignores the legacy CN field — which is effectively all of them today.

---

## What You Will Master

By completing this section, you will acquire three core service-configuration capabilities:
*   **Unit File Authorship:** How to write a correct `[Unit]`/`[Service]`/`[Install]` unit file from scratch to wrap an arbitrary script, and how to read `systemctl status` and `journalctl` to diagnose why a unit won't start.
*   **Safe Vendor Unit Overrides:** How to use `systemctl edit` to layer a drop-in override on top of a package-owned unit without ever touching the vendor file, including the non-obvious `ExecStart=` clearing behavior.
*   **SSL/TLS Certificate Lifecycle:** How to generate an RSA private key, a self-signed X.509 certificate with a proper SAN entry, and a CSR, and how to cryptographically prove a key and certificate are a matching pair.

---

## The Learning & Lab Path

This section is divided into three modules, each paired with a hands-on practice lab:

### 1. Wrapping a Script as a systemd Service
*   **Module Reader:** **[Module 1: Wrapping a Script as a systemd Service — Unit Creation and Troubleshooting](./module-01/course.md)**
*   **Associated Lab:** **[lab-071](../../labs/lab-071)**
*   **Lab Run Command:**
    ```bash
    astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-071
    ```
*   **Hands-on Objective:** Wrap an existing script as `metrics-collector.service`, running as a dedicated non-root user, restarting on failure, ordered correctly after real network availability, and enabled to survive a reboot.

### 2. Overriding a Vendor systemd Unit with systemctl edit
*   **Module Reader:** **[Module 2: Overriding a Vendor systemd Unit with systemctl edit](./module-02/course.md)**
*   **Associated Lab:** **[lab-072](../../labs/lab-072)**
*   **Lab Run Command:**
    ```bash
    astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-072
    ```
*   **Hands-on Objective:** Change a package-installed `nginx.service`'s restart behavior and inject an environment variable via a drop-in override, without editing the vendor-shipped unit file, then confirm the merge with `systemctl cat`.

### 3. Working with SSL Certificates
*   **Module Reader:** **[Module 3: Working with SSL Certificates — Keys, Self-Signed Certs, CSRs, and Verification](./module-03/course.md)**
*   **Associated Lab:** **[lab-073](../../labs/lab-073)**
*   **Lab Run Command:**
    ```bash
    astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-073
    ```
*   **Hands-on Objective:** Generate a 2048-bit RSA key, a SAN-bearing self-signed certificate, and a matching CSR for an internal hostname, then cryptographically verify the key/certificate pairing.

---

## Ready for Assessment?

Test your theoretical knowledge and diagnostic reasoning before tackling the capstone lab mission:

*   **[Take the Section 070 Knowledge Check Quiz](./quiz.md)**
