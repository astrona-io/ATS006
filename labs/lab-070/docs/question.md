# Question

Solve this question on: `terminal`

Your team is promoting an internal health-check script into a properly supervised service, and it will soon be exposed over HTTPS. You're asked to complete three linked tasks:

## Part 1: Wrap the script as a systemd service

There is an existing, executable script at `/opt/healthcheck/healthcheck.sh` that loops forever, appending status lines to `/var/log/healthcheck/healthcheck.log`, but it currently has no service management.

1. Create a dedicated, non-root system user named `healthcheck` (no login shell, no home directory).
2. Ensure `/var/log/healthcheck` is owned by `healthcheck:healthcheck`.
3. Create a systemd unit at `/etc/systemd/system/healthcheck.service` that:
   - Runs `/opt/healthcheck/healthcheck.sh` via `ExecStart=`.
   - Runs as `User=healthcheck` and `Group=healthcheck`.
   - Restarts automatically on failure (`Restart=on-failure`).
   - Orders after real network availability (`After=network-online.target` and `Wants=network-online.target`).
   - Does **not** itself set `RestartSec=` — that value is supplied separately in Part 2.
4. Reload systemd, then enable and start the service.

## Part 2: Override the restart delay with a drop-in — without editing the unit file

The default restart delay is too fast for this service. Without editing `/etc/systemd/system/healthcheck.service` directly, use `systemctl edit healthcheck.service` to create a drop-in override that sets `RestartSec=10`. Reload systemd and restart the service so the new delay actually takes effect on the running unit.

## Part 3: Issue a TLS key and certificate for the upcoming HTTPS endpoint

Working inside `/opt/healthcheck/tls` (already created for you):

1. Generate a 2048-bit RSA private key at `healthcheck.key` and restrict its permissions to `600`.
2. Generate a self-signed X.509 certificate at `healthcheck.crt`, valid for 365 days, with `CN=healthcheck.internal.local` and a SAN entry `DNS:healthcheck.internal.local`.
3. Prove the private key and certificate are a matching pair by comparing their RSA modulus values.
