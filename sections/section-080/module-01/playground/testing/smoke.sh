#!/usr/bin/env bash
set -eu
command -v pidstat
systemctl cat lfcs-cpu.service
sudo test -f /usr/local/bin/lfcs-cpu-worker.py
