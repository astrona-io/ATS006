# Solution Walkthrough

This walkthrough captures each of the program's signal lines in its own file. `/bin/output-generator` always prints the line `OUTPUT_OK: primary payload generated` to stdout, the line `WARNING_STREAM: secondary diagnostic notice` to stderr, and exits with code `7`. Knowing that makes every file easy to check.

---

## Step 1: Prepare the output directory

```bash
sudo mkdir -p /var/output-generator
sudo chown "$(whoami)" /var/output-generator
```

`/var` belongs to root, so `sudo` creates the directory. `chown` then gives it to your own user, so the redirections below, which bash runs as your user, can create files in it.

---

## Step 2: Redirect only stdout

```bash
/bin/output-generator > /var/output-generator/1.out
```

Bash connects fd 1 (stdout) to `1.out`. Fd 2 (stderr) is not touched, so the warning line still prints on your terminal:

```text
WARNING_STREAM: secondary diagnostic notice
```

---

## Step 3: Redirect only stderr

```bash
/bin/output-generator 2> /var/output-generator/2.out
```

`2>` targets fd 2, with no space between `2` and `>`. Stdout is untouched, so the normal line prints on your terminal:

```text
OUTPUT_OK: primary payload generated
```

---

## Step 4: Redirect both stdout and stderr together

```bash
/bin/output-generator > /var/output-generator/3.out 2>&1
```

Bash reads this from left to right. `> 3.out` points fd 1 at the file first. Then `2>&1` points fd 2 at wherever fd 1 points now, which is the file. Both streams land in `3.out`. The bash shorthand `&> /var/output-generator/3.out` gives the same result.

The order matters. `2>&1 > /var/output-generator/3.out` (reversed) would capture only stdout, because `2>&1` would copy fd 1 while it still pointed at the terminal, before fd 1 moved to the file.

---

## Step 5: Capture the exit code

```bash
/bin/output-generator > /dev/null 2>&1
echo $? > /var/output-generator/4.out
```

`$?` holds the exit code of the most recently finished command. Read it in the very next command, with nothing in between, or bash overwrites it. Sending the program's output to `/dev/null` does not change the number in `$?`: where the text goes and the exit code are separate things.

---

## Step 6: Check the result and submit

```bash
cat /var/output-generator/1.out    # stdout only
cat /var/output-generator/2.out    # stderr only
cat /var/output-generator/3.out    # both, interleaved
cat /var/output-generator/4.out    # the numeric exit code
```

`1.out` holds only `OUTPUT_OK: primary payload generated`. `2.out` holds only `WARNING_STREAM: secondary diagnostic notice`. `3.out` holds both lines. `4.out` holds `7`.

From your own computer, not the lab machine, send the lab for grading:

```bash
astrona submit -c labs/lab-011
```
