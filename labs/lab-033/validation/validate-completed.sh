#!/usr/bin/env bash
set -u

BASHRC="$HOME/.bashrc"

if ! grep -Eq "^alias[[:space:]]+ll=" "$BASHRC" 2>/dev/null; then
  echo "FAIL: $BASHRC is missing a persistent 'alias ll=' definition"
  exit 1
fi

if ! grep -Eq "^alias[[:space:]]+rm=" "$BASHRC" 2>/dev/null; then
  echo "FAIL: $BASHRC is missing a persistent 'alias rm=' definition"
  exit 1
fi

if ! grep -Eq "^alias[[:space:]]+myip=" "$BASHRC" 2>/dev/null; then
  echo "FAIL: $BASHRC is missing a persistent 'alias myip=' definition"
  exit 1
fi

ll_type=$(bash -ic 'type ll' 2>/dev/null)
if [[ "$ll_type" != *"aliased to"*"ls -alF"* ]]; then
  echo "FAIL: 'll' must be aliased to 'ls -alF' in an interactive shell (got: $ll_type)"
  exit 1
fi

rm_type=$(bash -ic 'type rm' 2>/dev/null)
if [[ "$rm_type" != *"aliased to"*"rm -i"* ]]; then
  echo "FAIL: 'rm' must be aliased to 'rm -i' in an interactive shell (got: $rm_type)"
  exit 1
fi

myip_type=$(bash -ic 'type myip' 2>/dev/null)
if [[ "$myip_type" != *"aliased to"* ]]; then
  echo "FAIL: 'myip' does not resolve as an alias in an interactive shell (got: $myip_type)"
  exit 1
fi

myip_output=$(bash -ic 'myip' 2>/dev/null | tr -d '[:space:]')
if ! [[ "$myip_output" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
  echo "FAIL: myip did not print exactly one IPv4 address with no other output (got: '$myip_output')"
  exit 1
fi

noninteractive_rm=$(bash -c 'type rm' 2>/dev/null)
if [[ "$noninteractive_rm" == *"aliased to"* ]]; then
  echo "FAIL: a non-interactive shell must not see the rm alias (got: $noninteractive_rm)"
  exit 1
fi

if [ -f "$HOME/lab-artifact-to-delete.txt" ]; then
  echo "FAIL: ~/lab-artifact-to-delete.txt still exists -- remove it with the real, non-aliased rm"
  exit 1
fi

echo "PASS: ll/rm/myip are persisted and functional, non-interactive shells bypass the alias, and the artifact was removed with the real rm"
exit 0
