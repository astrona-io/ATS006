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

if ! grep -Eq "^alias[[:space:]]+report=" "$BASHRC" 2>/dev/null; then
  echo "FAIL: $BASHRC is missing a persistent 'alias report=' definition"
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

echo "PASS: ll, rm, and report aliases are all persisted and defined correctly"
exit 0
