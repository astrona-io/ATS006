#!/usr/bin/env bash
set -u

DIR=/home/candidate/report
fail() { echo "FAIL: $1"; exit 1; }

[ -d "$DIR" ] || fail "$DIR does not exist"
for f in by-hours.txt visit-counts.txt engineer-hours.txt settings.diff roles.txt; do
    [ -s "$DIR/$f" ] || fail "$DIR/$f is missing or empty"
done

expected=$(printf 'Ana\nDev\nGus\nIvo\nBen\nEli\nHana\nFay\nCleo\nJo')
[ "$(cat "$DIR/by-hours.txt")" = "$expected" ] || fail "by-hours.txt does not list the names with the most hours first"

normalised=$(awk '{print $1" "$2}' "$DIR/visit-counts.txt")
expected=$(printf '6 mars\n4 luna\n3 titan\n2 europa' | awk '{print $1" "$2}')
[ "$normalised" = "$expected" ] || fail "visit-counts.txt is wrong: $normalised"

[ "$(tr -d '[:space:]' < "$DIR/engineer-hours.txt")" = "510" ] || fail "engineer-hours.txt must hold 510"

grep -q '^--- ' "$DIR/settings.diff" || fail "settings.diff is not a unified diff (no --- header)"
grep -q '^+++ ' "$DIR/settings.diff" || fail "settings.diff is not a unified diff (no +++ header)"
grep -qx -- '-speed=low' "$DIR/settings.diff" || fail "settings.diff misses the removed line speed=low"
grep -qx -- '+speed=high' "$DIR/settings.diff" || fail "settings.diff misses the added line speed=high"
grep -qx -- '+alarm=on' "$DIR/settings.diff" || fail "settings.diff misses the added line alarm=on"
first_old=$(grep -m1 '^--- ' "$DIR/settings.diff")
case "$first_old" in
    *settings-old.conf*) ;;
    *) fail "settings.diff must compare the old file first" ;;
esac

expected=$(printf 'COOK\nENGINEER\nMEDIC\nPILOT')
[ "$(cat "$DIR/roles.txt")" = "$expected" ] || fail "roles.txt is wrong"

echo "PASS: all five reports hold the expected content"
exit 0
