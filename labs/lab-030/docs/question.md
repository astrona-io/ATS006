# Question

Solve this question on: `terminal`

You're the incident-response engineer handing off a compromised web host to the next shift. Everything you need is under `/var/log-collector/incident/` and in your own shell history.

1. In `/var/log-collector/incident/access.log`, extract every line where the URL starts with `/admin/login` and the source IP is `198.51.100.23`. Write only those matching lines, and nothing else, into a new file `/var/log-collector/incident/attacker-requests.log`.
2. In `/var/log-collector/incident/service.log`, replace every line that starts with `service.auth`, ends with `FAILED`, and has the word `bruteforce` anywhere in between, with the exact literal text: `REDACTED - INCIDENT #4471`. Leave every other line untouched.
3. Your shell history already contains the previous responder's session. Find the exact command they ran to block the attacker's IP with `ufw`, and write it — verbatim — into `~/blocking-command.txt`. Find the exact command that ran immediately after it, and write it — verbatim — into `~/next-command.txt`.
4. Persist the following aliases for your user, in `~/.bashrc`:
   - `ll` for `ls -alF`
   - a safety alias so `rm` always runs `rm -i`
   - `report` that prints the current count of redacted lines in `/var/log-collector/incident/service.log` (i.e. `grep -c "REDACTED - INCIDENT #4471" /var/log-collector/incident/service.log`)
