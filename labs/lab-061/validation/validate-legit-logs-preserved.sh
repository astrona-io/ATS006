#!/usr/bin/env bash
# Confirms the legitimate reporting-app.log.* files were not deleted as
# part of the fix -- the task must be solved without touching real data.

set -u

for f in reporting-app.log.1 reporting-app.log.2 reporting-app.log.3; do
  if [[ ! -f "/var/log/reporting-app/$f" ]]; then
    echo "FAIL: legitimate log file $f was removed - space must be reclaimed without deleting real application logs"
    exit 1
  fi
done

echo "PASS: all legitimate reporting-app log files are still present"
exit 0
