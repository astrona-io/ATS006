# Solution Walkthrough

Write `/home/candidate/scripts/count-lines.sh`: it checks its argument, loops over the text files and reports with the right exit code. Work through the steps in order, and check the result after each one.

---

## Step 1: Create the script and handle the wrong calls first

Start with the two error cases, because they stop the script before any real work happens. `$#` is the number of arguments, `-d` tests for a directory, and `>&2` sends a message to stderr.

Save this as `/home/candidate/scripts/count-lines.sh`:

```bash
#!/usr/bin/env bash
if [ "$#" -eq 0 ]; then
    echo "usage: count-lines.sh <directory>" >&2
    exit 2
fi

target_dir=$1
if [ ! -d "$target_dir" ]; then
    echo "not a directory: $target_dir" >&2
    exit 1
fi
```

Apply it:

```sh
chmod +x /home/candidate/scripts/count-lines.sh
```

Then check the result:

```sh
/home/candidate/scripts/count-lines.sh; echo "exit code: $?"
/home/candidate/scripts/count-lines.sh /nonexistent-folder; echo "exit code: $?"
```

The first call prints the usage line and the exit code `2`. The second prints `not a directory: /nonexistent-folder` and the exit code `1`.

---

## Step 2: Add the loop and the total

Now add the real work to the end of the same file. The quotes around `"$file"` keep a file name with spaces in one piece. The `[ -e "$file" ]` test skips the case where no file matches and the shell leaves the pattern as plain text.

Add these lines to the end of `/home/candidate/scripts/count-lines.sh`:

```bash

total=0
for file in "$target_dir"/*.txt; do
    [ -e "$file" ] || continue
    count=$(wc -l < "$file")
    echo "$(basename "$file"): $count lines"
    total=$((total + count))
done
echo "total: $total lines"
```

Then check the result:

```sh
/home/candidate/scripts/count-lines.sh /home/candidate/inbox; echo "exit code: $?"
```

```text
alpha.txt: 2 lines
bravo.txt: 5 lines
charlie.txt: 9 lines
total: 16 lines
exit code: 0
```

`wc -l < "$file"` reads the file on stdin, so `wc` prints only the number and not the file name.

---

## Step 3: Submit

Leave the lab machine and send the mission for grading:

```bash
astrona submit -c labs/lab-013
```
