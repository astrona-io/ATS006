#!/usr/bin/env bash
set -euo pipefail
cd /var/log-collector/003
grep '/app/user' nginx.log | grep 'hacker-bot/1\.2' > nginx.log.extracted
sed -i -E 's/^container\.web.*Running.*24h$/SENSITIVE LINE REMOVED/' server.log

