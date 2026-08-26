#!/usr/bin/env bash
set -u

FULL=/backup/services-full.tar.gz

if [[ ! -f "$FULL" ]]; then
  echo "FAIL: full backup $FULL does not exist"
  exit 1
fi

filetype=$(file -b "$FULL")
if [[ "$filetype" != *"gzip compressed data"* ]]; then
  echo "FAIL: $FULL is not gzip-compressed data (file reports: '$filetype')"
  exit 1
fi

if sudo tar -tzf "$FULL" 2>/dev/null | grep -q 'opt/services/data/tmp'; then
  echo "FAIL: full backup $FULL contains opt/services/data/tmp -- it should have been excluded"
  exit 1
fi

if ! sudo tar -tzf "$FULL" 2>/dev/null | grep -q 'opt/services/config/secrets.conf$'; then
  echo "FAIL: full backup $FULL does not contain opt/services/config/secrets.conf"
  exit 1
fi

if ! sudo tar -tzf "$FULL" 2>/dev/null | grep -q 'opt/services/data/ledger-2026-Q2.csv$'; then
  echo "FAIL: full backup $FULL does not contain opt/services/data/ledger-2026-Q2.csv"
  exit 1
fi

# Paths must be stored relative (via -C /), not absolute, so the archive
# can be safely extracted anywhere.
if sudo tar -tzf "$FULL" 2>/dev/null | grep -qE '^/'; then
  echo "FAIL: full backup $FULL stores absolute paths -- it should be created with -C / so paths are relative"
  exit 1
fi

echo "PASS: full backup exists, excludes data/tmp, contains expected files, and uses relative paths"
exit 0
