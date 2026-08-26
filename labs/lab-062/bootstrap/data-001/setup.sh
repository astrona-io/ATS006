#!/usr/bin/env bash
# Bootstrap for the "data-001" VM: rsync source + SSH client role. Installs
# rsync/openssh and seeds /srv/appdata with a small working tree
# (including a tmp/ subdirectory that must be excluded from the sync),
# but does NOT run any rsync commands itself -- that's the graded task.

set -eu

if ! command -v rsync >/dev/null 2>&1; then
  sudo apt-get update -y
  sudo apt-get install -y rsync
fi

if ! command -v sshd >/dev/null 2>&1; then
  sudo apt-get install -y openssh-server
fi

sudo mkdir -p /srv/appdata/tmp
echo "primary application configuration" | sudo tee /srv/appdata/app.conf > /dev/null
echo "customer record batch 1" | sudo tee /srv/appdata/data1.txt > /dev/null
echo "customer record batch 2" | sudo tee /srv/appdata/data2.txt > /dev/null
echo "scratch space, must never be synced" | sudo tee /srv/appdata/tmp/scratch.tmp > /dev/null

# data-002's static IP on the lab-net network -- so "rsync ... data-002:..."
# and "ssh data-002" resolve without depending on the astrona runtime's
# own DNS conventions.
if ! grep -q '[[:space:]]data-002$' /etc/hosts; then
  echo "10.10.60.10 data-002" | sudo tee -a /etc/hosts >/dev/null
fi
