# Solution Guide: Shell Semantics Integration Capstone

This guide walks through building a wrapper script that combines correct environment variable scope with correct stream redirection and exit code handling.

---

## Step 1: Inspect the probe's behavior first

Run it bare, once, with no environment set, to see the default (unhealthy) behavior on your terminal:

```bash
/usr/local/bin/service-probe
```

You should see a `PROBE_DIAG` line and a `PROBE_DEGRADED` line on stderr, and the command should exit non-zero (`echo $?` immediately after shows `9`).

---

## Step 2: Create the wrapper script

```bash
mkdir -p /opt/monitor
touch /opt/monitor/run-check.sh
chmod +x /opt/monitor/run-check.sh
```

---

## Step 3: Write the wrapper body

```bash
#!/usr/bin/env bash

CHECK_ID="nightly-001"
export PROBE_MODE=strict

/usr/local/bin/service-probe > /var/log/monitor/probe.out
/usr/local/bin/service-probe 2> /var/log/monitor/probe.err
/usr/local/bin/service-probe > /var/log/monitor/probe.combined 2>&1
/usr/local/bin/service-probe > /dev/null 2>&1
probe_exit=$?
echo "$probe_exit" > /var/log/monitor/probe.exit

exit "$probe_exit"
```

Walking through why each piece satisfies the task:

- `CHECK_ID="nightly-001"` is a plain, non-exported assignment — a shell variable local to this script's own process. Since `service-probe` runs as a separate child process, it never inherits an unexported variable, so `CHECK_ID` stays exactly where the task wants it: invisible to the probe.
- `export PROBE_MODE=strict` flags `PROBE_MODE` for inheritance before the probe is ever launched, so every subsequent invocation of `/usr/local/bin/service-probe` in this script sees it and runs in healthy mode.
- The first probe run redirects only stdout (`>`); stderr (the `PROBE_DIAG` line) is left alone and would print to the terminal if you ran this manually, but is not captured in `probe.out`.
- The second run redirects only stderr (`2>`), capturing `PROBE_DIAG` alone since this mode never writes `PROBE_OK` to stderr.
- The third run uses `> file 2>&1` — file redirection first, then `2>&1` — so both streams land in `probe.combined`. Reversing that order would silently drop stderr from the file.
- The fourth run discards both streams to `/dev/null` purely to keep the terminal clean while capturing `$?` on the very next line, with nothing run in between — redirecting output never changes the exit code's value.
- `exit "$probe_exit"` makes the wrapper's own exit status match the probe's, so a caller checking `$?` on the wrapper gets the same signal the probe produced.

> **Common trap:** exporting `CHECK_ID` "just to be safe" breaks the task — the probe would then print an extra `PROBE_WARN` line to stderr, corrupting both `probe.err` and `probe.combined`.

---

## Step 4: Run it and verify

```bash
/opt/monitor/run-check.sh
echo "wrapper exit code: $?"

cat /var/log/monitor/probe.out
cat /var/log/monitor/probe.err
cat /var/log/monitor/probe.combined
cat /var/log/monitor/probe.exit
```

Expected:

```text
wrapper exit code: 0
```

```text
PROBE_OK: service healthy under strict mode
```

```text
PROBE_DIAG: probe invoked with PROBE_MODE=strict
```

```text
PROBE_DIAG: probe invoked with PROBE_MODE=strict
PROBE_OK: service healthy under strict mode
```

```text
0
```
