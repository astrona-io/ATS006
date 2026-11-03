# Question

Solve this question on: `terminal`

Astronaut, your crew is promoting an internal health-check script into a properly watched service, and it will soon be reached over HTTPS. Complete three linked tasks.

## Part 1: Wrap the script as a systemd service

The script `/opt/healthcheck/healthcheck.sh` already exists and is executable. It loops forever and appends status lines to `/var/log/healthcheck/healthcheck.log`, but no service manages it yet.

1. Create a dedicated, non-root system user named `healthcheck`, with no login shell and no home directory. It must be a system account (user ID below 1000).
2. Make `/var/log/healthcheck` owned by `healthcheck:healthcheck`.
3. Create a systemd unit at `/etc/systemd/system/healthcheck.service` that:
   - runs `/opt/healthcheck/healthcheck.sh` with `ExecStart=`,
   - runs as `User=healthcheck` and `Group=healthcheck`,
   - restarts automatically on failure (`Restart=on-failure`),
   - is ordered after real network availability (`After=network-online.target` and `Wants=network-online.target`),
   - does **not** set `RestartSec=` itself: that value comes from Part 2.
4. Reload systemd, then enable and start the service.

## Part 2: Override the restart delay with a drop-in

The default restart delay is too fast for this service. Without editing `/etc/systemd/system/healthcheck.service`, use `systemctl edit healthcheck.service` to create a drop-in override under `/etc/systemd/system/healthcheck.service.d/` that sets `RestartSec=10`. Reload systemd and restart the service, so the new delay is in force on the running unit. The service must be active and enabled when you finish.

## Part 3: Issue a TLS key and certificate for the HTTPS endpoint

Work inside `/opt/healthcheck/tls`, which already exists and belongs to you. TLS (Transport Layer Security) needs a private key and a certificate:

1. Generate a 2048-bit RSA private key at `healthcheck.key` and restrict its permissions to `600`.
2. Generate a self-signed X.509 certificate at `healthcheck.crt`, valid for 365 days, with `CN=healthcheck.internal.local` and a SAN (Subject Alternative Name) entry `DNS:healthcheck.internal.local`.
3. Prove that the private key and the certificate are a matching pair by comparing their RSA modulus values.
