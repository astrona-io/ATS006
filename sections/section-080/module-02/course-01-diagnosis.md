# Diagnose a service that exceeds its memory limit

A service may be killed for exceeding its own memory budget while the host still has free RAM. In the playground, inspect the assigned unit:

```sh
systemctl status lfcs-memory.service --no-pager
sudo journalctl -u lfcs-memory.service -n 40 --no-pager
systemctl show lfcs-memory.service -p MemoryCurrent -p MemoryMax -p NRestarts -p Result
free -h
```

The worker touches 64 MiB of memory, but its unit permits only 32 MiB. The kernel can kill it when that limit is reached. The restart policy then starts it again, producing a repeated failure. Read the journal and restart counter together; one `active` sample can catch a short interval between failures.

## Set a bounded budget

For a service named `batch.service`, a drop-in at `/etc/systemd/system/batch.service.d/resources.conf` can contain:

```ini
[Service]
MemoryHigh=96M
MemoryMax=128M
```

`MemoryHigh` is a pressure threshold: the kernel reclaims memory and slows allocations above it. `MemoryMax` is a hard ceiling that can cause an out-of-memory kill. Allow room for the interpreter and libraries as well as the application's data.

Run `sudo systemctl daemon-reload` and restart the service. Inspect `MemoryCurrent`, `MemoryHigh`, `MemoryMax`, and `NRestarts` again after a delay. The workload must remain alive and the restart counter must stop increasing. Reboot and repeat to verify the drop-in is persistent.

## Common pitfalls

> [!WARNING]
> Removing the ceiling can move the failure from one service to the whole machine. Keep a finite limit and verify the original workload instead of shrinking or replacing it.

## Your mission

Complete the [service diagnosis lab](../../../labs/lab-082/docs/question.md). It starts from a fresh VM; no playground state carries over.
