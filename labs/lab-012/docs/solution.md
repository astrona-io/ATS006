# Solution Walkthrough

This walkthrough builds a script that keeps one variable local and exports another one, built from a variable that is already in the environment. The grader runs the script, compares its output, reads its lines, and starts a child shell from it to check what the child can see.

---

## Step 1: Confirm `VARIABLE1` exists and is exported

```bash
grep VARIABLE1 ~/.bashrc
export -p | grep VARIABLE1
```

The first command shows the `export VARIABLE1=random-string` line in `~/.bashrc`. The second shows that the variable is really exported in your current shell. That matters: the script runs as a separate child process, and it only gets `VARIABLE1` because it is exported.

---

## Step 2: Create the script directory

```bash
mkdir -p /opt/course/4
```

If `mkdir` reports `Permission denied`, `/opt` belongs to root. Create the directory with `sudo mkdir -p /opt/course/4` and give it to your user with `sudo chown "$(whoami)" /opt/course/4`.

---

## Step 3: Write the script

Save this as `/opt/course/4/script.sh`:

```bash
#!/bin/bash

VARIABLE2=v2
echo "$VARIABLE2"

export VARIABLE3="${VARIABLE1}-extended"
echo "$VARIABLE3"
```

- `VARIABLE2=v2` is a plain assignment: a shell variable that only this script's own process sees. It needs no `export`, because the task only wants it inside the script.
- `export VARIABLE3="${VARIABLE1}-extended"` expands the inherited `VARIABLE1`, adds the text `-extended`, and marks the result so every child process the script starts gets a copy.

Use double quotes around `"${VARIABLE1}-extended"`. Single quotes stop expansion and would export the literal text `${VARIABLE1}-extended` instead of the value.

Apply it:

```bash
chmod +x /opt/course/4/script.sh
```

---

## Step 4: Run the script

```bash
/opt/course/4/script.sh
```

Expected output:

```text
v2
random-string-extended
```

The first line comes from `VARIABLE2`. The second is `VARIABLE1`'s value `random-string` with `-extended` added.

---

## Step 5: Confirm `.bashrc` was never touched

```bash
grep -c 'VARIABLE2\|VARIABLE3' ~/.bashrc
```

Expected: `0`. Neither new variable appears in `~/.bashrc`.

---

## Step 6: Submit

From your own computer, not the lab machine, send the lab for grading:

```bash
astrona submit -c labs/lab-012
```
