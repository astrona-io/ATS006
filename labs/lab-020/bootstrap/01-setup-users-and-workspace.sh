#!/usr/bin/env bash
# Bootstrap: creates the "ops" group and "opsuser" account with NO
# persistent umask override yet, and pre-stages the three shared-workspace
# targets with intentionally WRONG/incomplete permissions. The persistent
# umask, the setgid bit, the owner-only lockdown, and the sticky bit are
# all the student's graded task, not something bootstrap should apply.

set -eu

if ! getent group ops >/dev/null 2>&1; then
  sudo groupadd ops
fi

if ! id opsuser >/dev/null 2>&1; then
  sudo useradd -m -G ops -s /bin/bash opsuser
fi

# Ensure there's a login-shell startup file present (empty) so the
# student has an obvious, existing place to append their umask line --
# without pre-seeding any umask directive into it.
sudo touch /home/opsuser/.bash_profile
sudo chown opsuser:opsuser /home/opsuser/.bash_profile

# /srv/teamspace/shared: correct group ownership and base 770, but
# WITHOUT setgid -- the student must add the special bit.
sudo mkdir -p /srv/teamspace/shared
sudo chown root:ops /srv/teamspace/shared
sudo chmod 770 /srv/teamspace/shared

# /srv/teamspace/bin/deploy.sh: exists but far too permissive (664) --
# group-writable and world-readable, when it should end up owner-only.
sudo mkdir -p /srv/teamspace/bin
sudo tee /srv/teamspace/bin/deploy.sh > /dev/null <<'EOF'
#!/usr/bin/env bash
echo "deploying build to production..."
EOF
sudo chmod 664 /srv/teamspace/bin/deploy.sh

# /srv/teamspace/dropbox: world-writable (777) but WITHOUT the sticky
# bit -- the student must add it so team members can't delete each
# other's files.
sudo mkdir -p /srv/teamspace/dropbox
sudo chmod 777 /srv/teamspace/dropbox
