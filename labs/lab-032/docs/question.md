# Question

Solve this question on: `terminal`

You're auditing your own recent work before a handoff.

1. Configure your interactive shell, persistently, so that: history keeps the last `5000` commands in memory per session and `10000` lines on disk; consecutive duplicate commands and any command starting with a space are never recorded; and every history entry is timestamped in `YYYY-MM-DD HH:MM:SS` format.
2. Your shell history already contains commands from an earlier investigation session. Find the exact `ssh` command that was used to jump to `db-02`, and write it — verbatim, nothing else — into `~/recovered-ssh-command.txt`.
3. Find the exact command that was run immediately before that `ssh` command, and write it — verbatim, nothing else — into `~/command-before-ssh.txt`.
