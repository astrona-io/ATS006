#!/usr/bin/env bash
# Match the account used by astrona ssh, including its home and permissions.
sudo -H -u student bash <<'ASTRONA_STUDENT_SCRIPT'
# Inspect protected state; user access checks select their target account explicitly.
sudo -n bash <<'GRADER_ROOT'
# Confirms tmp/ was excluded from the mirror entirely -- neither the
# directory nor its contents should exist on data-002.

set -u

if [[ -e /backup/appdata/tmp ]]; then
  echo "FAIL: tmp excluded - /backup/appdata/tmp exists but should have been excluded from the sync"
  exit 1
fi

echo "PASS: tmp/ was correctly excluded from the mirror"
exit 0
GRADER_ROOT
ASTRONA_STUDENT_SCRIPT
