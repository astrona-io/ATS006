#!/usr/bin/env bash
set -u

SHARED=/srv/teamspace/shared

mode=$(stat -c '%a' "$SHARED" 2>/dev/null)
if [ "$mode" != "2770" ]; then
  echo "FAIL: $SHARED mode is '$mode', expected '2770' (setgid + 770)"
  exit 1
fi

group=$(stat -c '%G' "$SHARED" 2>/dev/null)
if [ "$group" != "ops" ]; then
  echo "FAIL: $SHARED group is '$group', expected 'ops'"
  exit 1
fi

# Functional check: setgid inheritance -- a file created by a member of
# "ops" (whose own primary group is "opsuser", not "ops") must still
# come out group-owned by "ops".
testfile="$SHARED/.validate-setgid-test-$$"
if ! sudo -u opsuser touch "$testfile" 2>/dev/null; then
  echo "FAIL: opsuser could not create a file inside $SHARED"
  exit 1
fi

newfile_group=$(stat -c '%G' "$testfile" 2>/dev/null)
sudo rm -f "$testfile"

if [ "$newfile_group" != "ops" ]; then
  echo "FAIL: new file in $SHARED inherited group '$newfile_group', expected 'ops' (setgid not effective)"
  exit 1
fi

echo "PASS: $SHARED is 2770 with group inheritance to 'ops' confirmed"
exit 0
