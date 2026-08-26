#!/usr/bin/env bash
set -u

DIR=/srv/teamspace/incoming

# 1. Old files (pre-2021-06-01) must be gone entirely.
if [ -e "$DIR/legacy-audit.log" ] || [ -e "$DIR/legacy-notes.txt" ]; then
  echo "FAIL: file(s) modified before 2021-06-01 were not deleted"
  exit 1
fi

leftover_old=$(find "$DIR" -type f ! -newermt "2021-06-01" 2>/dev/null | wc -l)
if [ "$leftover_old" -ne 0 ]; then
  echo "FAIL: $leftover_old file(s) older than the 2021-06-01 cutoff still exist somewhere under $DIR"
  exit 1
fi

# 2. archive/small/ must contain exactly the two small files, and
# nothing 2KiB or larger.
if [ ! -f "$DIR/archive/small/small-note.txt" ] || [ ! -f "$DIR/archive/small/small-open.cfg" ]; then
  echo "FAIL: archive/small/ is missing one or both expected small files"
  exit 1
fi

oversized_in_small=$(find "$DIR/archive/small" -maxdepth 1 -type f -size +2k 2>/dev/null | wc -l)
if [ "$oversized_in_small" -ne 0 ]; then
  echo "FAIL: archive/small/ contains $oversized_in_small file(s) of 2KiB or larger"
  exit 1
fi

# 3. archive/large/ must contain exactly the two large files, and
# nothing 8KiB or smaller.
if [ ! -f "$DIR/archive/large/big-dump.bin" ] || [ ! -f "$DIR/archive/large/big-open.bin" ]; then
  echo "FAIL: archive/large/ is missing one or both expected large files"
  exit 1
fi

undersized_in_large=$(find "$DIR/archive/large" -maxdepth 1 -type f -size -8k 2>/dev/null | wc -l)
if [ "$undersized_in_large" -ne 0 ]; then
  echo "FAIL: archive/large/ contains $undersized_in_large file(s) of 8KiB or smaller"
  exit 1
fi

echo "PASS: old files deleted, and remaining files correctly split into archive/small and archive/large"
exit 0
