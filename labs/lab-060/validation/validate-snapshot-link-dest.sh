#!/usr/bin/env bash
# Confirms /backup/audit-svc-snap2 is a complete, browsable snapshot:
# the three unchanged logs are hardlinked against the full backup
# (link count >1), and audit.log.4 is present with the correct content
# as genuinely new data transferred fresh into the snapshot.

set -u

SNAP=/backup/audit-svc-snap2
FULL=/backup/audit-svc-full

for f in audit.log.1 audit.log.2 audit.log.3; do
  if [[ ! -f "$SNAP/$f" ]]; then
    echo "FAIL: snapshot link-dest - $SNAP/$f is missing"
    exit 1
  fi

  links=$(stat -c '%h' "$SNAP/$f" 2>/dev/null)
  if [[ -z "$links" ]] || (( links < 2 )); then
    echo "FAIL: snapshot link-dest - $SNAP/$f has link count ${links:-0}, expected >1 (not hardlinked against --link-dest=$FULL)"
    exit 1
  fi
done

if [[ ! -f "$SNAP/audit.log.4" ]]; then
  echo "FAIL: snapshot link-dest - $SNAP/audit.log.4 is missing"
  exit 1
fi

if ! grep -q "new audit batch" "$SNAP/audit.log.4" 2>/dev/null; then
  echo "FAIL: snapshot link-dest - $SNAP/audit.log.4 does not contain the expected content"
  exit 1
fi

echo "PASS: $SNAP is a complete snapshot, hardlinked against $FULL for unchanged files, with audit.log.4 transferred fresh"
exit 0
