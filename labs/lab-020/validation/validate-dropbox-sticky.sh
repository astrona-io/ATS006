#!/usr/bin/env bash
# Match the account used by astrona ssh, including its home and permissions.
sudo -H -u student bash <<'ASTRONA_STUDENT_SCRIPT'
set -u

DROPBOX=/srv/teamspace/dropbox

mode=$(stat -c '%a' "$DROPBOX" 2>/dev/null)
if [ "$mode" != "1777" ]; then
  echo "FAIL: $DROPBOX mode is '$mode', expected '1777' (sticky + 777)"
  exit 1
fi

echo "PASS: $DROPBOX has the sticky bit set (1777)"
exit 0
ASTRONA_STUDENT_SCRIPT
