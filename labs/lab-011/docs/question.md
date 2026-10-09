# Question

Solve this question on: `terminal` (playing the role of `app-srv1` from the scenario)

Astronaut, mission control has installed a diagnostic program on this ship at `/bin/output-generator`. It is a very predictable crew member: on every run it writes the same normal output to stdout, the same warning to stderr, and hands back the same exit code. Your job is to capture each of its signal lines on its own.

1. Create the directory `/var/output-generator`, owned by your own user (not root).
2. Run `/bin/output-generator` and redirect **only its stdout** into `/var/output-generator/1.out`.
3. Run `/bin/output-generator` and redirect **only its stderr** into `/var/output-generator/2.out`.
4. Run `/bin/output-generator` and redirect **both stdout and stderr** into `/var/output-generator/3.out`.
5. Run `/bin/output-generator` and write its numeric **exit code** into `/var/output-generator/4.out`.

The grader checks that `1.out` holds only the stdout line, `2.out` holds only the stderr line, `3.out` holds both, and `4.out` holds the program's exit code as a number.
