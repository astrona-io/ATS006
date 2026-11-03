#!/usr/bin/env bash
# OS preparation for PLAYGROUND - Comparing and Shaping Text
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

as_learner mkdir -p "$LEARNER_HOME/data"
as_learner tee "$LEARNER_HOME/data/crew.csv" >/dev/null <<'EOF'
name,role,deck,hours
Ana,pilot,2,310
Ben,engineer,4,120
Cleo,medic,3,45
Dev,engineer,4,210
Eli,pilot,2,95
Fay,cook,1,60
Gus,engineer,5,180
Hana,medic,3,75
EOF
as_learner tee "$LEARNER_HOME/data/visits.log" >/dev/null <<'EOF'
mars
luna
mars
titan
luna
mars
europa
titan
mars
luna
europa
mars
luna
titan
mars
EOF
as_learner tee "$LEARNER_HOME/data/settings-old.conf" >/dev/null <<'EOF'
ship_name=odyssey
speed=low
crew_limit=8
log_level=info
EOF
as_learner tee "$LEARNER_HOME/data/settings-new.conf" >/dev/null <<'EOF'
ship_name=odyssey
speed=high
crew_limit=10
log_level=info
alarm=on
EOF

echo "[playground] ready. Try:  sort -t, -k4 -n ~/data/crew.csv   diff -u ~/data/settings-old.conf ~/data/settings-new.conf"
