# Wrapping a Script as a systemd Service — Unit Creation and Troubleshooting

Every sysadmin inherits at least one script like this: something useful, something that runs a loop forever, and something that somebody once launched by hand with `nohup ... &` and never touched again. It works, right up until the server reboots, or the process dies quietly at 3 AM, and nobody notices for three days because nothing was watching it.

systemd exists to close exactly that gap. Think of a plain script as a temp worker you personally have to keep an eye on — if they wander off, nobody stops them, and nobody calls you to say they're gone. A systemd service is that same worker hired on staff: there's a supervisor watching whether they're at their desk, a policy for what happens if they disappear, and a personnel file (the unit file) describing exactly how they're supposed to behave. Your job as the administrator is to write that personnel file correctly, and to know how to read the supervisor's incident log when something goes wrong.

## Anatomy of a Unit File

Every systemd service unit is a plain text file split into three sections. Imagine you're wrapping a nightly backup script, `/opt/backup/nightly-backup.sh`, as a proper service called `backup-agent.service`:

```ini
[Unit]
Description=Nightly Backup Agent
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=backupsvc
Group=backupsvc
ExecStart=/opt/backup/nightly-backup.sh
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```

### `[Unit]`: Metadata and Ordering

The `[Unit]` section describes what this unit *is* and where it fits relative to other units. `Description=` is purely human-readable — it shows up in `systemctl status` output and nowhere else functionally. `After=network-online.target` is where the subtlety begins.

`After=` is **ordering only**. It tells systemd "if both of us are going to start, start the other one first" — it does not, by itself, cause the other unit to be started at all. If nothing else pulls `network-online.target` into the boot sequence, a unit that only has `After=network-online.target` might start before networking is ready anyway, because the target it's ordered after never actually got activated. That's why `After=` is almost always paired with `Wants=` (or the stricter `Requires=`), which is the directive that actually says "pull this target in as something to start." `Wants=network-online.target` plus `After=network-online.target` together is the conventional, resilient pairing for anything that needs to make outbound network calls right at startup — a backup agent shipping data offsite, an API client, a metrics pusher.

It's also worth knowing the difference between `network.target` and `network-online.target` specifically. `network.target` is reached very early in boot and only means the network *stack* has been configured to the point systemd considers the subsystem "set up" — it says nothing about whether an interface actually has a route or a working connection yet. `network-online.target` is only reached once a network-management service (systemd-networkd, NetworkManager) actively reports at least one interface as genuinely usable. If your service makes a real network call on startup, `network-online.target` is the one you want — this exact substitution mistake is a classic source of intermittent "works on manual start, fails right after boot" bugs.

### `[Service]`: How the Process Actually Runs

`Type=simple` tells systemd the process launched by `ExecStart=` *is* the main service process — no forking, no separate PID file to track. `User=` and `Group=` are how you avoid running arbitrary scripts as root: create a dedicated, unprivileged system account for the service and run it as that account instead, so a bug in the script can't touch anything outside what that account actually needs.

`Restart=on-failure` is a policy directive, and the specific value matters. systemd supports several: `no` (default — never restart), `on-success`, `on-failure`, `on-abnormal`, `on-watchdog`, `on-abort`, and `always`. `on-failure` restarts the unit only when the process exits with a non-zero code or is killed by certain signals — a clean, intentional stop (`systemctl stop`) does *not* trigger a restart. `always` is broader — it restarts after *any* exit, including a deliberate stop, which is rarely what you actually want for something you expect to manage by hand sometimes. `RestartSec=5` adds a short delay between restart attempts, which matters more than it looks: without it, a script that crashes instantly on every launch would hammer the system in a tight restart loop.

### `[Install]`: What "Enabled" Actually Means

`WantedBy=multi-user.target` is read specifically by `systemctl enable`. When you run `systemctl enable backup-agent.service`, systemd looks at this line and creates a symlink for this unit inside `multi-user.target.wants/` — that symlink is the entire mechanism by which the unit gets started automatically on future boots. Nothing about `enable` starts the unit *right now*; nothing about `start` makes it survive a reboot. They are two independent axes:

