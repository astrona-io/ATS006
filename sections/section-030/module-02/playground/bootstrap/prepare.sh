#!/usr/bin/env bash
# OS preparation for PLAYGROUND - Shell History
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

as_learner tee "$LEARNER_HOME/.bash_history" >/dev/null <<'EOF'
ls -la
cd /var/log
tail -n 20 syslog
export API_TOKEN=made-up-token-123
df -h
systemctl status ssh
grep -c error /var/log/syslog
whoami
EOF

echo "[playground] ready. Try:  history | tail   echo \$HISTSIZE \$HISTCONTROL"
