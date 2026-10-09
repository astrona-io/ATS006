# Question

Solve this question on: `terminal`

Astronaut, this ship has a health-check crew member at `/usr/local/bin/service-probe`. What it reports depends entirely on the briefing pack (the environment) it is started with:

- If it sees an environment variable `PROBE_MODE` set to exactly `strict`, it prints `PROBE_OK: service healthy under strict mode` to **stdout** and exits `0`.
- Otherwise, it prints `PROBE_DEGRADED: strict mode not active` to **stderr** and exits `9`.
- On every run, in either mode, it prints a `PROBE_DIAG: probe invoked with PROBE_MODE=<value>` line to **stderr**.
- If it also sees an environment variable named `CHECK_ID` set to anything at all, it prints an extra `PROBE_WARN: unexpected CHECK_ID=<value> visible to probe (should be shell-local only)` line to **stderr**. This must never happen if you build the wrapper correctly.

Create a wrapper script at `/opt/monitor/run-check.sh` which, every time it runs:

1. Defines a variable `CHECK_ID` with the value `nightly-001`, available **only inside the wrapper script itself**. It must never be visible to `/usr/local/bin/service-probe` or any other child process. Write it as the plain line `CHECK_ID=nightly-001`.
2. Defines and **exports** a variable `PROBE_MODE` with the value `strict`, so that `/usr/local/bin/service-probe` runs in its healthy mode. Write it as the line `export PROBE_MODE=strict`.
3. Runs `/usr/local/bin/service-probe` so that:
   - Its stdout, and only its stdout, is written to `/var/log/monitor/probe.out`.
   - Its stderr, and only its stderr, is written to `/var/log/monitor/probe.err`.
   - Both streams combined are written to `/var/log/monitor/probe.combined`.
   - Its exit code is written, as a single number, to `/var/log/monitor/probe.exit`.
4. Exits itself with exactly the same exit code that `/usr/local/bin/service-probe` returned.

`/var/log/monitor` already exists and is writable by your user. Make the script executable. The grader runs your script itself and then checks every file.
