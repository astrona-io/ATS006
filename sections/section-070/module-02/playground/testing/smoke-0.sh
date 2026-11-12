#!/usr/bin/env bash
set -euo pipefail
for tool in openssl systemctl; do command -v "$tool"; done
