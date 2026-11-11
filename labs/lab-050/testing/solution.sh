#!/usr/bin/env bash
set -euo pipefail
tar -tjf /exports/reports-2026-08.tar.bz2 | sort > /exports/reports-2026-08.tar.bz2_list
work=$(mktemp -d)
tar -xjf /exports/reports-2026-08.tar.bz2 -C "$work"
tar --use-compress-program='gzip -9' -cf /exports/reports-2026-08.tar.gz -C "$work" .
tar -tzf /exports/reports-2026-08.tar.gz | sort > /exports/reports-2026-08.tar.gz_list
rm -rf "$work"
sudo mkdir -p /backup
sudo tar -czpf /backup/services-full.tar.gz --listed-incremental=/backup/services.snar --exclude=opt/services/data/tmp -C / opt/services
echo "feature_flag=rollout-42" | sudo tee -a /opt/services/config/app.conf
echo "2026-Q3,pending" | sudo tee /opt/services/data/ledger-2026-Q3.csv
sudo tar -czpf /backup/services-incr.tar.gz --listed-incremental=/backup/services.snar --exclude=opt/services/data/tmp -C / opt/services
sudo mkdir -p /restore/services-full /restore/services-current
sudo tar -xzpf /backup/services-full.tar.gz -C /restore/services-full
sudo tar -xzpf /backup/services-full.tar.gz -C /restore/services-current
sudo tar -xzpf /backup/services-incr.tar.gz -C /restore/services-current

