# Question

Solve this question on: `terminal`

Astronaut, this ship runs `nginx.service`, installed by a package. The package owns its unit file, its duty card, and will reprint that file at the next upgrade. Change how the service behaves without touching the package's file:

1. Make the service restart automatically on failure: `Restart=on-failure` and `RestartSec=5`. Right now it does not restart at all.
2. Add an environment variable, `APP_ENV=production`, that the service process can see.
3. Apply both changes as a drop-in override under `/etc/systemd/system/nginx.service.d/`. Do **not** edit the vendor-shipped unit file at `/usr/lib/systemd/system/nginx.service`: it must stay byte-for-byte unchanged.
4. Reload systemd and restart `nginx`, so the changes take effect on the running process. The service must be running when you finish.
5. Confirm with `systemctl show` that the merged, effective configuration has both changes.
