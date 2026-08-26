#!/usr/bin/env bash
set -u

DIR=/srv/teamspace/incoming

# 1. quarantine/ must contain exactly the two mid-size 777 files, and
# every file inside must genuinely be 777.
if [ ! -f "$DIR/quarantine/open-payload.sh" ] || [ ! -f "$DIR/quarantine/open-keys.env" ]; then
  echo "FAIL: quarantine/ is missing one or both expected permission-777 files"
  exit 1
fi

non_777_in_quarantine=$(find "$DIR/quarantine" -maxdepth 1 -type f ! -perm 0777 2>/dev/null | wc -l)
if [ "$non_777_in_quarantine" -ne 0 ]; then
  echo "FAIL: quarantine/ contains $non_777_in_quarantine file(s) that are not permission 0777"
  exit 1
fi

# 2. The two mid-size, normal-permission files must remain untouched at
# the top level (not deleted, not moved anywhere).
if [ ! -f "$DIR/keep1.dat" ] || [ ! -f "$DIR/keep2.dat" ]; then
  echo "FAIL: the untouched mid-range files (keep1.dat / keep2.dat) are missing from the top level of $DIR"
  exit 1
fi

# 3. The top level should contain exactly those two remaining files --
# nothing extra left behind, and nothing wrongly moved out of place.
top_level_files=$(find "$DIR" -maxdepth 1 -type f | wc -l)
if [ "$top_level_files" -ne 2 ]; then
  echo "FAIL: expected exactly 2 files remaining at the top level of $DIR, found $top_level_files"
  exit 1
fi

# 4. No 777 file should remain anywhere outside quarantine/ (i.e. the
# order-dependent small-and-777 / large-and-777 files must have been
# claimed by their size pass, not left behind as loose 777 files).
stray_777=$(find "$DIR" -maxdepth 1 -type f -perm 0777 2>/dev/null | wc -l)
if [ "$stray_777" -ne 0 ]; then
  echo "FAIL: found $stray_777 permission-777 file(s) still at the top level of $DIR, expected all to be in quarantine/"
  exit 1
fi

echo "PASS: permission-777 files correctly quarantined, and untouched files remain in place"
exit 0
