#!/usr/bin/env bash
# Bootstrap: formats and mounts the extraDisk at /var/log/reporting-app,
# seeds three legitimate rotated log files (the visible data du can
# actually see), and installs+starts a reporting-app.service that opens
# a log file, immediately unlinks it, and keeps writing through the
# held-open descriptor -- reproducing the classic df-vs-du deleted-open-
# file mismatch before the student ever logs in.
#
# IMPORTANT: astrona-cli's extraDisks are NOT guaranteed to land on any
# particular /dev/vdX letter -- this disk is resolved via its `serial`
# (set in config.yaml) through the kernel's stable
# /dev/disk/by-id/virtio-<serial> path instead.

set -eu

DISK=/dev/disk/by-id/virtio-lab061-disk1

for i in $(seq 1 30); do
  [ -e "$DISK" ] && break
  sleep 1
done

# by-id symlinks existing doesn't mean udev is fully done with the
# underlying device -- give it a moment to settle before mkfs.
sudo udevadm settle --timeout=30 || true

sudo mkfs.ext4 -q -F "$DISK"
sudo mkdir -p /var/log/reporting-app
sudo mount "$DISK" /var/log/reporting-app

# Legitimate, already-rotated log files -- this is the only data a
# directory walk (du) will ever be able to see.
sudo dd if=/dev/urandom of=/var/log/reporting-app/reporting-app.log.1 bs=1M count=4 2>/dev/null
sudo dd if=/dev/urandom of=/var/log/reporting-app/reporting-app.log.2 bs=1M count=4 2>/dev/null
sudo dd if=/dev/urandom of=/var/log/reporting-app/reporting-app.log.3 bs=1M count=4 2>/dev/null

sudo mkdir -p /var/lib/reporting-app

sudo tee /usr/local/bin/reporting-app.sh > /dev/null <<'EOS'
#!/usr/bin/env bash
# Simulates the "reporting-app" service writing its live log. Opens
# current.log, immediately unlinks it (so it no longer appears in any
# directory listing or du walk), and keeps writing through the held-open
# file descriptor -- this is the deleted-but-open-file mechanism the lab
# is built around. On its very first ever start it also backfills a
# large chunk of data to simulate the leak having already been running
# for a while before the student logs in; a marker file on the root
# filesystem (unaffected by this mount filling up) ensures later
# restarts skip that one-time seed, so restarting the service is a
# genuine, working fix rather than something that immediately re-fills
# the disk.
set -u
LOGFILE=/var/log/reporting-app/current.log
SEED_MARKER=/var/lib/reporting-app/.seeded

: > "$LOGFILE"
exec 9<>"$LOGFILE"
rm -f "$LOGFILE"

if [ ! -e "$SEED_MARKER" ]; then
  touch "$SEED_MARKER"
  dd if=/dev/zero bs=1M >&9 2>/dev/null || true
fi

while true; do
  date -Iseconds >&9 2>/dev/null || true
  sleep 5
done
EOS
sudo chmod +x /usr/local/bin/reporting-app.sh

sudo tee /etc/systemd/system/reporting-app.service > /dev/null <<'EOS'
[Unit]
Description=Internal reporting application (lab simulation)
After=local-fs.target

[Service]
ExecStart=/usr/local/bin/reporting-app.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOS

sudo systemctl daemon-reload
sudo systemctl enable --now reporting-app.service

# Give the service a moment to finish its one-time seed-fill before the
# student's session starts, so df already reads close to full.
sleep 5
