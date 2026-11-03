#!/usr/bin/env bash
# OS preparation for PLAYGROUND - Files, Links and Ownership
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

getent group loaders >/dev/null || sudo groupadd loaders
id loadmaster >/dev/null 2>&1 || sudo useradd -m -s /bin/bash -G loaders loadmaster

as_learner mkdir -p "$LEARNER_HOME/cargo/crates"
echo "manifest of the cargo hold" | as_learner tee "$LEARNER_HOME/cargo/manifest.txt" >/dev/null
echo "crew list" | as_learner tee "$LEARNER_HOME/cargo/crew.txt" >/dev/null
echo "crate one" | as_learner tee "$LEARNER_HOME/cargo/crates/one.txt" >/dev/null
echo "crate two" | as_learner tee "$LEARNER_HOME/cargo/crates/two.txt" >/dev/null
as_learner touch -d "2026-01-15 10:00" "$LEARNER_HOME/cargo/manifest.txt"

echo "[playground] ready. Try:  ls -la ~/cargo   ln ~/cargo/crew.txt ~/cargo/crew-hard.txt"
