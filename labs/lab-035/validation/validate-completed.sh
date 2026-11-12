#!/usr/bin/env bash
# Match the account used by astrona ssh, including its home and permissions.
sudo -H -u student bash <<'ASTRONA_STUDENT_SCRIPT'
# Inspect protected state; user access checks select their target account explicitly.
sudo -n bash <<'GRADER_ROOT'
set -u

fail() { echo "FAIL: $1"; exit 1; }

plan=/home/candidate/flightplan.conf
answers=/home/candidate/answers.txt
[ -f "$plan" ] || fail "$plan is missing"
[ -f "$answers" ] || fail "$answers is missing"

expected=$(printf 'destination=TBD\ncrew_size=4\nfuel=TBD\nroute=TBD\nchecked=yes\nlaunch=ready')
[ "$(cat "$plan")" = "$expected" ] || fail "flightplan.conf does not have the expected content"

expected=$(printf 'passwd-file-section=5\nls-sort-by-time=-t')
[ "$(cat "$answers")" = "$expected" ] || fail "answers.txt does not have the expected content"

echo "PASS: the flight plan is edited and both manual facts are correct"
exit 0
GRADER_ROOT
ASTRONA_STUDENT_SCRIPT
