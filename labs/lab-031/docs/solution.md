# Solution Walkthrough

Two files, two tools. `grep`, the signal scanner, pulls out the bot's lines without changing the source log. `sed`, the redaction officer, rewrites whole lines in the server log in place. Work from the real lines, preview before you write, and check each result.

---

## Step 1: Inspect both log files first

```bash
cd /var/log-collector/003
head nginx.log
head server.log
```

```text
203.0.113.10 - - [20/Aug/2026:10:12:01 +0000] "GET /app/user/profile HTTP/1.1" 200 512 "-" "hacker-bot/1.2"
203.0.113.11 - - [20/Aug/2026:10:12:05 +0000] "POST /app/user/settings HTTP/1.1" 200 128 "-" "hacker-bot/1.2"
203.0.113.12 - - [20/Aug/2026:10:13:02 +0000] "GET /app/user HTTP/1.1" 200 256 "-" "hacker-bot/1.2"
203.0.113.13 - - [20/Aug/2026:10:14:00 +0000] "GET /app/admin HTTP/1.1" 200 512 "-" "hacker-bot/1.2"
203.0.113.14 - - [20/Aug/2026:10:15:00 +0000] "GET /app/user/profile HTTP/1.1" 200 512 "-" "Mozilla/5.0"
container.web-01 status=Running uptime=24h
container.web-02 status=Stopped uptime=24h
container.db-01 status=Running uptime=24h
container.web-03 status=Running uptime=12h
container.web-04 status=Running uptime=24h
container.cache-01 status=Running uptime=24h
```

Look at the real lines before you write any pattern, so you build it against the actual format, not assumptions. `nginx.log` has five lines: one bot line asks for `/app/admin`, and one `/app/user` line comes from a normal browser. Neither of those may end up in the result.

---

## Step 2: Extract the nginx.log matches

```bash
grep '/app/user' nginx.log | grep 'hacker-bot/1\.2' > nginx.log.extracted
```

The URL and the browser identity are two independent conditions, so two chained `grep` commands are safer than one combined `.*` pattern. A single pattern only matches when the conditions appear in that exact order on the line. Escaping the dot in `1\.2` keeps it a real dot instead of "any character".

---

## Step 3: Check the extraction

```bash
cat nginx.log.extracted
wc -l nginx.log.extracted
```

```text
203.0.113.10 - - [20/Aug/2026:10:12:01 +0000] "GET /app/user/profile HTTP/1.1" 200 512 "-" "hacker-bot/1.2"
203.0.113.11 - - [20/Aug/2026:10:12:05 +0000] "POST /app/user/settings HTTP/1.1" 200 128 "-" "hacker-bot/1.2"
203.0.113.12 - - [20/Aug/2026:10:13:02 +0000] "GET /app/user HTTP/1.1" 200 256 "-" "hacker-bot/1.2"
3 nginx.log.extracted
```

Every line contains both `/app/user` and `hacker-bot/1.2`. Run `wc -l nginx.log` too: it should still report 5 lines, because `grep` never changes its input.

---

## Step 4: Preview the server.log redaction before you use `-i`

```bash
grep -E '^container\.web.*Running.*24h$' server.log
```

```text
container.web-01 status=Running uptime=24h
container.web-04 status=Running uptime=24h
```

`^` and `$` anchor the match to the whole line, and `.*` fills the "anywhere in between" part. This preview changes nothing, and it shows the pattern catches exactly the two intended lines. `web-02` is `Stopped`, `web-03` ends in `12h`, and `db-01` and `cache-01` are not `container.web`, so they stay.

---

## Step 5: Apply the redaction in place

```bash
sed -i -E 's/^container\.web.*Running.*24h$/SENSITIVE LINE REMOVED/' server.log
```

The left side of `s///` is the same anchored pattern you just previewed. The right side becomes the *entire* replacement line, not a swap of one word.

Always run a substitution without `-i` first and read the output: `sed -i` overwrites the file at once, with no undo.

---

## Step 6: Confirm the result and submit

```bash
grep -c 'SENSITIVE LINE REMOVED' server.log
grep -E '^container\.web.*Running.*24h$' server.log   # expect no output left
cat server.log
```

```text
2
SENSITIVE LINE REMOVED
container.web-02 status=Stopped uptime=24h
container.db-01 status=Running uptime=24h
container.web-03 status=Running uptime=12h
SENSITIVE LINE REMOVED
container.cache-01 status=Running uptime=24h
```

Two lines were redacted, the pattern finds nothing left, and every other line is unchanged and in its place. Back on your own machine, outside the lab terminal, send the mission for grading:

```bash
astrona submit -c labs/lab-031
```
