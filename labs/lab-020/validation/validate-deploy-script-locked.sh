#!/usr/bin/env bash
set -u

SCRIPT=/srv/teamspace/bin/deploy.sh

mode=$(stat -c '%a' "$SCRIPT" 2>/dev/null)
if [ "$mode" != "700" ]; then
  echo "FAIL: $SCRIPT mode is '$mode', expected '700'"
  exit 1
fi

echo "PASS: $SCRIPT is locked down to owner-only (700)"
exit 0
