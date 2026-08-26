#!/usr/bin/env bash
# Bootstrap: builds the capstone's starting state -- the two incident log
# files with a mix of matching/decoy lines, and a seeded shell history
# recording the previous responder's session. Bootstrap does NOT perform
# any of the extraction, redaction, history recovery, or alias tasks
# themselves.

set -eu

sudo mkdir -p /var/log-collector/incident

sudo tee /var/log-collector/incident/access.log > /dev/null << 'EOF'
198.51.100.23 - - [21/Aug/2026:03:14:02 +0000] "POST /admin/login HTTP/1.1" 401 128 "-" "curl/7.81.0"
198.51.100.23 - - [21/Aug/2026:03:14:05 +0000] "POST /admin/login HTTP/1.1" 401 128 "-" "curl/7.81.0"
198.51.100.23 - - [21/Aug/2026:03:14:09 +0000] "POST /admin/login HTTP/1.1" 200 512 "-" "curl/7.81.0"
203.0.113.50 - - [21/Aug/2026:03:15:00 +0000] "POST /admin/login HTTP/1.1" 401 128 "-" "Mozilla/5.0"
198.51.100.23 - - [21/Aug/2026:03:16:00 +0000] "GET /admin/dashboard HTTP/1.1" 200 2048 "-" "curl/7.81.0"
EOF

sudo tee /var/log-collector/incident/service.log > /dev/null << 'EOF'
service.auth attempt=bruteforce user=admin FAILED
service.auth attempt=normal user=admin FAILED
service.web attempt=bruteforce user=admin FAILED
service.auth attempt=bruteforce user=admin SUCCESS
service.auth attempt=bruteforce user=root FAILED
service.cache attempt=bruteforce status=FAILED
EOF

# The default login user needs to read/write these without needing to
# know their own username in advance -- open the permissions instead.
sudo chmod -R a+rwX /var/log-collector

cat > "$HOME/.bash_history" << 'EOF'
cd /var/log-collector/incident
tail -f service.log
sudo systemctl status nginx
grep bruteforce service.log
sudo ufw deny from 198.51.100.23
sudo ufw status numbered
sudo systemctl restart nginx
exit
EOF

chmod 600 "$HOME/.bash_history"
