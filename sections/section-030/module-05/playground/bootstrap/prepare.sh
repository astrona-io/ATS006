#!/usr/bin/env bash
# Match the account used by astrona ssh, including its home and permissions.
sudo -H -u student bash <<'ASTRONA_STUDENT_SCRIPT'
# OS preparation for PLAYGROUND - Finding Help and Editing Files
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
for package in man-db manpages vim nano; do
    dpkg -s "$package" >/dev/null 2>&1 || sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "$package"
done

sudo mandb -q 2>/dev/null || true
as_learner tee "$LEARNER_HOME/flightplan.conf" >/dev/null <<'EOF'
# flight plan
destination=PLACEHOLDER
crew_size=4
fuel=PLACEHOLDER
route=PLACEHOLDER
checked=no
EOF

echo "[playground] ready. Try:  man -k password   vim ~/flightplan.conf"
ASTRONA_STUDENT_SCRIPT
