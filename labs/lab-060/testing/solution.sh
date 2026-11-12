#!/usr/bin/env bash
set -euo pipefail
sudo systemctl restart audit-svc
sudo rsync -a /var/log/audit-svc/ /backup/audit-svc-full/
echo 'new audit batch' | sudo tee /var/log/audit-svc/audit.log.4 >/dev/null
sudo rsync -a --link-dest=/backup/audit-svc-full /var/log/audit-svc/ /backup/audit-svc-snap2/

