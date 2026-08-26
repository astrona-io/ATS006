#!/usr/bin/env bash
set -u

RESTORE_FULL=/restore/services-full

if [[ ! -d "$RESTORE_FULL/opt/services" ]]; then
  echo "FAIL: $RESTORE_FULL does not contain a restored opt/services tree"
  exit 1
fi

if sudo grep -q "feature_flag" "$RESTORE_FULL/opt/services/config/app.conf" 2>/dev/null; then
  echo "FAIL: $RESTORE_FULL/opt/services/config/app.conf already contains the post-backup change -- the full backup should predate it"
  exit 1
fi

if [[ -e "$RESTORE_FULL/opt/services/data/ledger-2026-Q3.csv" ]]; then
  echo "FAIL: $RESTORE_FULL/opt/services/data/ledger-2026-Q3.csv should not exist in the full-only restore"
  exit 1
fi

if [[ -e "$RESTORE_FULL/opt/services/data/tmp" ]]; then
  echo "FAIL: $RESTORE_FULL/opt/services/data/tmp exists -- excluded directory leaked into the restore"
  exit 1
fi

if ! sudo diff -q /opt/services/data/ledger-2026-Q2.csv "$RESTORE_FULL/opt/services/data/ledger-2026-Q2.csv" >/dev/null 2>&1; then
  echo "FAIL: restored ledger-2026-Q2.csv content does not match the original"
  exit 1
fi

live_perm=$(sudo stat -c '%a %U:%G' /opt/services/config/secrets.conf 2>/dev/null)
restored_perm=$(sudo stat -c '%a %U:%G' "$RESTORE_FULL/opt/services/config/secrets.conf" 2>/dev/null)

if [[ -z "$live_perm" || "$live_perm" != "$restored_perm" ]]; then
  echo "FAIL: secrets.conf permissions/ownership were not preserved (live='$live_perm', restored='$restored_perm') -- was -p used on both backup and restore?"
  exit 1
fi

echo "PASS: full-only restore reflects the pre-change state with correct permissions and no excluded content"
exit 0
