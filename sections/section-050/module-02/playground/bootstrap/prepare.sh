#!/usr/bin/env bash
# OS preparation for PLAYGROUND - Backups with tar
# Runs once when the environment comes up. It seeds a small practice scene.
# There is no task and no grading: poke at it freely.
set -euo pipefail

LEARNER=candidate
if ! id "$LEARNER" >/dev/null 2>&1; then
    sudo useradd -m -s /bin/bash "$LEARNER"
fi
LEARNER_HOME=$(getent passwd "$LEARNER" | cut -d: -f6)

as_learner() {
    sudo -u "$LEARNER" "$@"
}

sudo mkdir -p /srv/appdata/reports /srv/appdata/cache /backup
echo "application notes" | sudo tee /srv/appdata/notes.txt >/dev/null
echo "q1 report" | sudo tee /srv/appdata/reports/q1.txt >/dev/null
echo "q2 report" | sudo tee /srv/appdata/reports/q2.txt >/dev/null
echo "temporary" | sudo tee /srv/appdata/cache/tmp-1.dat >/dev/null
echo "temporary" | sudo tee /srv/appdata/cache/tmp-2.dat >/dev/null
sudo chown -R "$LEARNER:$LEARNER" /srv/appdata /backup

echo "[playground] ready. Try:  tar -czf /backup/full.tar.gz --exclude=cache -C /srv appdata"
