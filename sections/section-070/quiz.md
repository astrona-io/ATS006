# Section 070 Knowledge Check: Service Configuration

Test your understanding of systemd unit authorship, safe vendor-unit overrides via `systemctl edit`, and the SSL certificate lifecycle with `openssl`.

---

## Scenario-Based Questions

### Question 1
You write a new unit file to wrap a script that pushes data to a remote API on startup. You want it to start only once the network is *actually usable*, not merely once interfaces are configured, and you want that dependency to be a real boot dependency rather than ordering alone. Which pair of directives in `[Unit]` correctly achieves this?
*   **A)** `After=network.target` only
*   **B)** `Requires=network.target` only
*   **C)** `After=network-online.target` and `Wants=network-online.target`
*   **D)** `Before=network-online.target` and `Requires=network.target`

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: C**

*   **Why C is correct:** `network-online.target` is only reached once a network-management service actively reports at least one interface as genuinely usable, which is the correct target for anything making outbound connections at startup. `After=` alone is ordering-only and does not cause the target to actually be pulled into the boot sequence — pairing it with `Wants=` is what actually requests that the target be started, giving you both a real dependency and correct ordering.
*   **Why others are incorrect:**
    *   *Option A* is incorrect because `network.target` is reached very early and only means the network stack has been configured, not that a working connection exists — this is the classic mistake that causes intermittent failures right after boot.
    *   *Option B* is incorrect because it targets the wrong unit (`network.target`, not the online variant) and `Requires=` alone still doesn't include an `After=` ordering guarantee — without ordering, both could be told to start with no guarantee about which comes first.
    *   *Option D* is incorrect because `Before=` reverses the intended ordering entirely (it would tell systemd this unit should start *before* `network-online.target`, the opposite of what's needed), and it references the wrong target for the `Requires=` pairing.
</details>

---

### Question 2
You create a new unit file at `/etc/systemd/system/report-agent.service`, then immediately run `sudo systemctl start report-agent.service` and it starts successfully. A week later, you edit the same file to change `Restart=no` to `Restart=on-failure`, then run `sudo systemctl restart report-agent.service` — but the unit still doesn't restart itself when it crashes. What is the most likely cause?
*   **A)** `Restart=on-failure` requires a `RestartSec=` value to also be set, or it's ignored.
*   **B)** `systemctl daemon-reload` was not run after the edit, so systemd is still using its previously cached, in-memory unit definition.
*   **C)** `Restart=` directives can only be set on the first `systemctl start` of a unit and are permanently locked afterward.
*   **D)** The unit file must be renamed for systemd to detect a change to its content.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** systemd caches unit definitions in memory after first reading them from disk. The very first `start` worked because nothing was cached yet for that unit name, but any *subsequent* edit requires `sudo systemctl daemon-reload` before systemd will notice the change — otherwise `restart` keeps using the stale, previously loaded definition. This is one of the most common sources of "I changed the file but nothing happened" confusion.
*   **Why others are incorrect:**
    *   *Option A* is incorrect because `Restart=on-failure` is fully functional on its own; `RestartSec=` only controls the delay between attempts and defaults to a short value if omitted, it does not gate whether `Restart=` applies at all.
    *   *Option C* is incorrect because unit files can be edited and reloaded as many times as needed; there is no such permanent lock.
    *   *Option D* is incorrect because systemd tracks units by their unit name and file path, not by triggering on a rename — `daemon-reload` is what makes it re-read the existing path's content.
</details>

---

### Question 3
`app-suite.service` is installed by a vendor package at `/usr/lib/systemd/system/app-suite.service`. You need it to restart automatically on failure without ever touching that vendor-owned file. You run `sudo systemctl edit app-suite.service` and add `Restart=on-failure` under `[Service]`. Where does this actually get written, and what happens to the vendor file?
*   **A)** It overwrites `/usr/lib/systemd/system/app-suite.service` directly with the new directive appended.
*   **B)** It creates `/etc/systemd/system/app-suite.service.d/override.conf`, layered on top of the vendor unit; the vendor file itself is never modified.
*   **C)** It creates a full duplicate unit at `/etc/systemd/system/app-suite.service` that completely replaces the vendor unit.
*   **D)** It stores the override inside `/run/systemd/system/`, which is discarded on every reboot.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** `systemctl edit <unit>` (without `--full`) creates a small drop-in override fragment, conventionally at `/etc/systemd/system/<unit>.d/override.conf`, that is layered on top of whatever systemd loads from the vendor location. The vendor file at `/usr/lib/systemd/system/` is never touched, which is exactly why the override survives future package upgrades.
*   **Why others are incorrect:**
    *   *Option A* describes directly hand-editing the vendor file, which is the unsafe behavior this mechanism specifically exists to avoid, and is not what `systemctl edit` does.
    *   *Option C* describes `systemctl edit --full`, a different subcommand that creates a complete standalone replacement unit rather than a small drop-in — the scenario asked for a drop-in-style override, not a full replacement.
    *   *Option D* is incorrect because `/run/systemd/system/` is a transient runtime location unrelated to `systemctl edit`'s default persistent drop-in behavior; the created override survives reboots.
