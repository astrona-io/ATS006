# Solution Walkthrough

This capstone combines four skills in one incident handoff: extracting lines with `grep`, redacting lines with `sed`, recovering commands from history, and persisting aliases. The grader checks the exact contents of every file, so preview before you write and copy commands exactly.

---

## Step 1: Extract the attacker's requests

```bash
cd /var/log-collector/incident
grep '/admin/login' access.log | grep '198.51.100.23' > attacker-requests.log
```

The URL and the source address are two independent conditions, so two chained `grep` commands are safer than one combined pattern: the order in which they appear on the line is not guaranteed.

Then check the result:

```bash
cat attacker-requests.log
wc -l access.log
```

```text
198.51.100.23 - - [21/Aug/2026:03:14:02 +0000] "POST /admin/login HTTP/1.1" 401 128 "-" "curl/7.81.0"
198.51.100.23 - - [21/Aug/2026:03:14:05 +0000] "POST /admin/login HTTP/1.1" 401 128 "-" "curl/7.81.0"
198.51.100.23 - - [21/Aug/2026:03:14:09 +0000] "POST /admin/login HTTP/1.1" 200 512 "-" "curl/7.81.0"
5 access.log
```

Three login requests from the attacker. The other address's login and the attacker's dashboard request were left out, and `access.log` still has all 5 lines.

---

## Step 2: Redact the brute-force lines in service.log

Preview first, without `-i`:

```bash
grep -E '^service\.auth.*bruteforce.*FAILED$' service.log
```

```text
service.auth attempt=bruteforce user=admin FAILED
service.auth attempt=bruteforce user=root FAILED
```

Exactly the two lines to redact. Then apply the change in place:

```bash
sed -i -E 's/^service\.auth.*bruteforce.*FAILED$/REDACTED - INCIDENT #4471/' service.log
```

`^` and `$` anchor the whole-line shape, and `.*bruteforce.*` covers "anywhere in between". Check the result:

```bash
cat service.log
```

```text
REDACTED - INCIDENT #4471
service.auth attempt=normal user=admin FAILED
service.web attempt=bruteforce user=admin FAILED
service.auth attempt=bruteforce user=admin SUCCESS
REDACTED - INCIDENT #4471
service.cache attempt=bruteforce status=FAILED
```

---

## Step 3: Recover the blocking command from history

```bash
history | grep ufw
```

The previous responder's session holds two `ufw` commands, one right after the other: `sudo ufw deny from 198.51.100.23` and then `sudo ufw status numbered`. Copy the exact `ufw deny` command:

```bash
echo 'sudo ufw deny from 198.51.100.23' > ~/blocking-command.txt
```

The line right after it in the same `history` output is the command that ran next:

```bash
echo 'sudo ufw status numbered' > ~/next-command.txt
```

---

## Step 4: Persist the aliases

Add these lines to the end of `~/.bashrc` (open it with `nano ~/.bashrc` or `vim ~/.bashrc`):

```bash
alias ll='ls -alF'
alias rm='rm -i'
alias report='grep -c "REDACTED - INCIDENT #4471" /var/log-collector/incident/service.log'
```

Apply it:

```bash
source ~/.bashrc
```

Then check the result:

```bash
report
```

```text
2
```

`report` prints `2`, the number of lines you redacted in step 2.

Aliases only work in your interactive shell. A script or a scheduled job that calls `rm` still runs the real, unchanged program, whatever is aliased here. Prove it:

```bash
bash -c 'type rm'
```

It reports the path of the real `rm` program, not the alias.

---

## Step 5: Check everything and submit

```bash
cat ~/blocking-command.txt ~/next-command.txt
```

```text
sudo ufw deny from 198.51.100.23
sudo ufw status numbered
```

Then confirm the aliases:

```bash
type ll rm report
```

The two recovered commands are exact, and `type` reports `ll`, `rm` and `report` as aliases. Back on your own machine, outside the lab terminal, send the mission for grading:

```bash
astrona submit -c labs/lab-030
```
