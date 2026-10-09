# Question

Solve this question on: `terminal`

Astronaut, a web server on this ship has been probed by a scanning bot. Mission control needs the bot's requests pulled out of one log, and sensitive lines blacked out of another. Both log files are in `/var/log-collector/003/`.

1. In `nginx.log`, extract every log line where the URL starts with `/app/user` **and** the browser identity is `hacker-bot/1.2`. Write only those matching lines, and nothing else, into a new file named `nginx.log.extracted` in the same directory.
2. Do not change `nginx.log` itself. It must keep all of its lines.
3. In `server.log`, replace every line that starts with `container.web`, ends with `24h`, and has the word `Running` anywhere in between, with the exact literal text: `SENSITIVE LINE REMOVED`.
4. Every other line in `server.log` must stay exactly as it is, in the same order.
