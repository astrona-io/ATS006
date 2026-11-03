# Question

Solve this question on: `terminal`

Astronaut, you are the incident responder handing a compromised web server over to the next shift. Everything you need is under `/var/log-collector/incident/` and in your own shell history.

1. In `/var/log-collector/incident/access.log`, extract every line where the URL starts with `/admin/login` **and** the source IP address is `198.51.100.23`. Write only those matching lines, and nothing else, into a new file `/var/log-collector/incident/attacker-requests.log`. Do not change `access.log` itself.
2. In `/var/log-collector/incident/service.log`, replace every line that starts with `service.auth`, ends with `FAILED`, and has the word `bruteforce` anywhere in between, with the exact literal text: `REDACTED - INCIDENT #4471`. Leave every other line untouched.
3. Your shell history already contains the previous responder's session. Find the exact command they ran to block the attacker's IP address with `ufw`, and write it, verbatim, into `~/blocking-command.txt`. Find the exact command that ran immediately after it, and write it, verbatim, into `~/next-command.txt`.
4. Persist the following aliases for your user, in `~/.bashrc`:
   - `ll` for `ls -alF`
   - a safety alias so `rm` always runs `rm -i`
   - `report`, which prints the current count of redacted lines in `/var/log-collector/incident/service.log`, that is `grep -c "REDACTED - INCIDENT #4471" /var/log-collector/incident/service.log`

   The aliases must only work in interactive shells: a non-interactive shell (such as `bash -c 'type rm'`) must still see the real `rm` program.
5. Build two small reports with the filter tools `cut`, `awk`, `sort` and `uniq`, not by typing the answer. Write them in your home directory.
   - `~/top-sources.txt`: one line per source IP address in `/var/log-collector/incident/access.log`, with the number of requests, a space and the address, with the busiest address first. Extra spaces in front of the number are fine.
   - `~/attacker-statuses.txt`: the HTTP status codes in `/var/log-collector/incident/attacker-requests.log` (the file from step 1), each code once, sorted, one per line.
6. The handover note `~/handover.conf` is half filled in. Edit it with `vim` or `nano`:
   - Replace `PLACEHOLDER` with the attacker's IP address, `198.51.100.23`.
   - Change the line `reviewed=no` to `reviewed=yes`.
   - Delete the comment line at the top of the file.
   - Add a new last line: `shift=handover`.
7. Create `~/handover-facts.txt` with two lines. Find both facts in the manual pages, not from memory.
   - `sort-numeric=<option>`: the option of `sort` that compares by numeric value, with the dash, for example `-x`.
   - `fstab-file-section=<N>`: the number of the manual section that describes the **file format** of `/etc/fstab`.
