#!/usr/bin/env bash
# Match the account used by astrona ssh, including its home and permissions.
sudo -H -u student bash <<'ASTRONA_STUDENT_SCRIPT'
# OS preparation for PLAYGROUND - Diskspace Troubleshooting
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

sudo mkdir -p /srv/space-practice
sudo fallocate -l 50M /srv/space-practice/big.dat
sudo fallocate -l 20M /srv/space-practice/medium.dat
sudo fallocate -l 1M /srv/space-practice/small.dat
sudo chown -R "$LEARNER:$LEARNER" /srv/space-practice

command -v lsof >/dev/null || sudo DEBIAN_FRONTEND=noninteractive apt-get install -y lsof

sudo tee /usr/local/bin/log-hog >/dev/null <<'EOF'
#!/usr/bin/env bash
mkdir -p /var/log/log-hog
exec 3>>/var/log/log-hog/hog.log
rm -f /var/log/log-hog/hog.log
while true; do
    head -c 65536 /dev/zero >&3
    sleep 1
done
EOF
sudo chmod 0755 /usr/local/bin/log-hog

sudo tee /etc/systemd/system/log-hog.service >/dev/null <<'EOF'
[Unit]
Description=Practice service that holds a deleted log file open

[Service]
ExecStart=/usr/local/bin/log-hog
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable --now log-hog.service

echo "[playground] ready. Try:  df -h /   sudo lsof +L1"
ASTRONA_STUDENT_SCRIPT
