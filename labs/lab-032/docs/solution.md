# Solution Guide: Shell Command History Recall & Configuration

This guide shows you how to persist history behavior and use recall tools to reconstruct a past command sequence.

---

## Step 1: Check the current configuration

```bash
echo "HISTSIZE=$HISTSIZE HISTFILESIZE=$HISTFILESIZE HISTCONTROL=$HISTCONTROL"
```

---

## Step 2: Persist the required settings

```bash
cat >> ~/.bashrc << 'EOF'
export HISTSIZE=5000
export HISTFILESIZE=10000
export HISTCONTROL=ignoreboth
export HISTTIMEFORMAT="%F %T  "
EOF
source ~/.bashrc
```
`ignoreboth` is shorthand for `ignoredups` (skip consecutive duplicates) plus `ignorespace` (skip space-prefixed commands) in a single value — both requirements from the task in one setting. `HISTTIMEFORMAT` is a `strftime` string; `%F %T` produces `YYYY-MM-DD HH:MM:SS`.

---

## Step 3: Search history for the ssh command

```bash
history | grep ssh
```
Or press `Ctrl+R` and type `ssh` for the same result via reverse incremental search. Either way, note the exact command text — copy it, don't retype it from memory.

---

## Step 4: Write the recovered command to file

```bash
echo 'ssh admin@db-02.internal' > ~/recovered-ssh-command.txt
```
Exact text matters here: a missing flag or a retyped variant fails byte-for-byte grading even if it's functionally similar.

---

## Step 5: Identify and record the command that ran immediately before it

```bash
history | grep -B1 'ssh admin@db-02.internal'
```
The line directly above the `ssh` entry in that output is the one that ran immediately before it.

```bash
echo 'sudo systemctl restart nginx' > ~/command-before-ssh.txt
```

> **Note:** `ignoredups` only collapses *consecutive* identical commands — it has no bearing on finding a specific past entry, but it's worth remembering it never deduplicates repeats that aren't back-to-back.
