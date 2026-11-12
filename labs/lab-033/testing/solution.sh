#!/usr/bin/env bash
set -euo pipefail
cat >> ~/.bashrc <<'ALIASES'
alias ll='ls -alF'
alias rm='rm -i'
alias myip="hostname -I | awk '{print \$1}'"
ALIASES
rm ~/lab-artifact-to-delete.txt

