#!/usr/bin/env bash
# Match the account used by astrona ssh, including its home and permissions.
sudo -H -u student bash <<'ASTRONA_STUDENT_SCRIPT'
set -u

SCRIPT=/home/candidate/scripts/count-lines.sh
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

fail() { echo "FAIL: $1"; exit 1; }

[ -f "$SCRIPT" ] || fail "$SCRIPT does not exist"
[ -x "$SCRIPT" ] || fail "$SCRIPT is not executable"

run_script() {
    # Usage: run_script <args...>; sets OUT, ERR and CODE
    set +e
    OUT=$(sudo -u candidate "$SCRIPT" "$@" 2>"$WORK/stderr")
    CODE=$?
    set -e
    ERR=$(cat "$WORK/stderr")
}
set -e

run_script
[ "$CODE" = "2" ] || fail "no argument: expected exit code 2, got $CODE"
[ "$ERR" = "usage: count-lines.sh <directory>" ] || fail "no argument: stderr was '$ERR'"
[ -z "$OUT" ] || fail "no argument: stdout should be empty"

run_script /nonexistent-folder
[ "$CODE" = "1" ] || fail "bad argument: expected exit code 1, got $CODE"
[ "$ERR" = "not a directory: /nonexistent-folder" ] || fail "bad argument: stderr was '$ERR'"

run_script /home/candidate/inbox
expected=$(printf 'alpha.txt: 2 lines\nbravo.txt: 5 lines\ncharlie.txt: 9 lines\ntotal: 16 lines')
[ "$CODE" = "0" ] || fail "inbox: expected exit code 0, got $CODE"
[ "$OUT" = "$expected" ] || fail "inbox: output was: $OUT"

mkdir "$WORK/spaces" "$WORK/empty"
printf 'a\nb\nc\n' > "$WORK/spaces/two words.txt"
printf 'x\n' > "$WORK/spaces/x.txt"
printf 'ignored\n' > "$WORK/spaces/notes.log"
chmod -R a+rX "$WORK"
run_script "$WORK/spaces"
expected=$(printf 'two words.txt: 3 lines\nx.txt: 1 lines\ntotal: 4 lines')
[ "$CODE" = "0" ] || fail "spaces: expected exit code 0, got $CODE"
[ "$OUT" = "$expected" ] || fail "spaces: output was: $OUT"

run_script "$WORK/empty"
[ "$CODE" = "0" ] || fail "empty folder: expected exit code 0, got $CODE"
[ "$OUT" = "total: 0 lines" ] || fail "empty folder: output was: $OUT"

echo "PASS: the script checks its argument, loops over the text files and exits with the right codes"
exit 0
ASTRONA_STUDENT_SCRIPT
