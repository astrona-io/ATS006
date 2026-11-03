#!/usr/bin/env bash
# OS preparation for PLAYGROUND - Creating a systemd Service
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

sudo tee /usr/local/bin/collector.sh >/dev/null <<'EOF'
#!/usr/bin/env bash
while true; do
    echo "collector tick at $(date -Is)" >> /var/log/collector.log
    sleep 5
done
EOF
sudo chmod 0755 /usr/local/bin/collector.sh
sudo touch /var/log/collector.log

echo "[playground] ready. Try:  sudo /usr/local/bin/collector.sh   (stop it with Ctrl+C)"
