#!/usr/bin/env bash
# Match the account used by astrona ssh, including its home and permissions.
sudo -H -u student bash <<'ASTRONA_STUDENT_SCRIPT'
# OS preparation for PLAYGROUND - Environment Variables and Scope
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

if ! grep -q 'export SHIP_NAME=' "$LEARNER_HOME/.bashrc" 2>/dev/null; then
    echo 'export SHIP_NAME=odyssey' | as_learner tee -a "$LEARNER_HOME/.bashrc" >/dev/null
fi

sudo tee /usr/local/bin/show-env >/dev/null <<'EOF'
#!/usr/bin/env bash
echo "SHIP_NAME=${SHIP_NAME:-<unset>}"
echo "CREW_ROLE=${CREW_ROLE:-<unset>}"
EOF
sudo chmod 0755 /usr/local/bin/show-env

echo "[playground] ready. Try:  show-env   CREW_ROLE=pilot show-env   export CREW_ROLE=pilot"
ASTRONA_STUDENT_SCRIPT
