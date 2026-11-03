#!/usr/bin/env bash
# OS preparation for PLAYGROUND - Archives and Compression
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

as_learner mkdir -p "$LEARNER_HOME/archive-practice/reports"
as_learner bash -c '
cd "$HOME/archive-practice"
echo "january totals" > reports/january.txt
echo "february totals" > reports/february.txt
echo "march totals" > reports/march.txt
tar -cjf sample.tar.bz2 reports
'

echo "[playground] ready. Try:  tar -tvf ~/archive-practice/sample.tar.bz2"
