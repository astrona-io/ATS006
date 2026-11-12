#!/usr/bin/env bash
# Match the account used by astrona ssh, including its home and permissions.
sudo -H -u student bash <<'ASTRONA_STUDENT_SCRIPT'
# Inspect protected state; user access checks select their target account explicitly.
sudo -n bash <<'GRADER_ROOT'
set -u

REPORTS=/srv/shared/reports
SCRIPT=/opt/tools/backup-runner.sh
DROPBOX=/srv/shared/dropbox

mode=$(stat -c '%a' "$REPORTS" 2>/dev/null)
if [ "$mode" != "2770" ]; then
  echo "FAIL: $REPORTS mode is '$mode', expected '2770' (setgid + 770)"
  exit 1
fi

group=$(stat -c '%G' "$REPORTS" 2>/dev/null)
if [ "$group" != "analysts" ]; then
  echo "FAIL: $REPORTS group is '$group', expected 'analysts'"
  exit 1
fi

mode=$(stat -c '%a' "$SCRIPT" 2>/dev/null)
if [ "$mode" != "700" ]; then
  echo "FAIL: $SCRIPT mode is '$mode', expected '700'"
  exit 1
fi

mode=$(stat -c '%a' "$DROPBOX" 2>/dev/null)
if [ "$mode" != "1777" ]; then
  echo "FAIL: $DROPBOX mode is '$mode', expected '1777' (sticky + 777)"
  exit 1
fi

# Functional check: setgid inheritance -- a file created by a member of
# "analysts" (who does not have "analysts" as their own primary group)
# must still come out group-owned by "analysts".
testfile="$REPORTS/.validate-setgid-test-$$"
if ! sudo -u someanalyst touch "$testfile" 2>/dev/null; then
  echo "FAIL: someanalyst could not create a file inside $REPORTS"
  exit 1
fi

newfile_group=$(stat -c '%G' "$testfile" 2>/dev/null)
sudo rm -f "$testfile"

if [ "$newfile_group" != "analysts" ]; then
  echo "FAIL: new file in $REPORTS inherited group '$newfile_group', expected 'analysts' (setgid not effective)"
  exit 1
fi

echo "PASS: reports directory setgid, backup-runner.sh lockdown, and dropbox sticky bit are all correctly configured"
exit 0
GRADER_ROOT
ASTRONA_STUDENT_SCRIPT
