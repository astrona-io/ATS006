#!/usr/bin/env bash
set -u

NGINX_LOG=/var/log-collector/003/nginx.log
EXTRACTED=/var/log-collector/003/nginx.log.extracted
SERVER_LOG=/var/log-collector/003/server.log

if [ ! -f "$EXTRACTED" ]; then
  echo "FAIL: $EXTRACTED does not exist"
  exit 1
fi

expected_extracted='203.0.113.10 - - [20/Aug/2026:10:12:01 +0000] "GET /app/user/profile HTTP/1.1" 200 512 "-" "hacker-bot/1.2"
203.0.113.11 - - [20/Aug/2026:10:12:05 +0000] "POST /app/user/settings HTTP/1.1" 200 128 "-" "hacker-bot/1.2"
203.0.113.12 - - [20/Aug/2026:10:13:02 +0000] "GET /app/user HTTP/1.1" 200 256 "-" "hacker-bot/1.2"'

actual_extracted=$(cat "$EXTRACTED")

if [ "$actual_extracted" != "$expected_extracted" ]; then
  echo "FAIL: $EXTRACTED content does not match the expected 3 matching lines exactly"
  exit 1
fi

actual_nginx_lines=$(wc -l < "$NGINX_LOG" | tr -d '[:space:]')
if [ "$actual_nginx_lines" != "5" ]; then
  echo "FAIL: $NGINX_LOG has $actual_nginx_lines lines, expected 5 -- the source file must not be modified or truncated"
  exit 1
fi

if [ ! -f "$SERVER_LOG" ]; then
  echo "FAIL: $SERVER_LOG does not exist"
  exit 1
fi

expected_server='SENSITIVE LINE REMOVED
container.web-02 status=Stopped uptime=24h
container.db-01 status=Running uptime=24h
container.web-03 status=Running uptime=12h
SENSITIVE LINE REMOVED
container.cache-01 status=Running uptime=24h'

actual_server=$(cat "$SERVER_LOG")

if [ "$actual_server" != "$expected_server" ]; then
  echo "FAIL: $SERVER_LOG content does not match the expected redacted result exactly"
  exit 1
fi

echo "PASS: nginx.log.extracted contains exactly the matching lines and server.log was redacted correctly"
exit 0
