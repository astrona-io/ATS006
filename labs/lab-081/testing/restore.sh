#!/usr/bin/env bash
set -eu
sudo systemctl set-property --runtime lfcs-cpu.service CPUQuota=25%
