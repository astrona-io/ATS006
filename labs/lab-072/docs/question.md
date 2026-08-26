# Question

Solve this question on: `terminal` (playing the role of `app-srv1` from the scenario)

This host runs a vendor-packaged `nginx.service`. You're asked to change its runtime behavior:

1. Make it restart automatically on failure (`Restart=on-failure`, `RestartSec=5`) — it currently does not restart at all.
2. Add an extra environment variable, `APP_ENV=production`, that the service process should see.
3. Apply both changes as a proper drop-in override under `/etc/systemd/system/nginx.service.d/`, without editing the vendor-shipped unit file at `/usr/lib/systemd/system/nginx.service` directly — that file gets silently overwritten on the next package upgrade.
4. Reload systemd and restart `nginx` so the changes actually take effect on the running process.
5. Confirm with `systemctl show` that the merged, effective configuration reflects both changes, and that the vendor unit file itself remains byte-for-byte unmodified.
