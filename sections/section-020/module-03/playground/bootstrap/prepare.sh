#!/usr/bin/env bash
# Match the account used by astrona ssh, including its home and permissions.
sudo -H -u student bash <<'ASTRONA_STUDENT_SCRIPT'
# OS preparation for PLAYGROUND - Finding Files by Age, Size and Permission
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

sudo mkdir -p /srv/triage/logs /srv/triage/uploads /srv/triage/tmp
sudo chown -R "$LEARNER:$LEARNER" /srv/triage
as_learner bash -c '
cd /srv/triage
echo "fresh log" > logs/today.log
echo "older log" > logs/last-month.log;  touch -d "35 days ago" logs/last-month.log
echo "ancient log" > logs/last-quarter.log; touch -d "90 days ago" logs/last-quarter.log
echo "id,name" > uploads/old-report.csv; touch -d "60 days ago" uploads/old-report.csv
truncate -s 5M uploads/big-image.bin
truncate -s 2M uploads/medium-image.bin
: > tmp/empty.tmp
echo "scratch" > tmp/scratch.tmp
chmod 0666 tmp/scratch.tmp logs/last-month.log
'
echo "[playground] ready. Try:  find /srv/triage -type f -mtime +30   find /srv/triage -size +1M"
ASTRONA_STUDENT_SCRIPT
