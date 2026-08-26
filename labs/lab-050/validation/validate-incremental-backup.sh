#!/usr/bin/env bash
set -u

FULL=/backup/services-full.tar.gz
INCR=/backup/services-incr.tar.gz
SNAP=/backup/services.snar

if [[ ! -f "$SNAP" ]]; then
  echo "FAIL: listed-incremental snapshot file $SNAP does not exist"
  exit 1
fi

if [[ ! -f "$INCR" ]]; then
  echo "FAIL: incremental backup $INCR does not exist"
  exit 1
fi

if sudo tar -tzf "$INCR" 2>/dev/null | grep -q 'opt/services/data/tmp'; then
  echo "FAIL: incremental backup $INCR contains opt/services/data/tmp -- it should have been excluded"
  exit 1
fi

full_size=$(stat -c %s "$FULL" 2>/dev/null)
incr_size=$(stat -c %s "$INCR" 2>/dev/null)
if [[ -z "$full_size" || -z "$incr_size" || "$incr_size" -ge "$full_size" ]]; then
  echo "FAIL: incremental backup ($incr_size bytes) is not smaller than the full backup ($full_size bytes) -- looks like a second full copy, not a true incremental"
  exit 1
fi

if ! sudo tar -tzf "$INCR" 2>/dev/null | grep -q 'opt/services/config/app.conf$'; then
  echo "FAIL: incremental backup $INCR does not contain the changed file opt/services/config/app.conf"
  exit 1
fi

if ! sudo tar -tzf "$INCR" 2>/dev/null | grep -q 'opt/services/data/ledger-2026-Q3.csv$'; then
  echo "FAIL: incremental backup $INCR does not contain the new file opt/services/data/ledger-2026-Q3.csv"
  exit 1
fi

if sudo tar -tzf "$INCR" 2>/dev/null | grep -q 'opt/services/data/ledger-2026-Q2.csv$'; then
  echo "FAIL: incremental backup $INCR includes the untouched ledger-2026-Q2.csv -- it should only capture changed/new files"
  exit 1
fi

echo "PASS: incremental backup is a true increment: smaller than full, captures real changes, skips unchanged data"
exit 0
