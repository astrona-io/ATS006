#!/usr/bin/env bash
# Bootstrap: creates the "candidate" user with a home directory and bash
# login shell, and does NOT set any persistent umask override -- the
# system default (whatever /etc/login.defs or bash's built-in default is)
# is left in place. Setting the persistent 027 umask for candidate is the
# graded task, not something bootstrap should do.

set -eu

if ! id candidate >/dev/null 2>&1; then
  sudo useradd -m -s /bin/bash candidate
fi

# Ensure there's a login-shell startup file present (empty) so the
# student has an obvious, existing place to append their umask line --
# without pre-seeding any umask directive into it.
sudo touch /home/candidate/.bash_profile
sudo chown candidate:candidate /home/candidate/.bash_profile
