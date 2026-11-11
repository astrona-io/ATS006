#!/usr/bin/env bash
# Match the account used by astrona ssh, including its home and permissions.
sudo -H -u student bash <<'ASTRONA_STUDENT_SCRIPT'
# Bootstrap: pre-stages an existing, already-exported VARIABLE1 in the
# login user's .bashrc, exactly as the scenario assumes. The lab's own
# task is to build /opt/course/4/script.sh around this pre-existing
# variable -- bootstrap must not create the script itself.

set -eu
sudo install -d -o student -g student /opt/course/4

if ! grep -q '^export VARIABLE1=random-string$' "$HOME/.bashrc" 2>/dev/null; then
  echo 'export VARIABLE1=random-string' >> "$HOME/.bashrc"
fi
ASTRONA_STUDENT_SCRIPT
