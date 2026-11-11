#!/usr/bin/env bash
set -eu
sudo systemctl set-property --runtime lfcs-memory.service MemoryMax=128M
