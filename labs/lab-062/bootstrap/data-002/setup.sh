#!/usr/bin/env bash
# Bootstrap for the "data-002" VM: rsync destination host. Installs
# rsync/openssh and pre-creates /backup/appdata as if a previous (now
# stale) mirror already existed there, holding one file that no longer
# exists on data-001's source -- this is what the graded --delete sync
# must remove. Does NOT run any rsync commands itself.

set -eu

if ! command -v rsync >/dev/null 2>&1; then
  sudo apt-get update -y
  sudo apt-get install -y rsync
fi

if ! command -v sshd >/dev/null 2>&1; then
  sudo apt-get install -y openssh-server
fi

sudo mkdir -p /backup/appdata
echo "a report nobody has needed in years" | sudo tee /backup/appdata/decommissioned-report.txt > /dev/null
sudo mkdir -p /backup/snapshots

# data-001's static IP on the lab-net network -- so "ssh data-001" style
# hostname usage resolves without depending on the astrona runtime's own
# DNS conventions.
if ! grep -q '[[:space:]]data-001$' /etc/hosts; then
  echo "10.10.60.5 data-001" | sudo tee -a /etc/hosts >/dev/null
fi
