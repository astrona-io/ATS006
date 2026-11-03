#!/usr/bin/env bash
# Bootstrap for lab-035: installs the manual pages, vim and nano, and creates the candidate user with a half-filled flight plan.
# It sets up the starting state only, never the graded result.
set -eu

LEARNER=candidate
if ! id "$LEARNER" >/dev/null 2>&1; then
    sudo useradd -m -s /bin/bash "$LEARNER"
fi
LEARNER_HOME=$(getent passwd "$LEARNER" | cut -d: -f6)

as_learner() {
    sudo -u "$LEARNER" "$@"
}

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
