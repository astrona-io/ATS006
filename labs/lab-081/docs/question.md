# Diagnose and limit a CPU-heavy service

Allow 10–15 minutes for these tasks after VM startup. This lab runs independently from the playground.

1. Use `vmstat 1 5`, `pidstat -u 1 5`, and `systemctl status <PID>` to find the CPU-heavy service. Record its unit name in `/opt/course/cpu-service`.
2. Create a persistent drop-in that limits the service to 25% of one CPU. Keep the original workload running.
3. Reload systemd and restart the service. Measure CPU use over several seconds and confirm the quota remains after reboot.

The grader checks the live service, its finite budget, and the unchanged worker. CI repeats those checks after reboot.
