# Solution Walkthrough

Three aliases go into `~/.bashrc`, then one file is deleted with the real `rm` while the safety alias stays in place. The grader opens a fresh interactive shell to check each alias, opens a non-interactive shell to check that `rm` is the real program there, and checks that the file is gone.

---

## Step 1: Define and test each alias in the current shell

```bash
alias ll='ls -alF'
alias rm='rm -i'
alias myip="hostname -I | awk '{print \$1}'"
```

Run `myip` once to see it work: it prints one IPv4 address and nothing else. `hostname -I` lists all the machine's addresses, and `awk '{print $1}'` keeps only the first. The backslash in `\$1` stops the shell from expanding `$1` when it defines the alias.

A bare `alias name='command'` only lasts for the current shell. To survive a new session, it must also go into a startup file.

---

## Step 2: Persist them

Add these lines to the end of `~/.bashrc` (open it with `nano ~/.bashrc` or `vim ~/.bashrc`):

```bash
alias ll='ls -alF'
alias rm='rm -i'
alias myip="hostname -I | awk '{print \$1}'"
```

Apply it:

```bash
source ~/.bashrc
```

Ubuntu's default `~/.bashrc` usually already holds an `alias ll='ls -alF'` line; adding it again is harmless. Each line must start with `alias` at the very beginning of the line, because the grader looks for `alias ll=`, `alias rm=` and `alias myip=` there.

---

## Step 3: Confirm what each name resolves to

```bash
type ll
type rm
type myip
```

`type` reports each one as "aliased to ..." rather than a file path. That is the fast, reliable way to confirm an alias exists before you assume anything about a command's behaviour.

---

## Step 4: Delete the file with the real rm, bypassing the alias

```bash
\rm ~/lab-artifact-to-delete.txt
```

A leading backslash turns off alias expansion for that one word only. There is no confirmation prompt, and the `rm` alias stays defined and active for every other `rm` you type afterwards. `unalias rm`, deleting, then defining the alias again also works, but it is slower and easy to forget to undo.

This backslash trick only matters at the prompt. A script or a scheduled job calling `rm` never sees the alias in the first place, because non-interactive shells do not expand aliases by default.

---

## Step 5: Confirm the alias never reaches non-interactive shells

```bash
bash -c 'type rm'
```

`bash -c` starts a fresh non-interactive shell, so this reports the path of the real `rm` program, not the alias.

---

## Step 6: Check the result and submit

```bash
ls ~/lab-artifact-to-delete.txt
type rm
```

`ls` reports that the file does not exist, and `type rm` still shows `rm` aliased to `rm -i`. Back on your own machine, outside the lab terminal, send the mission for grading:

```bash
astrona submit -c labs/lab-033
```
