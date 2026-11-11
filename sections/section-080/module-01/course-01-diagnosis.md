# Find the process before changing the limit

A VM can feel slow because it is using CPU, waiting for storage, or waiting for memory. Start with a timed sample:

```sh
vmstat 1 5
pidstat -u 1 5
```

`vmstat` shows runnable work in `r`, CPU time in `us` and `sy`, and I/O wait in `wa`. Its first line is an average since boot; use the following samples for the current incident. A high load average alone does not identify the cause.

`pidstat` shows per-process CPU use. Take the busy PID from that output and run `systemctl status <PID>` to find its service. Check `systemctl show <unit> -p MainPID -p CPUUsageNSec`. The CPU counter is cumulative; compare two readings across a known interval.

## Apply a service budget

For a service named `batch.service`, create `/etc/systemd/system/batch.service.d/resources.conf`:

```ini
[Service]
CPUQuota=25%
CPUAccounting=yes
```

Then run `sudo systemctl daemon-reload` and `sudo systemctl restart batch.service`. A 25% quota allows about one quarter of one CPU, even on a machine with multiple CPUs. It limits consumption; it does not make the application more efficient.

Inspect `systemctl show batch.service -p CPUQuotaPerSecUSec -p CPUUsageNSec`, then sample again. Keep the workload unchanged so the before/after measurement means something. Reboot and repeat to check the persistent setting.

## Common pitfalls

> [!WARNING]
> Stopping the service makes CPU use disappear but does not meet a task that requires it to keep working. A single sample or the first `vmstat` line can also mislead you.

## Your mission

Complete the [service diagnosis lab](../../../labs/lab-081/docs/question.md). It starts from a fresh VM; no playground state carries over.
