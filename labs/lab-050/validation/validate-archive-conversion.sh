#!/usr/bin/env bash
set -u

BZ2=/exports/reports-2026-08.tar.bz2
GZ=/exports/reports-2026-08.tar.gz
BZ2_LIST=/exports/reports-2026-08.tar.bz2_list
GZ_LIST=/exports/reports-2026-08.tar.gz_list
BASELINE=/var/lib/astrona-lab/reports-2026-08.tar.bz2.sha256

if [[ ! -f "$BZ2" ]]; then
  echo "FAIL: original archive $BZ2 is missing"
  exit 1
fi

if [[ -f "$BASELINE" ]]; then
  if ! sha256sum -c "$BASELINE" --status 2>/dev/null; then
    echo "FAIL: original archive $BZ2 no longer matches its content baseline (it was modified)"
    exit 1
  fi
else
  echo "FAIL: missing content baseline file $BASELINE (bootstrap issue)"
  exit 1
fi

if [[ ! -f "$GZ" ]]; then
  echo "FAIL: converted archive $GZ does not exist"
  exit 1
fi

filetype=$(file -b "$GZ")
if [[ "$filetype" != *"gzip compressed data"* ]]; then
  echo "FAIL: $GZ is not gzip-compressed data (file reports: '$filetype')"
  exit 1
fi

# gzip header "extra flags" byte at offset 8: 2 = level 9 (best), 4 = level 1
# (fastest), 0 = anything else, including tar -czf's silent default of 6.
xfl=$(od -An -tu1 -j8 -N1 "$GZ" | tr -d '[:space:]')
if [[ "$xfl" != "2" ]]; then
  echo "FAIL: $GZ was not compressed at gzip level 9 (header XFL byte='$xfl', expected 2)"
  exit 1
fi

if [[ ! -s "$BZ2_LIST" ]]; then
  echo "FAIL: sorted listing $BZ2_LIST is missing or empty"
  exit 1
fi

if [[ ! -s "$GZ_LIST" ]]; then
  echo "FAIL: sorted listing $GZ_LIST is missing or empty"
  exit 1
fi

if ! diff -q "$BZ2_LIST" "$GZ_LIST" >/dev/null 2>&1; then
  echo "FAIL: $BZ2_LIST and $GZ_LIST do not match -- archives do not contain the same content"
  exit 1
fi

actual_bz2_list=$(tar -tjf "$BZ2" | sort)
actual_gz_list=$(tar -tzf "$GZ" | sort)

if [[ "$actual_bz2_list" != "$(cat "$BZ2_LIST")" ]]; then
  echo "FAIL: $BZ2_LIST does not match the actual sorted contents of $BZ2"
  exit 1
fi

if [[ "$actual_gz_list" != "$(cat "$GZ_LIST")" ]]; then
  echo "FAIL: $GZ_LIST does not match the actual sorted contents of $GZ"
  exit 1
fi

echo "PASS: reports-2026-08.tar.gz created at gzip level 9, listings match, original bz2 archive untouched"
exit 0
