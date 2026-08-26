#!/usr/bin/env bash
# Bootstrap: seeds /var/backup/backup-015 with 10 files spanning every
# axis the graded task cares about -- two files pre-dating the cutoff
# (regardless of size/permission, since they get deleted outright), two
# files that are both small AND permission-777 or both large AND
# permission-777 (to exercise the "order determines the winning rule"
# behavior taught in the module), two purely-permission-777 files sized
# in the untouched middle range, and two "leave me alone" files that
# don't match any triage rule at all.
#
# The student's graded task (delete-by-age, then triage-by-size, then
# triage-by-permission) is NOT performed here.

set -eu

DIR=/var/backup/backup-015
sudo mkdir -p "$DIR"

# --- files older than the 2020-01-01 cutoff (any size/permission -- they
# get deleted outright, before size/permission ever matter) ---

sudo head -c 5120 /dev/zero | sudo tee "$DIR/ancient-report.log" > /dev/null
sudo chmod 644 "$DIR/ancient-report.log"
sudo touch -d "2018-03-15" "$DIR/ancient-report.log"

sudo head -c 1024 /dev/zero | sudo tee "$DIR/ancient-notes.txt" > /dev/null
sudo chmod 600 "$DIR/ancient-notes.txt"
sudo touch -d "2019-11-20" "$DIR/ancient-notes.txt"

# --- small (<3KiB), recent mtime ---

sudo head -c 1024 /dev/zero | sudo tee "$DIR/tiny-config.ini" > /dev/null
sudo chmod 644 "$DIR/tiny-config.ini"

# small AND permission-777 -- the small-size pass runs before the
# permission pass, so this should end up in small/, not compromised/
sudo head -c 1024 /dev/zero | sudo tee "$DIR/tiny-and-open.conf" > /dev/null
sudo chmod 777 "$DIR/tiny-and-open.conf"

# --- large (>10KiB), recent mtime ---

sudo head -c 20480 /dev/zero | sudo tee "$DIR/huge-dump.bin" > /dev/null
sudo chmod 644 "$DIR/huge-dump.bin"

# large AND permission-777 -- the large-size pass runs before the
# permission pass, so this should end up in large/, not compromised/
sudo head -c 15360 /dev/zero | sudo tee "$DIR/huge-open.log" > /dev/null
sudo chmod 777 "$DIR/huge-open.log"

# --- mid-range size (3KiB-10KiB, matches neither small nor large),
# permission-777 -- these are the only files that should land in
# compromised/ ---

sudo head -c 5120 /dev/zero | sudo tee "$DIR/open-script.sh" > /dev/null
sudo chmod 777 "$DIR/open-script.sh"

sudo head -c 8192 /dev/zero | sudo tee "$DIR/open-secrets.env" > /dev/null
sudo chmod 777 "$DIR/open-secrets.env"

# --- mid-range size, normal permissions -- should remain untouched at
# the top level after every pass ---

sudo head -c 6144 /dev/zero | sudo tee "$DIR/medium-keep1.dat" > /dev/null
sudo chmod 644 "$DIR/medium-keep1.dat"

sudo head -c 4608 /dev/zero | sudo tee "$DIR/medium-keep2.dat" > /dev/null
sudo chmod 640 "$DIR/medium-keep2.dat"
