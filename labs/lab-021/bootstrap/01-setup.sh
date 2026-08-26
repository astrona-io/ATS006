#!/usr/bin/env bash
# Bootstrap: creates the "analysts" group and a test member user, then
# pre-stages the three scenario targets with intentionally WRONG/incomplete
# permissions -- the setgid bit, the owner-only lockdown, and the sticky
# bit are the student's graded task, not something bootstrap should apply.

set -eu

if ! getent group analysts >/dev/null 2>&1; then
  sudo groupadd analysts
fi

if ! id someanalyst >/dev/null 2>&1; then
  sudo useradd -m -G analysts -s /bin/bash someanalyst
fi

# /srv/shared/reports: correct group ownership and base 770, but WITHOUT
# setgid -- the student must add the special bit.
sudo mkdir -p /srv/shared/reports
sudo chown root:analysts /srv/shared/reports
sudo chmod 770 /srv/shared/reports

# /opt/tools/backup-runner.sh: exists but far too permissive (664) --
# readable/writable by group and world-readable, when it should end up
# owner-only.
sudo mkdir -p /opt/tools
sudo tee /opt/tools/backup-runner.sh > /dev/null <<'EOF'
#!/usr/bin/env bash
echo "running nightly backup..."
EOF
sudo chmod 664 /opt/tools/backup-runner.sh

# /srv/shared/dropbox: world-writable (777) but WITHOUT the sticky bit --
# the student must add it so team members can't delete each other's files.
sudo mkdir -p /srv/shared/dropbox
sudo chmod 777 /srv/shared/dropbox
