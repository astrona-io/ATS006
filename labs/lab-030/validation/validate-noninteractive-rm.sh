#!/usr/bin/env bash
set -u

noninteractive_rm=$(bash -c 'type rm' 2>/dev/null)

if [[ "$noninteractive_rm" == *"aliased to"* ]]; then
  echo "FAIL: a non-interactive shell must not see the rm alias (got: $noninteractive_rm)"
  exit 1
fi

if [[ "$noninteractive_rm" != *"/rm"* ]]; then
  echo "FAIL: non-interactive 'type rm' did not resolve to a real rm binary (got: $noninteractive_rm)"
  exit 1
fi

echo "PASS: a non-interactive shell resolves rm to the real binary, not the alias"
exit 0
