#!/usr/bin/env bash
# Confirms tmp/ was excluded from the mirror entirely -- neither the
# directory nor its contents should exist on data-002.

set -u

if [[ -e /backup/appdata/tmp ]]; then
  echo "FAIL: tmp excluded - /backup/appdata/tmp exists but should have been excluded from the sync"
  exit 1
fi

echo "PASS: tmp/ was correctly excluded from the mirror"
exit 0
