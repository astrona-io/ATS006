#!/usr/bin/env bash
set -u

# This validation process may run non-interactively, in which case
# ~/.bashrc (where VARIABLE1 is exported) is never auto-sourced the way
# it would be for an interactive login session. Source it explicitly so
# VARIABLE1 is present in this shell's environment before we exec the
# student's script, exactly as it would be for a real interactive run.
if [ -z "${VARIABLE1:-}" ] && [ -f "$HOME/.bashrc" ]; then
  # shellcheck disable=SC1090
  source "$HOME/.bashrc" 2>/dev/null || true
fi

SCRIPT=/opt/course/4/script.sh

if [ ! -f "$SCRIPT" ]; then
  echo "FAIL: $SCRIPT does not exist"
  exit 1
fi

if [ ! -x "$SCRIPT" ]; then
  echo "FAIL: $SCRIPT is not executable"
  exit 1
fi

# .bashrc must contain only the pre-staged VARIABLE1 export -- no new
# lines for VARIABLE2 or VARIABLE3 may have been added to it.
if grep -qE 'VARIABLE2|VARIABLE3' "$HOME/.bashrc" 2>/dev/null; then
  echo "FAIL: ~/.bashrc was modified -- VARIABLE2/VARIABLE3 must be defined only inside $SCRIPT"
  exit 1
fi

output=$(bash "$SCRIPT" 2>/dev/null)
expected="v2
random-string-extended"

if [ "$output" != "$expected" ]; then
  echo "FAIL: script output was:
$output
expected:
$expected"
  exit 1
fi

# VARIABLE2 must stay shell-local: the script source must not export it.
if grep -Eq '^[[:space:]]*export[[:space:]]+VARIABLE2\b' "$SCRIPT"; then
  echo "FAIL: VARIABLE2 must not be exported -- it should only be available inside the script itself"
  exit 1
fi

# VARIABLE3 must be exported so child processes of the script can see it.
if ! grep -Eq '^[[:space:]]*export[[:space:]]+VARIABLE3\b' "$SCRIPT"; then
  echo "FAIL: VARIABLE3 must be exported so child processes of the script can see it"
  exit 1
fi

# Behavioral confirmation: a child process spawned from inside the script
# must see VARIABLE3 but never VARIABLE2.
child_output=$(bash -c "$(cat "$SCRIPT" | grep -v '^#!'); bash -c 'echo \"child sees VARIABLE2=\${VARIABLE2:-<unset>} VARIABLE3=\${VARIABLE3:-<unset>}\"'" 2>/dev/null)

if ! echo "$child_output" | grep -q 'VARIABLE3=random-string-extended'; then
  echo "FAIL: a child process of the script did not see the exported VARIABLE3 (got: $child_output)"
  exit 1
fi

if ! echo "$child_output" | grep -q 'VARIABLE2=<unset>'; then
  echo "FAIL: a child process of the script unexpectedly saw VARIABLE2 -- it must remain shell-local (got: $child_output)"
  exit 1
fi

echo "PASS: script.sh defines VARIABLE2 as shell-local and VARIABLE3 as exported, with correct output and untouched .bashrc"
exit 0
