#!/usr/bin/env bash
set -u

if ! id opsuser >/dev/null 2>&1; then
  echo "FAIL: user 'opsuser' does not exist"
  exit 1
fi

TESTFILE="opsuser-umask-check-file-$$"
TESTDIR="opsuser-umask-check-dir-$$"

# sudo -iu starts a genuine login shell for opsuser, reading whatever
# startup file(s) a real new login session would -- this is a functional
# test of persistence, not a text grep for a specific file/line.
output=$(sudo -iu opsuser bash -lc "
  rm -f \"\$HOME/$TESTFILE\"
  rm -rf \"\$HOME/$TESTDIR\"
  touch \"\$HOME/$TESTFILE\"
  mkdir \"\$HOME/$TESTDIR\"
  stat -c '%a' \"\$HOME/$TESTFILE\"
  stat -c '%a' \"\$HOME/$TESTDIR\"
" 2>/dev/null)

file_mode=$(echo "$output" | sed -n '1p')
dir_mode=$(echo "$output" | sed -n '2p')

sudo -iu opsuser bash -lc "rm -f \"\$HOME/$TESTFILE\"; rm -rf \"\$HOME/$TESTDIR\"" 2>/dev/null || true

if [ "$file_mode" != "640" ]; then
  echo "FAIL: a fresh login shell for opsuser created a file with mode '$file_mode', expected '640'"
  exit 1
fi

if [ "$dir_mode" != "750" ]; then
  echo "FAIL: a fresh login shell for opsuser created a directory with mode '$dir_mode', expected '750'"
  exit 1
fi

echo "PASS: opsuser's persistent umask produces 640 files and 750 directories with no chmod involved"
exit 0
