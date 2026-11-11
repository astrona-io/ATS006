#!/usr/bin/env bash
# Match the account used by astrona ssh, including its home and permissions.
sudo -H -u student bash <<'ASTRONA_STUDENT_SCRIPT'
set -u

SRC=/srv/teamspace/release-src
REL=/srv/teamspace/releases
EXPECTED_MTIME=$(date -u -d "2024-03-15 10:00:00 UTC" +%s)

if [ ! -d "$REL/2026/q1" ]; then
  echo "FAIL: $REL/2026/q1 does not exist"
  exit 1
fi

if [ ! -f "$SRC/app.conf" ]; then
  echo "FAIL: the original $SRC/app.conf is gone; it must be copied, not moved"
  exit 1
fi

if [ ! -f "$REL/2026/q1/app.conf" ]; then
  echo "FAIL: $REL/2026/q1/app.conf does not exist"
  exit 1
fi

copy_mode=$(stat -c '%a' "$REL/2026/q1/app.conf")
if [ "$copy_mode" != "640" ]; then
  echo "FAIL: the copy has mode $copy_mode, expected 640 (the original's mode must be kept)"
  exit 1
fi

copy_mtime=$(stat -c '%Y' "$REL/2026/q1/app.conf")
if [ "$copy_mtime" != "$EXPECTED_MTIME" ]; then
  echo "FAIL: the copy's modification time was not kept (got $copy_mtime, expected $EXPECTED_MTIME)"
  exit 1
fi

if ! cmp -s "$SRC/app.conf" "$REL/2026/q1/app.conf"; then
  echo "FAIL: the copy's content differs from the original"
  exit 1
fi

if [ -e "$SRC/old-release.txt" ]; then
  echo "FAIL: $SRC/old-release.txt still exists; it must be moved"
  exit 1
fi

if [ ! -f "$REL/2026/old-release.txt" ]; then
  echo "FAIL: $REL/2026/old-release.txt does not exist"
  exit 1
fi

if [ -e "$SRC/tmp-build" ]; then
  echo "FAIL: $SRC/tmp-build still exists; it must be removed with everything inside it"
  exit 1
fi

echo "PASS: release tree built, app.conf copied with mode and time kept, old-release.txt moved, tmp-build removed"
exit 0
ASTRONA_STUDENT_SCRIPT
