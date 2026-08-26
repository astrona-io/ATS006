#!/usr/bin/env bash
set -u

FULL=/backup/full-backup.tar.gz
INCR=/backup/incr-backup.tar.gz
SNAP=/backup/snapshot.snar
RESTORE_FULL=/restore/full
RESTORE_INCR=/restore/incremental

# --- Full backup exists and excludes cache ---

if [[ ! -f "$FULL" ]]; then
  echo "FAIL: full backup $FULL does not exist"
  exit 1
fi

if sudo tar -tzf "$FULL" 2>/dev/null | grep -q 'srv/appdata/cache'; then
  echo "FAIL: full backup $FULL contains srv/appdata/cache -- it should have been excluded"
  exit 1
fi

if ! sudo tar -tzf "$FULL" 2>/dev/null | grep -q '^etc/'; then
  echo "FAIL: full backup $FULL does not contain /etc"
  exit 1
fi

if ! sudo tar -tzf "$FULL" 2>/dev/null | grep -q 'srv/appdata/notes.txt$'; then
  echo "FAIL: full backup $FULL does not contain srv/appdata/notes.txt"
  exit 1
fi

# --- Incremental backup exists, uses the snapshot file, and is a true increment ---

if [[ ! -f "$SNAP" ]]; then
  echo "FAIL: listed-incremental snapshot file $SNAP does not exist"
  exit 1
fi

if [[ ! -f "$INCR" ]]; then
  echo "FAIL: incremental backup $INCR does not exist"
  exit 1
fi

if sudo tar -tzf "$INCR" 2>/dev/null | grep -q 'srv/appdata/cache'; then
  echo "FAIL: incremental backup $INCR contains srv/appdata/cache -- it should have been excluded"
  exit 1
fi

full_size=$(stat -c %s "$FULL" 2>/dev/null)
incr_size=$(stat -c %s "$INCR" 2>/dev/null)
if [[ -z "$full_size" || -z "$incr_size" || "$incr_size" -ge "$full_size" ]]; then
  echo "FAIL: incremental backup ($incr_size bytes) is not smaller than the full backup ($full_size bytes) -- looks like a second full copy, not a true incremental"
  exit 1
fi

if ! sudo tar -tzf "$INCR" 2>/dev/null | grep -q 'srv/appdata/new-shipment.csv$'; then
  echo "FAIL: incremental backup $INCR does not contain the new file srv/appdata/new-shipment.csv"
  exit 1
fi

if sudo tar -tzf "$INCR" 2>/dev/null | grep -q 'srv/appdata/reports/2026-Q2-summary.csv$'; then
  echo "FAIL: incremental backup $INCR includes the untouched reports file -- it should only capture changed/new files"
  exit 1
fi

# --- Restore #1: full backup alone reflects the pre-change state ---

if [[ ! -d "$RESTORE_FULL/etc" ]] || [[ ! -d "$RESTORE_FULL/srv/appdata" ]]; then
  echo "FAIL: $RESTORE_FULL does not contain a restored etc/ and srv/appdata/"
  exit 1
fi

if ! sudo diff -rq /etc "$RESTORE_FULL/etc" >/dev/null 2>&1; then
  echo "FAIL: sudo diff -r /etc $RESTORE_FULL/etc found differences -- full restore of /etc is not correct"
  exit 1
fi

if sudo grep -q "Q3 restock complete" "$RESTORE_FULL/srv/appdata/notes.txt" 2>/dev/null; then
  echo "FAIL: $RESTORE_FULL/srv/appdata/notes.txt already contains the post-backup change -- full backup should predate it"
  exit 1
fi

if [[ -e "$RESTORE_FULL/srv/appdata/new-shipment.csv" ]]; then
  echo "FAIL: $RESTORE_FULL/srv/appdata/new-shipment.csv should not exist in the full-only restore"
  exit 1
fi

if [[ -e "$RESTORE_FULL/srv/appdata/cache" ]]; then
  echo "FAIL: $RESTORE_FULL/srv/appdata/cache exists -- excluded directory leaked into the restore"
  exit 1
fi

# --- Restore #2: full + incremental layered reflects the post-change state ---

if [[ ! -d "$RESTORE_INCR/etc" ]] || [[ ! -d "$RESTORE_INCR/srv/appdata" ]]; then
  echo "FAIL: $RESTORE_INCR does not contain a restored etc/ and srv/appdata/"
  exit 1
fi

if ! sudo diff -rq /etc "$RESTORE_INCR/etc" >/dev/null 2>&1; then
  echo "FAIL: sudo diff -r /etc $RESTORE_INCR/etc found differences -- layered restore of /etc is not correct"
  exit 1
fi

if ! sudo grep -q "Q3 restock complete" "$RESTORE_INCR/srv/appdata/notes.txt" 2>/dev/null; then
  echo "FAIL: $RESTORE_INCR/srv/appdata/notes.txt is missing the post-backup change -- incremental layer was not applied correctly"
  exit 1
fi

if [[ ! -e "$RESTORE_INCR/srv/appdata/new-shipment.csv" ]]; then
  echo "FAIL: $RESTORE_INCR/srv/appdata/new-shipment.csv is missing from the layered restore"
  exit 1
fi

if [[ -e "$RESTORE_INCR/srv/appdata/cache" ]]; then
  echo "FAIL: $RESTORE_INCR/srv/appdata/cache exists -- excluded directory leaked into the restore"
  exit 1
fi

# --- Permission preservation on a security-sensitive file ---

live_shadow=$(sudo stat -c '%a %U:%G' /etc/shadow 2>/dev/null)
restored_shadow=$(sudo stat -c '%a %U:%G' "$RESTORE_FULL/etc/shadow" 2>/dev/null)

if [[ -z "$live_shadow" || "$live_shadow" != "$restored_shadow" ]]; then
  echo "FAIL: /etc/shadow permissions/ownership were not preserved (live='$live_shadow', restored='$restored_shadow') -- was -p used on both backup and restore?"
  exit 1
fi

echo "PASS: full+incremental backup strategy correct, cache excluded, permissions preserved, both restores verified"
exit 0
