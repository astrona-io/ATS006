#!/usr/bin/env bash
# Match the account used by astrona ssh, including its home and permissions.
sudo -H -u student bash <<'ASTRONA_STUDENT_SCRIPT'
# OS preparation for PLAYGROUND - Searching and Rewriting Text with grep and sed
# Runs once when the environment comes up. It seeds a small practice scene.
# There is no task and no grading: poke at it freely.
set -euo pipefail

LEARNER=candidate
if ! id "$LEARNER" >/dev/null 2>&1; then
    sudo useradd -m -s /bin/bash "$LEARNER"
fi
LEARNER_HOME=$(getent passwd "$LEARNER" | cut -d: -f6)

as_learner() {
    sudo -u "$LEARNER" "$@"
}

as_learner mkdir -p "$LEARNER_HOME/logs"
as_learner tee "$LEARNER_HOME/logs/access.log" >/dev/null <<'EOF'
10.0.0.5 - - [03/Nov/2026:10:00:01] "GET /index.html HTTP/1.1" 200 512
10.0.0.6 - - [03/Nov/2026:10:00:02] "GET /missing.html HTTP/1.1" 404 128
10.0.0.5 - - [03/Nov/2026:10:00:03] "POST /login HTTP/1.1" 200 64
10.0.0.7 - - [03/Nov/2026:10:00:04] "GET /api/orders HTTP/1.1" 500 32
10.0.0.8 - - [03/Nov/2026:10:00:05] "GET /index.html HTTP/1.1" 200 512
10.0.0.6 - - [03/Nov/2026:10:00:06] "GET /old.html HTTP/1.1" 404 128
10.0.0.9 - - [03/Nov/2026:10:00:07] "GET /api/orders HTTP/1.1" 500 32
10.0.0.5 - - [03/Nov/2026:10:00:08] "GET /about.html HTTP/1.1" 200 256
10.0.0.7 - - [03/Nov/2026:10:00:09] "GET /index.html HTTP/1.1" 200 512
10.0.0.8 - - [03/Nov/2026:10:00:10] "GET /api/status HTTP/1.1" 200 16
EOF
as_learner tee "$LEARNER_HOME/logs/app.log" >/dev/null <<'EOF'
service started
user login ok email=pilot@example.com password=hunter2 session=41
cache warmed
user login failed email=guest@example.com password=letmein session=42
service stopped
EOF

echo "[playground] ready. Try:  grep -c ' 500 ' ~/logs/access.log   sed -E 's/password=[^ ]+/password=REDACTED/' ~/logs/app.log"
ASTRONA_STUDENT_SCRIPT
