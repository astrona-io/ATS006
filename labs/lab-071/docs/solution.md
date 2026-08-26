# Solution Guide: systemd Unit Creation

This guide walks through wrapping `/opt/metrics/collector.sh` as a supervised, boot-persistent systemd service.

---

## Step 1: Create the dedicated service user

```bash
sudo useradd --system --no-create-home --shell /usr/sbin/nologin metrics
```

A dedicated, unprivileged system account keeps the service from ever needing root, following least-privilege practice.

---

## Step 2: Fix ownership of the log directory

```bash
sudo chown metrics:metrics /var/log/metrics-collector
```

The script writes here as the `metrics` user, so the directory must be writable by that account, not just root.

---

## Step 3: Write the unit file

```bash
sudo tee /etc/systemd/system/metrics-collector.service > /dev/null << 'EOF'
[Unit]
Description=Metrics Collector Service
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=metrics
Group=metrics
ExecStart=/opt/metrics/collector.sh
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
```

`After=` plus `Wants=network-online.target` together order the unit after, and actually pull in, real network availability — `After=` alone would only affect ordering, not guarantee the target is started at all. `Restart=on-failure` restarts only on a crash, not a deliberate stop.

---

## Step 4: Reload systemd and start the service

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now metrics-collector.service
```

`daemon-reload` is required any time a unit file is created or edited — skip it and systemd keeps using a stale definition. `enable --now` satisfies both "running now" and "survives reboot" in one command.

---

## Step 5: Confirm the running state

```bash
systemctl is-active metrics-collector.service
systemctl is-enabled metrics-collector.service
systemctl show metrics-collector.service -p Restart -p User -p After
```

Expected: `active`, `enabled`, and the shown properties confirming `Restart=on-failure`, `User=metrics`, and `After=...network-online.target...` were actually loaded.

> **Note:** If the unit fails to start, don't start editing the file yet — run `journalctl -u metrics-collector.service -b` first. `systemctl status` truncates the log; the full journal almost always shows the actual error (a permission problem, a missing dependency) that a quick glance at `status` alone would miss.
