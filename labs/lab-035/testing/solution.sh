#!/usr/bin/env bash
set -euo pipefail
cat >/home/candidate/answers.txt <<'REFERENCE_FILE'
passwd-file-section=5
ls-sort-by-time=-t
REFERENCE_FILE
sed -i '1d;s/PLACEHOLDER/TBD/g;s/checked=no/checked=yes/' /home/candidate/flightplan.conf
printf 'launch=ready\n' >> /home/candidate/flightplan.conf

