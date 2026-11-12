#!/usr/bin/env bash
# Match the account used by astrona ssh, including its home and permissions.
sudo -H -u student bash <<'ASTRONA_STUDENT_SCRIPT'
# Inspect protected state; user access checks select their target account explicitly.
sudo -n bash <<'GRADER_ROOT'
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
GRADER_ROOT
ASTRONA_STUDENT_SCRIPT
