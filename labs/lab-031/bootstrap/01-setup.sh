#!/usr/bin/env bash
# Bootstrap: seeds the two log files the scenario describes, with a mix
# of lines that should and should not survive the student's grep/sed
# task. Bootstrap does NOT perform the extraction or redaction itself.

set -eu

sudo mkdir -p /var/log-collector/003

sudo tee /var/log-collector/003/nginx.log > /dev/null << 'EOF'
203.0.113.10 - - [20/Aug/2026:10:12:01 +0000] "GET /app/user/profile HTTP/1.1" 200 512 "-" "hacker-bot/1.2"
203.0.113.11 - - [20/Aug/2026:10:12:05 +0000] "POST /app/user/settings HTTP/1.1" 200 128 "-" "hacker-bot/1.2"
203.0.113.12 - - [20/Aug/2026:10:13:02 +0000] "GET /app/user HTTP/1.1" 200 256 "-" "hacker-bot/1.2"
203.0.113.13 - - [20/Aug/2026:10:14:00 +0000] "GET /app/admin HTTP/1.1" 200 512 "-" "hacker-bot/1.2"
203.0.113.14 - - [20/Aug/2026:10:15:00 +0000] "GET /app/user/profile HTTP/1.1" 200 512 "-" "Mozilla/5.0"
EOF

sudo tee /var/log-collector/003/server.log > /dev/null << 'EOF'
container.web-01 status=Running uptime=24h
container.web-02 status=Stopped uptime=24h
container.db-01 status=Running uptime=24h
container.web-03 status=Running uptime=12h
container.web-04 status=Running uptime=24h
container.cache-01 status=Running uptime=24h
EOF

# The default login user needs to read/write these without needing to
# know their own username in advance -- open the permissions instead.
sudo chmod -R a+rwX /var/log-collector
