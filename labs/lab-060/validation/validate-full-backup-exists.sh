#!/usr/bin/env bash
# Confirms /backup/audit-svc-full holds a full rsync copy of the three
# legitimate log files, taken BEFORE audit.log.4 was created -- so it
# must not contain audit.log.4.

set -u

FULL=/backup/audit-svc-full

for f in audit.log.1 audit.log.2 audit.log.3; do
  if [[ ! -f "$FULL/$f" ]]; then
    echo "FAIL: full backup exists - $FULL/$f is missing"
    exit 1
  fi
done

if [[ -e "$FULL/audit.log.4" ]]; then
  echo "FAIL: full backup exists - $FULL/audit.log.4 should not exist; the full backup must have been taken before audit.log.4 was created"
  exit 1
fi

echo "PASS: $FULL is a complete backup of the three legitimate logs, taken before audit.log.4 existed"
exit 0
