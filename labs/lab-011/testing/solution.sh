#!/usr/bin/env bash
set -euo pipefail
sudo mkdir -p /var/output-generator
sudo chown "$(id -un)" /var/output-generator
/bin/output-generator > /var/output-generator/1.out || true
/bin/output-generator 2> /var/output-generator/2.out || true
/bin/output-generator > /var/output-generator/3.out 2>&1 || true
status=0
/bin/output-generator > /dev/null 2>&1 || status=$?
printf '%s\n' "$status" > /var/output-generator/4.out

