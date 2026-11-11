#!/usr/bin/env bash
set -euo pipefail
for tool in du rsync; do command -v "$tool"; done
