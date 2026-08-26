# Solution Guide: Command Aliases

This guide shows you how to define persistent aliases correctly, and how to bypass one without removing it.

---

## Step 1: Define and test each alias in the current shell

```bash
alias ll='ls -alF'
alias rm='rm -i'
alias myip="hostname -I | awk '{print \$1}'"
```
A bare `alias name='command'` only lasts for the current shell — it also has to be written to a startup file to survive a new session.

---

## Step 2: Persist them

```bash
cat >> ~/.bashrc << 'EOF'
alias ll='ls -alF'
alias rm='rm -i'
alias myip="hostname -I | awk '{print \$1}'"
EOF
source ~/.bashrc
```

---

## Step 3: Confirm what each name resolves to

```bash
type ll
type rm
type myip
```
`type` reports each as "aliased to ..." rather than a file path — the fast, authoritative way to confirm an alias exists before assuming anything about a command's behavior.

---

## Step 4: Delete the artifact with the real rm, bypassing the alias

```bash
\rm ~/lab-artifact-to-delete.txt
```
A leading backslash skips alias expansion for that one word only — no confirmation prompt, and the `rm` alias stays fully defined and active for every other `rm` typed afterward. `unalias rm`, deleting, then re-aliasing works too, but is slower and easy to forget to redo.

> **Note:** This backslash trick only matters interactively — a script or cron job calling `rm` never sees the alias in the first place, since aliases are not expanded in non-interactive shells by default.

---

## Step 5: Confirm the alias never reaches non-interactive contexts

```bash
bash -c 'type rm'
```
Run as a fresh non-interactive shell, this reports the real `/usr/bin/rm` path, not the alias.
