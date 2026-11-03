#!/usr/bin/env bash
# OS preparation for PLAYGROUND - Overriding a systemd Unit
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
for package in nginx; do
    dpkg -s "$package" >/dev/null 2>&1 || sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "$package"
done

sudo systemctl enable --now nginx

echo "[playground] ready. Try:  systemctl cat nginx   sudo systemctl edit nginx"
