#!/usr/bin/env bash
set -u

DIR=/var/backup/backup-015

# 1. Old files (pre-2020-01-01) must be gone entirely.
if [ -e "$DIR/ancient-report.log" ] || [ -e "$DIR/ancient-notes.txt" ]; then
  echo "FAIL: file(s) modified before 2020-01-01 were not deleted"
  exit 1
fi

leftover_old=$(find "$DIR" -type f ! -newermt "2020-01-01" 2>/dev/null | wc -l)
if [ "$leftover_old" -ne 0 ]; then
  echo "FAIL: $leftover_old file(s) older than the 2020-01-01 cutoff still exist somewhere under $DIR"
  exit 1
fi

# 2. small/ must contain exactly the two small files, and nothing >=3KiB.
if [ ! -f "$DIR/small/tiny-config.ini" ] || [ ! -f "$DIR/small/tiny-and-open.conf" ]; then
  echo "FAIL: small/ is missing one or both expected small files"
  exit 1
fi

oversized_in_small=$(find "$DIR/small" -maxdepth 1 -type f -size +3k 2>/dev/null | wc -l)
if [ "$oversized_in_small" -ne 0 ]; then
  echo "FAIL: small/ contains $oversized_in_small file(s) of 3KiB or larger"
  exit 1
fi

# 3. large/ must contain exactly the two large files, and nothing <=10KiB.
if [ ! -f "$DIR/large/huge-dump.bin" ] || [ ! -f "$DIR/large/huge-open.log" ]; then
  echo "FAIL: large/ is missing one or both expected large files"
  exit 1
fi

undersized_in_large=$(find "$DIR/large" -maxdepth 1 -type f -size -10k 2>/dev/null | wc -l)
if [ "$undersized_in_large" -ne 0 ]; then
  echo "FAIL: large/ contains $undersized_in_large file(s) of 10KiB or smaller"
  exit 1
fi

# 4. compromised/ must contain exactly the two mid-size 777 files, and
# every file inside must genuinely be 777.
if [ ! -f "$DIR/compromised/open-script.sh" ] || [ ! -f "$DIR/compromised/open-secrets.env" ]; then
  echo "FAIL: compromised/ is missing one or both expected permission-777 files"
  exit 1
fi

non_777_in_compromised=$(find "$DIR/compromised" -maxdepth 1 -type f ! -perm 0777 2>/dev/null | wc -l)
if [ "$non_777_in_compromised" -ne 0 ]; then
  echo "FAIL: compromised/ contains $non_777_in_compromised file(s) that are not permission 0777"
  exit 1
fi

# 5. The two mid-size, normal-permission files must remain untouched at
# the top level (not deleted, not moved anywhere).
if [ ! -f "$DIR/medium-keep1.dat" ] || [ ! -f "$DIR/medium-keep2.dat" ]; then
  echo "FAIL: the untouched mid-range files (medium-keep1.dat / medium-keep2.dat) are missing from the top level of $DIR"
  exit 1
fi

# 6. The top level should contain exactly those two remaining files (plus
# the three destination directories) -- nothing extra left behind, and
# nothing wrongly moved out of place.
top_level_files=$(find "$DIR" -maxdepth 1 -type f | wc -l)
if [ "$top_level_files" -ne 2 ]; then
  echo "FAIL: expected exactly 2 files remaining at the top level of $DIR, found $top_level_files"
  exit 1
fi

echo "PASS: old files deleted, and remaining files correctly triaged into small/, large/, and compromised/"
exit 0
