# Question

Solve this question on: `terminal`

Astronaut, you are auditing your own recent work before you hand the ship over to the next shift. The bridge's order log, your shell history, must be set up properly, and two exact commands from an earlier investigation must be recovered.

1. Configure your interactive shell persistently, in `~/.bashrc`, so that:
   - history keeps the last `5000` commands in memory per session (`HISTSIZE`),
   - the history file on disk keeps `10000` lines (`HISTFILESIZE`),
   - consecutive duplicate commands and any command that starts with a space are never recorded (`HISTCONTROL`),
   - every history entry is timestamped in `YYYY-MM-DD HH:MM:SS` format (`HISTTIMEFORMAT`).

   Set each one as an `export` line, for example `export HISTSIZE=5000`.
2. Your shell history already contains the commands of an earlier investigation session. Find the exact `ssh` command that was used to jump to `db-02`, and write it, verbatim and nothing else, into `~/recovered-ssh-command.txt`.
3. Find the exact command that ran immediately before that `ssh` command, and write it, verbatim and nothing else, into `~/command-before-ssh.txt`.
