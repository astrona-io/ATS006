#!/usr/bin/env bash
set -euo pipefail
mkdir -p /opt/course/4
cat >/opt/course/4/script.sh <<'REFERENCE_FILE'
#!/bin/bash

VARIABLE2=v2
echo "$VARIABLE2"

export VARIABLE3="${VARIABLE1}-extended"
echo "$VARIABLE3"
REFERENCE_FILE
chmod +x /opt/course/4/script.sh

