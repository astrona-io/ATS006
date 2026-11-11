#!/usr/bin/env bash
set -euo pipefail
cat >> ~/.bashrc <<'HISTORY'
export HISTSIZE=5000
export HISTFILESIZE=10000
export HISTCONTROL=ignoreboth
export HISTTIMEFORMAT="%F %T  "
HISTORY
printf '%s\n' 'ssh admin@db-02.internal' > ~/recovered-ssh-command.txt
printf '%s\n' 'sudo systemctl restart nginx' > ~/command-before-ssh.txt

