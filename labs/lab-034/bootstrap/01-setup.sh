#!/usr/bin/env bash
# Match the account used by astrona ssh, including its home and permissions.
sudo -H -u student bash <<'ASTRONA_STUDENT_SCRIPT'
# Bootstrap for lab-034: creates the candidate user and a data folder with a crew table, a visit log and two settings files.
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
Ivo,cook,1,130
Jo,pilot,2,20
EOF
as_learner tee "$LEARNER_HOME/data/visits.log" >/dev/null <<'EOF'
mars
luna
mars
titan
mars
luna
europa
mars
titan
luna
mars
europa
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
ASTRONA_STUDENT_SCRIPT