| Command | Runs it now? | Survives reboot? |
|---|---|---|
| `systemctl start <unit>` | Yes | No |
| `systemctl enable <unit>` | No | Yes |
| `systemctl enable --now <unit>` | Yes | Yes |

A task that says "make sure it's running and comes back after a reboot" needs `enable --now`, or the two commands run separately — using only one of them is one of the most common ways to half-satisfy a requirement without realizing it.

## The Step That's Easy to Forget: `daemon-reload`

systemd keeps unit definitions cached in memory after it first reads them from disk. Write a brand-new unit file and `systemctl start` it immediately, and it works — because systemd hadn't loaded anything for that unit name before, so there's nothing stale to conflict with. But edit that same unit file again later — change `Restart=`, add a directive, fix a typo — and `systemctl restart` will silently keep using the *old*, already-cached definition, completely ignoring your edit, until you run:

```bash
sudo systemctl daemon-reload
```

This single command re-reads every unit file from disk into systemd's in-memory cache. Make it reflexive: any time you touch a unit file, `daemon-reload` comes immediately after, before you try to start or restart anything. Skipping it is the single most common cause of "I changed the file but nothing happened" confusion.

Before committing to a `start`, it's also worth running a cheap syntax check:

```bash
sudo systemd-analyze verify backup-agent.service
```

`systemd-analyze verify` parses the unit and reports syntax errors or unknown directives without ever starting the service — catching a misspelled directive name before you waste time debugging a "failure" that was actually just a typo.

## Diagnosing a Unit That Won't Start

When `systemctl status` reports a unit as `failed` (or stuck cycling through `activating (auto-restart)`), resist the urge to immediately start editing the unit file. The very first move is always:

```bash
journalctl -u backup-agent.service -b
```

`-u <unit>` filters to just this unit's log lines; `-b` limits to the current boot. `systemctl status` itself shows only the last handful of log lines plus a systemd-level summary line like `Main process exited, code=exited, status=1/FAILURE` — that `status=1` is the *application's own* exit code, meaningful only in the context of that specific program's documentation, while the `code=` portion tells you *how* the process ended (a normal exit versus being killed by a signal). The full `journalctl` output almost always contains the actual error the application printed — a missing file, a permission error, a config problem — that `status` alone truncates away.

Two exit conditions are worth recognizing by sight:

- **`status=203/EXEC`** — systemd couldn't even execute the command in `ExecStart=`. Usually a missing execute permission on the script, or an interpreter path in the shebang line that doesn't exist on this system. Confirm by running the exact command manually as the service's own user: `sudo -u backupsvc /opt/backup/nightly-backup.sh` — this almost always reproduces the same failure interactively, with a much clearer error.
- **Repeating "start request repeated too quickly" cycling** — the process is crashing immediately on every launch attempt, and systemd's built-in rate-limiting has kicked in. Look at `journalctl` for whatever the script's own error output says on that first crash; the fix is almost never in the unit file itself, it's in whatever the application is actually failing to do.

## Self-Check and Verification

To prove you understand how to wrap a script as a proper systemd service:

1. Pick any long-running script on a test machine (or write a trivial one that loops and sleeps).
2. Create a dedicated system user for it with `useradd --system --no-create-home --shell /usr/sbin/nologin`.
3. Write a unit file with `[Unit]`, `[Service]`, and `[Install]` sections that runs the script as that user, restarts it `on-failure`, and orders it after `network-online.target` using both `After=` and `Wants=`.
4. Run `sudo systemd-analyze verify <unit>` before starting anything, then `sudo systemctl daemon-reload` and `sudo systemctl enable --now <unit>`.
5. Confirm with `systemctl is-active <unit>` and `systemctl is-enabled <unit>` that both report the expected state.
6. Kill the running process manually (`sudo pkill -f <script-name>`) and confirm with `systemctl status` that it comes back on its own, proving `Restart=on-failure` actually works.
7. Deliberately break the unit (typo the `ExecStart=` path), reload, try to start it, and practice diagnosing the failure through `journalctl -u <unit> -b` before touching the file again.
