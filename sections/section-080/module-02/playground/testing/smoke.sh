#!/usr/bin/env bash
set -eu
command -v pidstat
systemctl cat lfcs-memory.service
sudo test -f /usr/local/bin/lfcs-memory-worker.py
