# Solution Guide: Overriding nginx.service Safely

This guide shows how to change `nginx.service`'s restart behavior and environment without touching the vendor unit file.

---

## Step 1: Inspect the current, unmodified unit

```bash
systemctl cat nginx
systemctl show nginx -p Restart -p FragmentPath
```

`FragmentPath` confirms the base unit is loaded from a package-owned location (`/usr/lib/systemd/system/nginx.service`) — this is the file you will not touch.

---

## Step 2: Open a drop-in override

```bash
sudo systemctl edit nginx.service
```

Add:

```ini
[Service]
Restart=on-failure
RestartSec=5
Environment=APP_ENV=production
```

This creates `/etc/systemd/system/nginx.service.d/override.conf`. `Restart=` and `RestartSec=` are new directives the vendor unit doesn't set, so they apply cleanly with no conflict. `Environment=` is additive by design, so no clearing trick is needed for it either — unlike `ExecStart=`, which would require a bare `ExecStart=` line first if you were replacing it.

---

## Step 3: Reload and restart to apply

```bash
sudo systemctl daemon-reload
sudo systemctl restart nginx
```

A config-reload signal wouldn't apply `Restart=`/`Environment=` changes — those are properties systemd enforces about process supervision itself, so a full `restart` (not `reload`) is required.

---

## Step 4: Confirm the merge and the running state

```bash
systemctl cat nginx
systemctl show nginx -p Restart -p RestartUSec -p Environment
```

`systemctl cat` shows the vendor fragment followed by your `override.conf` fragment, in that order — the authoritative way to confirm the merge rather than mentally combining two files. `systemctl show` confirms systemd is actually enforcing the new values on the live unit right now.

---

## Step 5: Confirm the vendor file is untouched

```bash
sudo cat /usr/lib/systemd/system/nginx.service | grep -i restart
```

> **Note:** If you ever need to change `ExecStart=` (not required here), remember that it accumulates as a list rather than being replaced — a naive second `ExecStart=` line in a drop-in does not overwrite the vendor unit's original command. You'd need a bare `ExecStart=` line first to explicitly clear it before setting a replacement. This lab only touches `Restart=`, `RestartSec=`, and `Environment=`, none of which need that clearing step.
