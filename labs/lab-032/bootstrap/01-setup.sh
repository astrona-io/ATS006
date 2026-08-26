#!/usr/bin/env bash
# Bootstrap: seeds a plausible prior investigation session into this
# user's bash history file so there's real content to search and
# reconstruct. This does NOT configure any of the HISTSIZE/HISTFILESIZE/
# HISTCONTROL/HISTTIMEFORMAT behavior itself -- that persistence is the
# student's own graded task.

set -eu

cat > "$HOME/.bash_history" << 'EOF'
cd /var/log-collector/incident
ls -la
sudo systemctl status nginx
sudo tail -n 100 /var/log/syslog
grep -i error /var/log/syslog | tail -20
sudo systemctl restart nginx
ssh admin@db-02.internal
sudo journalctl -u nginx --since "2 hours ago" | tail -40
df -h
free -m
exit
EOF

chmod 600 "$HOME/.bash_history"
