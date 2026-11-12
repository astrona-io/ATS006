#!/usr/bin/env bash
set -euo pipefail
echo 'umask 027' | sudo tee -a /home/candidate/.bash_profile
sudo chown candidate:candidate /home/candidate/.bash_profile

