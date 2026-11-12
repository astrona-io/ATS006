#!/usr/bin/env bash
set -euo pipefail
sudo mkdir -p /backup
sudo tar -czpf /backup/full-backup.tar.gz --listed-incremental=/backup/snapshot.snar --exclude=srv/appdata/cache -C / etc srv/appdata
echo "Q3 restock complete" | sudo tee -a /srv/appdata/notes.txt
sudo touch /srv/appdata/new-shipment.csv
sudo tar -czpf /backup/incr-backup.tar.gz --listed-incremental=/backup/snapshot.snar --exclude=srv/appdata/cache -C / etc srv/appdata
sudo mkdir -p /restore/full /restore/incremental
sudo tar -xzpf /backup/full-backup.tar.gz -C /restore/full
sudo tar -xzpf /backup/full-backup.tar.gz -C /restore/incremental
sudo tar -xzpf /backup/incr-backup.tar.gz -C /restore/incremental

