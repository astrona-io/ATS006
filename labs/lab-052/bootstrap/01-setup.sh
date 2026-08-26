#!/usr/bin/env bash
# Bootstrap: seeds /srv/appdata with a notes file, a stable reports file
# that never changes during the lab (used to prove the incremental backup
# skips unchanged files), and a disposable cache/ directory that must
# never be backed up. Does NOT create /backup, /restore, or perform any
# part of the graded backup/restore task itself. /etc is the VM's real
# configuration directory and is used as-is.

set -eu

sudo mkdir -p /srv/appdata/reports
sudo mkdir -p /srv/appdata/cache

cat <<'EOF' | sudo tee /srv/appdata/notes.txt > /dev/null
baseline inventory snapshot
EOF

cat <<'EOF' | sudo tee /srv/appdata/reports/2026-Q2-summary.csv > /dev/null
period,total_units,total_value
2026-Q2,18420,915230.50
EOF

echo "transient session data" | sudo tee /srv/appdata/cache/session-abc123.tmp > /dev/null
echo "transient session data" | sudo tee /srv/appdata/cache/session-def456.tmp > /dev/null

sudo chown -R root:root /srv/appdata
