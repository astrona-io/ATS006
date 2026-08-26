#!/usr/bin/env bash
# Confirms /backup/snapshots/snap2 exists as a complete, browsable copy
# and that unchanged files were hardlinked (not recopied) against the
# --link-dest reference at /backup/appdata.

set -u

SNAP=/backup/snapshots/snap2

for f in app.conf data1.txt data2.txt; do
  if [[ ! -f "$SNAP/$f" ]]; then
    echo "FAIL: snapshot link-dest - $SNAP/$f is missing"
    exit 1
  fi

  links=$(stat -c '%h' "$SNAP/$f" 2>/dev/null)
  if [[ -z "$links" ]] || (( links < 2 )); then
    echo "FAIL: snapshot link-dest - $SNAP/$f has link count ${links:-0}, expected >1 (not hardlinked against --link-dest)"
    exit 1
  fi
done

echo "PASS: $SNAP is a complete snapshot with files hardlinked against the --link-dest reference"
exit 0
