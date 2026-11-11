#!/usr/bin/env bash
# Match the account used by astrona ssh, including its home and permissions.
sudo -H -u student bash <<'ASTRONA_STUDENT_SCRIPT'
# OS preparation for PLAYGROUND - Shell Streams, Redirection and Exit Codes
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

sudo tee /usr/local/bin/backup-tool >/dev/null <<'EOF'
#!/usr/bin/env bash
echo "backup finished: 12 files copied"
echo "warning: 1 file skipped" >&2
exit 3
EOF
sudo chmod 0755 /usr/local/bin/backup-tool

as_learner mkdir -p "$LEARNER_HOME/streams-practice"

echo "[playground] ready. Try:  backup-tool   backup-tool > out.log   echo \$?"
ASTRONA_STUDENT_SCRIPT
