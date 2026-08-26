# Question

Solve this question on: `terminal` (playing the role of `app-srv1` from the scenario)

There is an existing, executable script at `/opt/metrics/collector.sh` that collects and appends metrics to `/var/log/metrics-collector/collector.log` on a loop, but it currently has no service management around it. You're asked to:

1. Create a dedicated, non-root system user named `metrics` (no login shell, no home directory).
2. Ensure `/var/log/metrics-collector` is owned by `metrics:metrics` so the script can write to it as that user.
3. Create a systemd service named `metrics-collector.service` at `/etc/systemd/system/metrics-collector.service` that:
   - Runs `/opt/metrics/collector.sh` via `ExecStart=`.
   - Runs as `User=metrics` and `Group=metrics`.
   - Restarts automatically on failure (`Restart=on-failure`).
   - Only starts after the network is actually usable, not just interface-up (`After=network-online.target` and `Wants=network-online.target`).
4. Reload systemd, then enable and start the service so it is both running now and will come back after a reboot.
