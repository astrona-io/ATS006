#!/usr/bin/env bash
# Match the account used by astrona ssh, including its home and permissions.
sudo -H -u student bash <<'ASTRONA_STUDENT_SCRIPT'
# OS preparation for PLAYGROUND - Permission Bits and Special Bits
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

getent group crew >/dev/null || sudo groupadd crew
id crewmate >/dev/null 2>&1 || sudo useradd -m -s /bin/bash -G crew crewmate

sudo mkdir -p /srv/chmod-practice/shared
sudo tee /srv/chmod-practice/notes.txt >/dev/null <<'EOF'
Crew notes for the next flight.
EOF
sudo tee /srv/chmod-practice/run-report.sh >/dev/null <<'EOF'
#!/usr/bin/env bash
echo "report generated on $(hostname)"
EOF
sudo chmod 0644 /srv/chmod-practice/notes.txt /srv/chmod-practice/run-report.sh
sudo chown -R "$LEARNER:$LEARNER" /srv/chmod-practice
sudo chgrp crew /srv/chmod-practice/shared
sudo chmod 0775 /srv/chmod-practice/shared

echo "[playground] ready. Try:  ls -l /srv/chmod-practice   chmod 755 /srv/chmod-practice/run-report.sh"
ASTRONA_STUDENT_SCRIPT