</details>

---

### Question 4
A vendor unit's `[Service]` section already contains `ExecStart=/usr/sbin/widgetd`. You add a drop-in override containing only `ExecStart=/usr/sbin/widgetd --config /etc/widgetd/custom.conf`, expecting your custom flag to take effect. After `daemon-reload` and `restart`, the service does not behave as expected. What went wrong?
*   **A)** `ExecStart=` cannot be overridden by a drop-in under any circumstances.
*   **B)** The drop-in file was saved with the wrong extension, so systemd ignored it entirely.
*   **C)** `ExecStart=` accumulates as a list rather than being replaced outright; without a preceding bare `ExecStart=` line to clear the vendor unit's original value, both values are retained rather than the drop-in cleanly replacing the vendor's command.
*   **D)** Drop-in overrides only apply to directives inside `[Unit]`, never `[Service]`.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: C**

*   **Why C is correct:** `ExecStart=` is documented to append to an internal list rather than simply overwrite a prior value when specified again. The correct pattern is to first add a bare `ExecStart=` (no value) in the drop-in, which is special-cased to mean "clear everything accumulated so far, including from the vendor unit," and only then set the real replacement value on the following line. Skipping the clearing line is one of the most common drop-in mistakes.
*   **Why others are incorrect:**
    *   *Option A* is incorrect because `ExecStart=` absolutely can be overridden via a drop-in — it just requires the explicit clearing step that single-value directives like `Restart=` don't need.
    *   *Option B* is incorrect because the scenario describes a functioning drop-in (it loads and both values are retained by systemd) rather than a file systemd failed to parse or ignored outright.
    *   *Option D* is incorrect because drop-ins can add or override directives in any section the vendor unit uses, including `[Service]` — this is in fact the most commonly overridden section.
</details>

---

### Question 5
You generate a private key and a self-signed certificate for `payments.internal.example.com` using `-subj "/CN=payments.internal.example.com"` with no config file. The certificate loads fine into your service, but every modern browser and most TLS client libraries refuse to trust the hostname as valid, even after being told to trust the self-signed cert itself. What is the most likely root cause?
*   **A)** `-subj` cannot set the CN field, only the SAN field, so the CN was never actually set.
*   **B)** The certificate lacks a Subject Alternative Name (SAN) entry, since `-subj` only sets Distinguished Name attributes and SAN is a separate X.509 extension that requires a config file (or `-addext`).
*   **C)** Self-signed certificates can never include a working hostname under any circumstances.
*   **D)** The key size was too small to support hostname validation.

<details>
<summary><b>Reveal Correct Answer & Teacher's Explanation</b></summary>

**Correct Answer: B**

*   **Why B is correct:** Modern TLS clients, including all mainstream browsers, validate hostnames against the SAN extension and effectively ignore the legacy CN field. `-subj` only populates Distinguished Name attributes like CN, O, and C — it has no mechanism to attach X.509 extensions such as SAN. Attaching a SAN requires either an OpenSSL config file with `req_extensions`/`x509_extensions` pointing at a `subjectAltName` entry, or the `-addext` command-line shortcut (OpenSSL 1.1.1+).
*   **Why others are incorrect:**
    *   *Option A* is incorrect because `-subj` does successfully set CN — that's exactly what it's for — the problem is that CN alone is insufficient for modern hostname validation, not that CN wasn't set.
    *   *Option C* is incorrect because self-signed certificates can absolutely include a valid, trusted hostname once a proper SAN entry is present — trust in the issuing chain and hostname validation are separate, independent checks.
    *   *Option D* is incorrect because key size affects cryptographic strength, not which extensions are present on the certificate or how hostname validation is performed.
</details>
