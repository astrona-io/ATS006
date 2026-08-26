#!/usr/bin/env bash
# Bootstrap: seeds /srv/teamspace/incoming with 10 files spanning every
# axis the graded triage task cares about -- two files pre-dating the
# 2021-06-01 cutoff (deleted outright regardless of size/permission), a
# small-and-777 file plus a large-and-777 file (to exercise the "order
# determines the winning rule" behavior -- size passes run before the
# permission pass), two purely-permission-777 files sized in the
# untouched middle range (these are the only ones that should reach
# quarantine/), and two "leave me alone" files that don't match any
# triage rule at all.
#
# The student's graded task (delete-by-age, then triage-by-size, then
# triage-by-permission) is NOT performed here.

set -eu

DIR=/srv/teamspace/incoming
sudo mkdir -p "$DIR"

# --- files older than the 2021-06-01 cutoff ---

sudo head -c 3072 /dev/zero | sudo tee "$DIR/legacy-audit.log" > /dev/null
sudo chmod 644 "$DIR/legacy-audit.log"
sudo touch -d "2019-08-01" "$DIR/legacy-audit.log"

sudo head -c 1024 /dev/zero | sudo tee "$DIR/legacy-notes.txt" > /dev/null
sudo chmod 600 "$DIR/legacy-notes.txt"
sudo touch -d "2020-12-31" "$DIR/legacy-notes.txt"

# --- small (<2KiB), recent mtime ---

sudo head -c 1024 /dev/zero | sudo tee "$DIR/small-note.txt" > /dev/null
sudo chmod 644 "$DIR/small-note.txt"

# small AND permission-777 -- the small-size pass runs before the
# permission pass, so this should end up in archive/small/, not quarantine/
sudo head -c 1024 /dev/zero | sudo tee "$DIR/small-open.cfg" > /dev/null
sudo chmod 777 "$DIR/small-open.cfg"

# --- large (>8KiB), recent mtime ---

sudo head -c 16384 /dev/zero | sudo tee "$DIR/big-dump.bin" > /dev/null
sudo chmod 644 "$DIR/big-dump.bin"

# large AND permission-777 -- the large-size pass runs before the
# permission pass, so this should end up in archive/large/, not quarantine/
sudo head -c 12288 /dev/zero | sudo tee "$DIR/big-open.bin" > /dev/null
sudo chmod 777 "$DIR/big-open.bin"

# --- mid-range size (2KiB-8KiB, matches neither small nor large),
# permission-777 -- these are the only files that should land in
# quarantine/ ---

sudo head -c 4096 /dev/zero | sudo tee "$DIR/open-payload.sh" > /dev/null
sudo chmod 777 "$DIR/open-payload.sh"

sudo head -c 6144 /dev/zero | sudo tee "$DIR/open-keys.env" > /dev/null
sudo chmod 777 "$DIR/open-keys.env"

# --- mid-range size, normal permissions -- should remain untouched at
# the top level after every pass ---

sudo head -c 5120 /dev/zero | sudo tee "$DIR/keep1.dat" > /dev/null
sudo chmod 644 "$DIR/keep1.dat"

sudo head -c 3584 /dev/zero | sudo tee "$DIR/keep2.dat" > /dev/null
sudo chmod 640 "$DIR/keep2.dat"
