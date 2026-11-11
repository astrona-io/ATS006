#!/usr/bin/env bash
set -euo pipefail
for tool in grep awk find; do command -v "$tool"; done
