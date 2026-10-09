# Question

Solve this question on: `terminal`

Astronaut, this ship runs a metrics script that nobody watches. The script `/opt/metrics/collector.sh` already exists and is executable. It loops forever and appends a metrics line to `/var/log/metrics-collector/collector.log` every few seconds. Right now no service manages it: if it dies, nothing brings it back, and it does not start after a reboot.

Make systemd, the ship's duty officer, responsible for it:

1. Create a dedicated, non-root system user named `metrics`, with no login shell and no home directory. It must be a system account (user ID below 1000).
2. Make `/var/log/metrics-collector` owned by `metrics:metrics`, so the script can write there as that user.
3. Create a systemd service at `/etc/systemd/system/metrics-collector.service` that:
   - runs `/opt/metrics/collector.sh` with `ExecStart=`,
   - runs as `User=metrics` and `Group=metrics`,
   - restarts automatically on failure (`Restart=on-failure`),
   - only starts after the network is really usable, not just configured (`After=network-online.target` and `Wants=network-online.target`).
4. Reload systemd, then enable and start the service, so it is running now and comes back after a reboot.
