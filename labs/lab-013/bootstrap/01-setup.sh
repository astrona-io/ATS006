#!/usr/bin/env bash
# Match the account used by astrona ssh, including its home and permissions.
sudo -H -u student bash <<'ASTRONA_STUDENT_SCRIPT'
# Bootstrap for lab-013: creates the candidate user, an inbox folder with text files and an empty scripts folder.
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

as_learner mkdir -p "$LEARNER_HOME/inbox/archive" "$LEARNER_HOME/scripts"
as_learner bash -c 'seq 1 2 > "$HOME/inbox/alpha.txt"; seq 1 5 > "$HOME/inbox/bravo.txt"; seq 1 9 > "$HOME/inbox/charlie.txt"; echo "service started" > "$HOME/inbox/service.log"'
ASTRONA_STUDENT_SCRIPT
