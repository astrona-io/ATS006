#!/usr/bin/env bash
# Match the account used by astrona ssh, including its home and permissions.
sudo -H -u student bash <<'ASTRONA_STUDENT_SCRIPT'
# Bootstrap: seeds /srv/teamspace/release-src for the release-staging part.
# app.conf has a fixed mode (640) and a fixed modification time, so the
# grader can tell a copy that kept them from a plain copy. The staging
# itself (mkdir, cp, mv, ln, rm, chgrp) is the student's graded task and
# is NOT performed here.

set -eu

DIR=/srv/teamspace/release-src
sudo mkdir -p "$DIR"

sudo tee "$DIR/app.conf" > /dev/null <<'EOT'
release_channel=stable
max_crew=12
EOT
sudo chmod 640 "$DIR/app.conf"
sudo touch -d "2024-03-15 10:00:00 UTC" "$DIR/app.conf"

sudo tee "$DIR/old-release.txt" > /dev/null <<'EOT'
Release 2025.4 notes: superseded.
EOT

sudo mkdir -p "$DIR/tmp-build/cache"
echo "scratch" | sudo tee "$DIR/tmp-build/cache/build.tmp" > /dev/null
echo "scratch" | sudo tee "$DIR/tmp-build/output.tmp" > /dev/null
ASTRONA_STUDENT_SCRIPT
