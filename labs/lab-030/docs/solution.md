# Solution Guide: Everyday Shell Craft Capstone

This guide combines targeted grep/sed extraction, history reconstruction, and persistent aliases into one incident handoff.

---

## Step 1: Extract the attacker's requests

```bash
cd /var/log-collector/incident
grep '/admin/login' access.log | grep '198.51.100.23' > attacker-requests.log
```
Two independent conditions (URL prefix, source IP) are safer as two chained `grep`s than one combined regex, since the order they appear on the line isn't guaranteed.

---

## Step 2: Redact the brute-force lines in service.log

Preview first, without `-i`:
```bash
grep -E '^service\.auth.*bruteforce.*FAILED$' service.log
```
Then apply in place:
```bash
sed -i -E 's/^service\.auth.*bruteforce.*FAILED$/REDACTED - INCIDENT #4471/' service.log
```
`^`/`$` anchor the whole-line shape; `.*bruteforce.*` fills the "anywhere in between" requirement.

---

## Step 3: Recover the blocking command from history

```bash
history | grep ufw
```
Copy the exact `ufw deny` line found, then:
```bash
echo 'sudo ufw deny from 198.51.100.23' > ~/blocking-command.txt
```
Find the line immediately after it in that same `history` output, then:
```bash
echo 'sudo ufw status numbered' > ~/next-command.txt
```

---

## Step 4: Persist the aliases

```bash
cat >> ~/.bashrc << 'EOF'
alias ll='ls -alF'
alias rm='rm -i'
alias report='grep -c "REDACTED - INCIDENT #4471" /var/log-collector/incident/service.log'
EOF
source ~/.bashrc
report
```
`report` should now print `2` — the number of lines redacted in Step 2.

> **Note:** Aliases only fire in your interactive shell; a script or cron job calling `rm` still runs the real, unmodified binary, regardless of what's aliased here.
