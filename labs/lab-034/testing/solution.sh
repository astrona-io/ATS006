#!/usr/bin/env bash
set -euo pipefail
sudo -H -u candidate bash <<'CANDIDATE_SOLUTION'
set -euo pipefail
mkdir -p /home/candidate/report
cd /home/candidate/data
tail -n +2 crew.csv | sort -t, -k4 -nr | cut -d, -f1 > /home/candidate/report/by-hours.txt
sort visits.log | uniq -c | sort -rn > /home/candidate/report/visit-counts.txt
awk -F, '$2 == "engineer" { sum += $4 } END { print sum }' crew.csv > /home/candidate/report/engineer-hours.txt
tail -n +2 crew.csv | cut -d, -f2 | sort -u | tr a-z A-Z > /home/candidate/report/roles.txt
status=0
diff -u settings-old.conf settings-new.conf > /home/candidate/report/settings.diff || status=$?
test "$status" = 1

CANDIDATE_SOLUTION
