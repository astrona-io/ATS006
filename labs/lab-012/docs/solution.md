# Solution Guide: Environment Variable Scope

This guide shows you how to create a script that correctly separates a shell-local variable from an exported one.

---

## Step 1: Confirm `VARIABLE1` exists and is exported

```bash
grep VARIABLE1 ~/.bashrc
export -p | grep VARIABLE1
```

Confirming it's genuinely exported (not just assigned) is what guarantees the script — a separate process — will actually inherit it.

---

## Step 2: Create the script file

```bash
mkdir -p /opt/course/4
touch /opt/course/4/script.sh
chmod +x /opt/course/4/script.sh
```

---

## Step 3: Write the script body

```bash
#!/bin/bash

VARIABLE2=v2
echo "$VARIABLE2"

export VARIABLE3="${VARIABLE1}-extended"
echo "$VARIABLE3"
```

- `VARIABLE2=v2` is a plain assignment — a shell variable local to this script's own process. No `export` needed since the task only requires it be visible inside the script itself.
- `export VARIABLE3="${VARIABLE1}-extended"` expands the inherited `VARIABLE1` value, appends the literal suffix, and immediately flags the result for inheritance by any child process the script might spawn.

> **Note:** Use double quotes around `"${VARIABLE1}-extended"`. Single quotes suppress expansion entirely and would export the literal text `${VARIABLE1}-extended` instead of the resolved value.

---

## Step 4: Run the script and verify

```bash
/opt/course/4/script.sh
```

Expected output:

```text
v2
random-string-extended
```

---

## Step 5: Confirm `.bashrc` was never touched

```bash
grep -c 'VARIABLE2\|VARIABLE3' ~/.bashrc
```

Expected: `0`.
