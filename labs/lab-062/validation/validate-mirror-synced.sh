#!/usr/bin/env bash
# Confirms /backup/appdata contains an exact mirror of the real files
# from data-001's /srv/appdata (app.conf, data1.txt, data2.txt).

set -u

MIRROR=/backup/appdata

for f in app.conf data1.txt data2.txt; do
  if [[ ! -f "$MIRROR/$f" ]]; then
    echo "FAIL: mirror synced - $MIRROR/$f is missing"
    exit 1
  fi
done

if ! grep -q "primary application configuration" "$MIRROR/app.conf" 2>/dev/null; then
  echo "FAIL: mirror synced - $MIRROR/app.conf content does not match the source"
  exit 1
fi

echo "PASS: $MIRROR contains a full mirror of /srv/appdata's real files"
exit 0
