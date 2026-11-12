#!/usr/bin/env bash
# Match the account used by astrona ssh, including its home and permissions.
sudo -H -u student bash <<'ASTRONA_STUDENT_SCRIPT'
# Inspect protected state; user access checks select their target account explicitly.
sudo -n bash <<'GRADER_ROOT'
set -u

CARGO=/home/candidate/cargo
fail() { echo "FAIL: $1"; exit 1; }

[ -d "$CARGO/archive/2026/q1" ] || fail "$CARGO/archive/2026/q1 does not exist"

copy="$CARGO/archive/2026/q1/manifest.txt"
[ -f "$copy" ] || fail "the copy of manifest.txt is missing"
[ -f "$CARGO/manifest.txt" ] || fail "the original manifest.txt was removed"
[ "$(stat -c %a "$copy")" = "$(stat -c %a "$CARGO/manifest.txt")" ] || fail "the copy does not keep the mode of the original"
[ "$(stat -c %Y "$copy")" = "$(stat -c %Y "$CARGO/manifest.txt")" ] || fail "the copy does not keep the modification time of the original"
cmp -s "$copy" "$CARGO/manifest.txt" || fail "the copy has other content than the original"

[ -f "$CARGO/archive/2026/old-crew.txt" ] || fail "old-crew.txt is not in $CARGO/archive/2026"
[ ! -e "$CARGO/old-crew.txt" ] || fail "old-crew.txt is still in the old place (copied, not moved)"

[ -f "$CARGO/crew.txt" ] || fail "crew.txt is missing"
[ -f "$CARGO/crew-hard.txt" ] && [ ! -L "$CARGO/crew-hard.txt" ] || fail "crew-hard.txt is missing or is a symbolic link"
[ "$(stat -c %i "$CARGO/crew-hard.txt")" = "$(stat -c %i "$CARGO/crew.txt")" ] || fail "crew-hard.txt is not a hard link to crew.txt"

[ -L "$CARGO/crew-soft.txt" ] || fail "crew-soft.txt is not a symbolic link"
[ "$(readlink "$CARGO/crew-soft.txt")" = "crew.txt" ] || fail "crew-soft.txt must point at the relative target crew.txt"

[ ! -e "$CARGO/scratch" ] || fail "$CARGO/scratch still exists"

[ "$(stat -c %G "$CARGO/crates")" = "loaders" ] || fail "crates is not owned by the group loaders"
[ "$(stat -c %U "$CARGO/crates")" = "candidate" ] || fail "the owner of crates changed"
for f in "$CARGO"/crates/*; do
    [ "$(stat -c %G "$f")" = "loaders" ] || fail "$f is not owned by the group loaders"
    [ "$(stat -c %U "$f")" = "candidate" ] || fail "the owner of $f changed"
done

echo "PASS: the tree, the preserved copy, the move, both links, the removal and the group ownership are correct"
exit 0
GRADER_ROOT
ASTRONA_STUDENT_SCRIPT
