#!/usr/bin/env bash
set -euo pipefail
sudo -n bash <<'REFERENCE_ROOT'
set -euo pipefail
cd /var/backup/backup-015
find . -maxdepth 1 -type f ! -newermt '2020-01-01' -delete
mkdir -p small large compromised
find . -maxdepth 1 -type f -size -3k -exec mv {} small/ \;
find . -maxdepth 1 -type f -size +10k -exec mv {} large/ \;
find . -maxdepth 1 -type f -perm 0777 -exec mv {} compromised/ \;

REFERENCE_ROOT

