#!/usr/bin/env bash
# Bootstrap: pre-stages an existing, already-exported VARIABLE1 in the
# login user's .bashrc, exactly as the scenario assumes. The lab's own
# task is to build /opt/course/4/script.sh around this pre-existing
# variable -- bootstrap must not create the script itself.

set -eu

if ! grep -q '^export VARIABLE1=random-string$' "$HOME/.bashrc" 2>/dev/null; then
  echo 'export VARIABLE1=random-string' >> "$HOME/.bashrc"
fi
