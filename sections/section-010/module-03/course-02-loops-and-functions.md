# Loops And Functions

Astronaut, a procedure often repeats one step over many crates. This part shows `for` and `while` loops, why quotes matter, and how a function names a step you use twice.

## The for loop

`for` runs a block once per item. A glob such as `*.txt` is turned into the list of matching names:

<!-- astrona:playground:renew -->

```sh
cd ~/scripts
cat > lines.sh <<'SCRIPT'
#!/bin/bash
for f in ~/inbox/*.txt; do
    n=$(wc -l < "$f")
    echo "$(basename "$f"): $n lines"
done
SCRIPT
chmod +x lines.sh
./lines.sh
```

Each line shows a file name and its line count, as `wc -l < FILE` counts lines without printing the name. `$(...)` stores the output of a command, and `basename` drops the folder.

### Quote every variable

A file called `my notes.txt` holds a space. Without quotes the shell splits it into two words and `wc` looks for two files that do not exist. Write `"$f"` every time. The same rule applies to `"$@"`, which keeps each argument whole.

### A folder with no matches

When no file matches `*.txt`, bash leaves the pattern as the plain text `*.txt` and the loop runs once with that text. Guard against it by testing the file inside the loop:

```sh
for f in ~/inbox/*.txt; do
    [[ -f "$f" ]] || continue
    echo "$f"
done
```

`continue` skips to the next item. `break` leaves the loop.

## The while loop

`while` repeats as long as its test succeeds. It is the usual way to read a file line by line:

```sh
while read -r line; do
    echo "got: $line"
done < /etc/os-release
```

`/etc/os-release` is a small text file that every Ubuntu machine has. `read -r` reads one line into `line` and fails at the end of the file, which ends the loop. A counter loop uses arithmetic:

```sh
i=1
while [[ $i -le 3 ]]; do
    echo "step $i"
    i=$((i + 1))
done
```

## Functions

A function gives a name to a few lines. Define it before you call it:

```sh
cat > fn.sh <<'SCRIPT'
#!/bin/bash
die() {
    echo "error: $1" >&2
    exit "${2:-1}"
}
[[ $# -gt 0 ]] || die "need an argument" 2
echo "ok: $1"
SCRIPT
chmod +x fn.sh
./fn.sh; echo "code $?"
./fn.sh crew; echo "code $?"
```

The first run prints `error: need an argument` on stderr and `code 2`. The second prints `ok: crew` and `code 0`. Inside a function, `$1` is the function's own first argument, and `${2:-1}` means "the second argument, or `1` if it is missing".

## Common pitfalls

> [!WARNING]
> - **Unquoted variables.** A name with a space splits into several words. Always write `"$var"`.
> - **Spaces around `=`.** `n = 5` runs a command called `n`. Write `n=5`.
> - **Reading `ls` output in a loop.** Use a glob such as `*.txt`, which keeps names intact.
> - **Using a function before it is defined.** The shell reads the file from the top.

## Your mission: Shell Script Arguments, Tests and Loops Lab

You can now read arguments, test them, loop over files and report an honest exit code. The mission asks for one script that counts the lines of every `.txt` file in a folder, with a usage message, an error for a missing folder and a total, and it must survive file names that hold spaces.

The mission runs on its own training ship, so first pause your playground. Nothing in it is lost:

```sh
astrona stop script-basics-playground
```

Then start the mission:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-013
```

Open a terminal on the mission ship:

```sh
astrona ssh ats-006-lab-013
```

Read the task in [the question](../../../labs/lab-013/docs/question.md) and solve it on your own first. When you think you are done, send it for grading from your own computer:

```sh
astrona submit -c labs/lab-013
```

When the mission is done, remove it and wake your playground up again:

```sh
astrona destroy ats-006-lab-013
astrona start script-basics-playground
```
