# Solution Guide: Targeted Extraction with grep and Redaction with sed

This guide shows you how to extract lines matching multiple independent conditions with `grep`, and redact whole lines matching a shape with `sed`.

---

## Step 1: Inspect both log files first

```bash
cd /var/log-collector/003
head nginx.log
head server.log
```
Look at real lines before writing any regex — build the pattern against actual formatting, not assumptions.

---

## Step 2: Extract the nginx.log matches

```bash
grep '/app/user' nginx.log | grep 'hacker-bot/1\.2' > nginx.log.extracted
```
Two independent conditions (URL prefix and user-agent) are safer as two chained `grep`s than one combined `.*` regex, since a single regex only matches when the conditions appear in that exact order on the line. Escaping the dot in `1\.2` keeps it a literal dot instead of "any character."

---

## Step 3: Verify the extraction

```bash
cat nginx.log.extracted
wc -l nginx.log.extracted
```
Every line should visibly contain both `/app/user` and `hacker-bot/1.2`, and `nginx.log` itself should still have its original line count.

---

## Step 4: Preview the server.log redaction before touching `-i`

```bash
grep -E '^container\.web.*Running.*24h$' server.log
```
`^` and `$` anchor the match to the whole line; `.*` fills the "anywhere in between" requirement. Running this as a preview (no `-i`) confirms the regex catches exactly the intended lines with zero risk.

---

## Step 5: Apply the redaction in place

```bash
sed -i -E 's/^container\.web.*Running.*24h$/SENSITIVE LINE REMOVED/' server.log
```
The left side of `s///` is the same anchored pattern just previewed; the right side becomes the *entire* replacement line, not an inline word swap.

> **Note:** Always run a substitution without `-i` first and read the output before committing — `sed -i` overwrites the file immediately with no undo.

---

## Step 6: Confirm the result

```bash
grep -c 'SENSITIVE LINE REMOVED' server.log
grep -E '^container\.web.*Running.*24h$' server.log   # expect no output left
```
