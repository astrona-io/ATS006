# Recover a service from a memory limit

Allow 10–15 minutes for these tasks after VM startup. This lab runs independently from the playground.

1. Inspect the service journal, `MemoryMax`, `MemoryCurrent`, and its restart counter. Explain why this process is killed even when the VM has free memory.
2. Create a persistent drop-in with `MemoryHigh=96M` and `MemoryMax=128M`. Keep the original worker and restart policy.
3. Reload systemd, restart the service, and check that it remains active without further restarts. Reboot and repeat the checks.

The grader checks the live service, its finite budget, and the unchanged worker. CI repeats those checks after reboot.
