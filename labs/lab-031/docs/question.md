# Question

Solve this question on: `terminal` (playing the role of `web-srv1` from the scenario)

On this server there are two log files that need to be worked with, both under `/var/log-collector/003/`:

1. `nginx.log`: extract all log lines where the URL starts with `/app/user` and that were accessed by browser identity `hacker-bot/1.2`. Write only those matching lines, and nothing else, into a new file named `nginx.log.extracted` in the same directory.
2. `server.log`: replace all lines that start with `container.web`, end with `24h`, and have the word `Running` anywhere in between, with the exact literal text: `SENSITIVE LINE REMOVED`. Every other line in `server.log` must remain completely untouched.
