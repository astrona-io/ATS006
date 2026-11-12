#!/usr/bin/env bash
# Match the account used by astrona ssh, including its home and permissions.
sudo -H -u student bash <<'ASTRONA_STUDENT_SCRIPT'
# Inspect protected state; user access checks select their target account explicitly.
sudo -n bash <<'GRADER_ROOT'
set -u

SCRIPT=/srv/teamspace/bin/deploy.sh

mode=$(stat -c '%a' "$SCRIPT" 2>/dev/null)
if [ "$mode" != "700" ]; then
  echo "FAIL: $SCRIPT mode is '$mode', expected '700'"
  exit 1
fi

echo "PASS: $SCRIPT is locked down to owner-only (700)"
exit 0
GRADER_ROOT
ASTRONA_STUDENT_SCRIPT
