#!/usr/bin/env bash
set -euo pipefail
cd /home/candidate/cargo
mkdir -p archive/2026/q1
cp -p manifest.txt archive/2026/q1/
mv old-crew.txt archive/2026/
ln crew.txt crew-hard.txt
ln -s crew.txt crew-soft.txt
rm -r scratch
sudo chgrp -R loaders crates

