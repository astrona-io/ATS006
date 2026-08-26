#!/usr/bin/env bash
set -u

RESTORE_CURRENT=/restore/services-current

if [[ ! -d "$RESTORE_CURRENT/opt/services" ]]; then
  echo "FAIL: $RESTORE_CURRENT does not contain a restored opt/services tree"
  exit 1
fi

if ! sudo grep -q "feature_flag=rollout-42" "$RESTORE_CURRENT/opt/services/config/app.conf" 2>/dev/null; then
  echo "FAIL: $RESTORE_CURRENT/opt/services/config/app.conf is missing the post-backup change -- incremental layer was not applied correctly"
  exit 1
fi

if [[ ! -e "$RESTORE_CURRENT/opt/services/data/ledger-2026-Q3.csv" ]]; then
  echo "FAIL: $RESTORE_CURRENT/opt/services/data/ledger-2026-Q3.csv is missing from the layered restore"
  exit 1
fi

if ! sudo grep -q "2026-Q3,pending" "$RESTORE_CURRENT/opt/services/data/ledger-2026-Q3.csv" 2>/dev/null; then
  echo "FAIL: $RESTORE_CURRENT/opt/services/data/ledger-2026-Q3.csv exists but does not contain the expected content"
  exit 1
fi

if [[ -e "$RESTORE_CURRENT/opt/services/data/tmp" ]]; then
  echo "FAIL: $RESTORE_CURRENT/opt/services/data/tmp exists -- excluded directory leaked into the restore"
  exit 1
fi

if ! sudo diff -q /opt/services/data/ledger-2026-Q2.csv "$RESTORE_CURRENT/opt/services/data/ledger-2026-Q2.csv" >/dev/null 2>&1; then
  echo "FAIL: restored ledger-2026-Q2.csv content does not match the original in the layered restore"
  exit 1
fi

live_app_conf=$(sudo cat /opt/services/config/app.conf 2>/dev/null)
restored_app_conf=$(sudo cat "$RESTORE_CURRENT/opt/services/config/app.conf" 2>/dev/null)

if [[ "$live_app_conf" != "$restored_app_conf" ]]; then
  echo "FAIL: restored app.conf does not match the live current app.conf content"
  exit 1
fi

echo "PASS: full+incremental layered restore reflects the post-change state exactly"
exit 0
