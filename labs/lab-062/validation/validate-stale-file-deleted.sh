#!/usr/bin/env bash
# Match the account used by astrona ssh, including its home and permissions.
sudo -H -u student bash <<'ASTRONA_STUDENT_SCRIPT'
# Confirms the pre-existing stale file (seeded by bootstrap to simulate a
# previous, now-obsolete mirror) was removed by the --delete sync.

set -u

if [[ -e /backup/appdata/decommissioned-report.txt ]]; then
  echo "FAIL: stale file deleted - /backup/appdata/decommissioned-report.txt still exists; --delete was not used (or the mirror direction was reversed)"
  exit 1
fi

echo "PASS: the stale leftover file was correctly removed by the mirroring sync"
exit 0
ASTRONA_STUDENT_SCRIPT
