#!/usr/bin/env bash
set -euo pipefail
sudo -n bash <<'REFERENCE_ROOT'
set -euo pipefail
echo 'umask 027' >> /home/opsuser/.bash_profile
chown opsuser:opsuser /home/opsuser/.bash_profile
chmod 2770 /srv/teamspace/shared
chmod 700 /srv/teamspace/bin/deploy.sh
chmod 1777 /srv/teamspace/dropbox
cd /srv/teamspace/incoming
find . -maxdepth 1 -type f ! -newermt '2021-06-01' -delete
mkdir -p archive/small archive/large quarantine
find . -maxdepth 1 -type f -size -2k -exec mv {} archive/small/ \;
find . -maxdepth 1 -type f -size +8k -exec mv {} archive/large/ \;
find . -maxdepth 1 -type f -perm 0777 -exec mv {} quarantine/ \;
mkdir -p /srv/teamspace/releases/2026/q1
cp -p /srv/teamspace/release-src/app.conf /srv/teamspace/releases/2026/q1/
mv /srv/teamspace/release-src/old-release.txt /srv/teamspace/releases/2026/
ln /srv/teamspace/releases/2026/q1/app.conf /srv/teamspace/releases/app-hard.conf
ln -s 2026/q1 /srv/teamspace/releases/current
rm -r /srv/teamspace/release-src/tmp-build
chgrp -R ops /srv/teamspace/releases

REFERENCE_ROOT

