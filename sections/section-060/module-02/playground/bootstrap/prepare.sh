#!/usr/bin/env bash
# Match the account used by astrona ssh, including its home and permissions.
sudo -H -u student bash <<'ASTRONA_STUDENT_SCRIPT'
# OS preparation for PLAYGROUND - Mirroring with rsync
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

# --- packages the module uses -----------------------------------------------
for package in rsync; do
    dpkg -s "$package" >/dev/null 2>&1 || sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "$package"
done

sudo mkdir -p /srv/appdata/reports /backup/appdata
echo "application notes" | sudo tee /srv/appdata/notes.txt >/dev/null
echo "q1 report" | sudo tee /srv/appdata/reports/q1.txt >/dev/null
echo "q2 report" | sudo tee /srv/appdata/reports/q2.txt >/dev/null
sudo chown -R "$LEARNER:$LEARNER" /srv/appdata /backup

echo "[playground] ready. Try:  rsync -av --dry-run /srv/appdata/ /backup/appdata/"
ASTRONA_STUDENT_SCRIPT
