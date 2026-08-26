# Solution Guide: Shell Redirection & Exit Code Diagnostics

This guide shows you how to isolate, combine, and capture a program's output streams and exit status.

---

## Step 1: Prepare the output directory

```bash
sudo mkdir -p /var/output-generator
sudo chown "$(whoami)" /var/output-generator
```

`/bin/output-generator` is owned by root by default; the target directory needs to be writable by your own user before any of the redirected commands below can create files in it.

---

## Step 2: Redirect only stdout

```bash
/bin/output-generator > /var/output-generator/1.out
```

This connects fd 1 to `1.out`. Whatever the program writes to fd 2 is unaffected and still prints to the terminal.

---

## Step 3: Redirect only stderr

```bash
/bin/output-generator 2> /var/output-generator/2.out
```

`2>` targets fd 2 specifically, with no space between `2` and `>`. stdout is untouched and prints normally.

---

## Step 4: Redirect both stdout and stderr together

```bash
/bin/output-generator > /var/output-generator/3.out 2>&1
```

Read left to right: `> 3.out` points fd 1 at the file first, then `2>&1` points fd 2 at "wherever fd 1 currently points" — which is now the file. Both streams land in `3.out`. The bash shorthand `&> /var/output-generator/3.out` produces the same result.

> **Order matters:** `2>&1 > /var/output-generator/3.out` (reversed) would only capture stdout, because `2>&1` would bind fd 2 to the terminal (fd 1's location at that point) *before* fd 1 gets redirected to the file.

---

## Step 5: Capture the exit code

```bash
/bin/output-generator > /dev/null 2>&1
echo $? > /var/output-generator/4.out
```

`$?` holds the exit status of the most recently completed foreground command — read it in the very next command, with nothing run in between, or it gets overwritten. Redirecting the program's own output to `/dev/null` has no effect on the numeric value `$?` ends up holding; the two mechanisms are independent.

---

## Verification

```bash
cat /var/output-generator/1.out    # stdout only
cat /var/output-generator/2.out    # stderr only
cat /var/output-generator/3.out    # both, interleaved
cat /var/output-generator/4.out    # the numeric exit code
```
