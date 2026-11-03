#!/usr/bin/env bash
# Bootstrap for lab-024: creates the candidate user, the group loaders and a cargo folder with files, a scratch folder and a crates folder.
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

getent group loaders >/dev/null || sudo groupadd loaders

as_learner mkdir -p "$LEARNER_HOME/cargo/crates" "$LEARNER_HOME/cargo/scratch"
echo "manifest of the cargo hold" | as_learner tee "$LEARNER_HOME/cargo/manifest.txt" >/dev/null
echo "crew list" | as_learner tee "$LEARNER_HOME/cargo/crew.txt" >/dev/null
echo "last year's crew list" | as_learner tee "$LEARNER_HOME/cargo/old-crew.txt" >/dev/null
echo "crate one" | as_learner tee "$LEARNER_HOME/cargo/crates/one.txt" >/dev/null
echo "crate two" | as_learner tee "$LEARNER_HOME/cargo/crates/two.txt" >/dev/null
echo "junk" | as_learner tee "$LEARNER_HOME/cargo/scratch/junk.txt" >/dev/null

as_learner chmod 0664 "$LEARNER_HOME/cargo/manifest.txt"
as_learner touch -d "2026-01-15 10:00" "$LEARNER_HOME/cargo/manifest.txt"
