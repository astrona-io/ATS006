# Solution Walkthrough

This walkthrough builds a wrapper script that gets two things right at once: which variables the probe can see, and where each of the probe's signal lines ends up. The grader runs the wrapper, checks the lines that define the two variables, and reads all four files.

---

## Step 1: Inspect the probe's behaviour first

Run it once, with no special environment, to see its default (unhealthy) behaviour on your terminal:

```bash
/usr/local/bin/service-probe
```

Both lines come from stderr, and the probe reports the variable as unset:

```text
PROBE_DIAG: probe invoked with PROBE_MODE=unset
PROBE_DEGRADED: strict mode not active
```

Run `echo $?` straight after it, and you see `9`, the probe's exit code in this mode.

---

## Step 2: Create the script directory

```bash
mkdir -p /opt/monitor
```

If `mkdir` reports `Permission denied`, `/opt` belongs to root. Create the directory with `sudo mkdir -p /opt/monitor` and give it to your user with `sudo chown "$(whoami)" /opt/monitor`.

---

## Step 3: Write the wrapper

Save this as `/opt/monitor/run-check.sh`:

```bash
#!/usr/bin/env bash

CHECK_ID=nightly-001
export PROBE_MODE=strict

/usr/local/bin/service-probe > /var/log/monitor/probe.out
/usr/local/bin/service-probe 2> /var/log/monitor/probe.err
/usr/local/bin/service-probe > /var/log/monitor/probe.combined 2>&1
/usr/local/bin/service-probe > /dev/null 2>&1
probe_exit=$?
echo "$probe_exit" > /var/log/monitor/probe.exit

exit "$probe_exit"
```

Write the two variable lines exactly as shown, `CHECK_ID=nightly-001` and `export PROBE_MODE=strict`, without quotes: the grader looks for those exact lines.

Why each piece does its job:

- `CHECK_ID=nightly-001` is a plain assignment that is never exported: a shell variable that only the wrapper's own process sees. The probe runs as a separate child process, and a child never gets an unexported variable. So `CHECK_ID` stays where the task wants it, invisible to the probe.
- `export PROBE_MODE=strict` marks `PROBE_MODE` for children before the probe ever starts. Every run of `/usr/local/bin/service-probe` in this script sees it and runs in healthy mode.
- The first run redirects only stdout (`>`). The `PROBE_DIAG` line on stderr is not captured in `probe.out`.
- The second run redirects only stderr (`2>`). It captures only `PROBE_DIAG`, because in strict mode the probe writes `PROBE_OK` to stdout, not stderr.
- The third run uses `> file 2>&1`: file first, then `2>&1`. Bash reads redirections left to right, so both streams land in `probe.combined`. The reversed order would silently leave stderr out of the file.
- The fourth run sends both streams to `/dev/null`, only to keep the terminal clean, and the next line captures `$?` with nothing run in between. Redirecting output never changes the exit code.
- `exit "$probe_exit"` makes the wrapper's own exit code match the probe's, so a caller checking `$?` on the wrapper gets the same signal the probe sent.

A common trap: exporting `CHECK_ID` "just to be safe" breaks the task. The probe then prints an extra `PROBE_WARN` line to stderr, which ends up in both `probe.err` and `probe.combined`.

Apply it:

```bash
chmod +x /opt/monitor/run-check.sh
```

---

## Step 4: Run it and check the result

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

`probe.out` holds only the stdout line, `probe.err` only the stderr line with no `PROBE_WARN`, `probe.combined` holds both, and `probe.exit` holds `0`.

---

## Step 5: Submit

From your own computer, not the lab machine, send the lab for grading:

```bash
astrona submit -c labs/lab-010
```
