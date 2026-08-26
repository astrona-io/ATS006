# Question

Solve this question on: `terminal` (playing the role of `app-srv1` from the scenario)

There is a program `/bin/output-generator` on this machine. It always produces the exact same output and the exact same exit code on every run.

1. Create the directory `/var/output-generator` (owned by your own user, not root).
2. Run `/bin/output-generator` and redirect **only its stdout** into `/var/output-generator/1.out`.
3. Run `/bin/output-generator` and redirect **only its stderr** into `/var/output-generator/2.out`.
4. Run `/bin/output-generator` and redirect **both stdout and stderr** into `/var/output-generator/3.out`.
5. Run `/bin/output-generator` and write its numeric **exit code** into `/var/output-generator/4.out`.
