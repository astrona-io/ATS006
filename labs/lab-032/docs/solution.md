# Solution Walkthrough

Two jobs: make the history settings permanent in `~/.bashrc`, then use the bridge's order log to recover two exact commands. The grader reads the `export` lines in `~/.bashrc` and compares the two files with the expected text byte for byte, so copy commands exactly.

---

## Step 1: Check the current settings

```bash
echo "HISTSIZE=$HISTSIZE HISTFILESIZE=$HISTFILESIZE HISTCONTROL=$HISTCONTROL"
```

This shows what your shell uses right now, before you change anything. Ubuntu's default `~/.bashrc` already sets some of these, with smaller values.

---

## Step 2: Persist the required settings

Add these lines to the end of `~/.bashrc` (open it with `nano ~/.bashrc` or `vim ~/.bashrc`):

```bash
export HISTSIZE=5000
export HISTFILESIZE=10000
export HISTCONTROL=ignoreboth
export HISTTIMEFORMAT="%F %T  "
```

Apply it:

```bash
source ~/.bashrc
```

`ignoreboth` is short for `ignoredups` (skip back-to-back duplicates) plus `ignorespace` (skip commands that start with a space), so one value covers both requirements. `HISTTIMEFORMAT` is a time format string: `%F %T` gives `YYYY-MM-DD HH:MM:SS`. Lines added at the end of the file win over the default values set earlier in it.

Then check the result:

```bash
echo "HISTSIZE=$HISTSIZE HISTFILESIZE=$HISTFILESIZE HISTCONTROL=$HISTCONTROL"
```

It now shows `HISTSIZE=5000 HISTFILESIZE=10000 HISTCONTROL=ignoreboth`.

---

## Step 3: Search history for the ssh command

```bash
history | grep ssh
```

Or press `Ctrl+R` and type `ssh` to get the same result with the reverse search. Among the matches you find the earlier session's command `ssh admin@db-02.internal`. Copy that exact text; do not retype it from memory.

---

## Step 4: Write the recovered command to its file

```bash
echo 'ssh admin@db-02.internal' > ~/recovered-ssh-command.txt
```

The exact text matters: a missing option or a retyped variant fails the byte-for-byte check, even if it would work the same.

---

## Step 5: Find and record the command that ran just before it

```bash
history | grep -B1 'ssh admin@db-02.internal'
```

`-B1` makes `grep` also print the one line before each match. The line directly above the `ssh` entry is the command that ran just before it: `sudo systemctl restart nginx`.

```bash
echo 'sudo systemctl restart nginx' > ~/command-before-ssh.txt
```

`ignoredups` only collapses back-to-back identical commands. It has no effect on finding a past entry, but remember it never removes repeats that are not back to back.

---

## Step 6: Check the result and submit

```bash
cat ~/recovered-ssh-command.txt
cat ~/command-before-ssh.txt
grep '^export HIST' ~/.bashrc
```

```text
ssh admin@db-02.internal
sudo systemctl restart nginx
export HISTSIZE=5000
export HISTFILESIZE=10000
export HISTCONTROL=ignoreboth
export HISTTIMEFORMAT="%F %T  "
```

Both files hold exactly one command, and the four settings are in `~/.bashrc`. Back on your own machine, outside the lab terminal, send the mission for grading:

```bash
astrona submit -c labs/lab-032
```
