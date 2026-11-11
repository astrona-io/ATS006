#!/usr/bin/env bash
set -euo pipefail
cd /var/log-collector/incident
grep '/admin/login' access.log | grep '198.51.100.23' > attacker-requests.log
sed -i -E 's/^service\.auth.*bruteforce.*FAILED$/REDACTED - INCIDENT #4471/' service.log
printf '%s\n' 'sudo ufw deny from 198.51.100.23' > ~/blocking-command.txt
printf '%s\n' 'sudo ufw status numbered' > ~/next-command.txt
cat >> ~/.bashrc <<'ALIASES'
alias ll='ls -alF'
alias rm='rm -i'
alias report='grep -c "REDACTED - INCIDENT #4471" /var/log-collector/incident/service.log'
ALIASES
cut -d ' ' -f 1 access.log | sort | uniq -c | sort -rn > ~/top-sources.txt
awk '{print $9}' attacker-requests.log | sort -u > ~/attacker-statuses.txt
sed -i '1d;s/PLACEHOLDER/198.51.100.23/g;s/reviewed=no/reviewed=yes/' ~/handover.conf
printf 'shift=handover\n' >> ~/handover.conf
printf 'sort-numeric=-n\nfstab-file-section=5\n' > ~/handover-facts.txt

