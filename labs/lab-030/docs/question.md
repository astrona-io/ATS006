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
<!-- curriculum-links -->

## Related lessons and assessment

Read [module-01](../../../sections/section-030/module-01/course.md), [module-02](../../../sections/section-030/module-02/course.md), [module-03](../../../sections/section-030/module-03/course.md), [module-04](../../../sections/section-030/module-04/course.md), [module-05](../../../sections/section-030/module-05/course.md).

The grader checks:

- Confirms attacker-requests.log contains exactly the matching lines and access.log is untouched.
- Confirms service.log was redacted exactly where required and nowhere else.
- Confirms the ufw blocking command and the command run right after it were recovered correctly.
- Confirms ll, rm, and report aliases are persisted and functional in ~/.bashrc.
- Confirms a non-interactive shell never sees the rm safety alias.
- Confirms the report alias actually runs and prints the correct redacted-line count.
- Confirms top-sources.txt and attacker-statuses.txt hold the right counts and codes.
- Confirms handover.conf was edited exactly as required and handover-facts.txt holds the two manual-page facts.

Use the inspection commands in the solution to check your work. Submit when you have finished; submission ends this environment.
