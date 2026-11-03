#!/usr/bin/env bash
set -u

REL=/srv/teamspace/releases
COPY="$REL/2026/q1/app.conf"

if [ ! -f "$COPY" ]; then
  echo "FAIL: $COPY does not exist"
  exit 1
fi

if [ ! -f "$REL/app-hard.conf" ] || [ -L "$REL/app-hard.conf" ]; then
  echo "FAIL: $REL/app-hard.conf must be a regular file that is a hard link, not a symbolic link"
  exit 1
fi

copy_inode=$(stat -c '%i' "$COPY")
hard_inode=$(stat -c '%i' "$REL/app-hard.conf")
if [ "$copy_inode" != "$hard_inode" ]; then
  echo "FAIL: app-hard.conf (inode $hard_inode) is not a hard link to the copy (inode $copy_inode)"
  exit 1
fi

if [ ! -L "$REL/current" ]; then
  echo "FAIL: $REL/current is not a symbolic link"
  exit 1
fi

target=$(readlink "$REL/current")
if [ "$target" != "2026/q1" ]; then
  echo "FAIL: $REL/current points at '$target', expected the relative target '2026/q1'"
  exit 1
fi

if [ "$(readlink -f "$REL/current")" != "$REL/2026/q1" ]; then
  echo "FAIL: $REL/current does not resolve to $REL/2026/q1"
  exit 1
fi

wrong_group=$(find "$REL" \( -type f -o -type d \) ! -group ops 2>/dev/null | wc -l)
if [ "$wrong_group" -ne 0 ]; then
  echo "FAIL: $wrong_group file(s) or folder(s) under $REL do not have group ops"
  exit 1
fi

wrong_owner=$(find "$REL" \( -type f -o -type d \) ! -user root 2>/dev/null | wc -l)
if [ "$wrong_owner" -ne 0 ]; then
  echo "FAIL: $wrong_owner file(s) or folder(s) under $REL changed owner; only the group should change"
  exit 1
fi

echo "PASS: hard link shares the copy's inode, current points at 2026/q1, everything under releases has group ops"
exit 0
