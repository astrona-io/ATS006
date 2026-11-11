#!/usr/bin/env bash
set -euo pipefail
for tool in tar rsync; do command -v "$tool"; done
