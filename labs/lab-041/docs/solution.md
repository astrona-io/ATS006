# Solution Guide: Git Fundamentals

This guide walks through initializing a repository, committing isolated changes, and wiring up a local remote.

---

## Step 1: Initialize the repository

```bash
mkdir -p /home/candidate/projects/log-parser
cd /home/candidate/projects/log-parser
git init
```

`git init` only creates the `.git/` object database — no commits exist yet and `git log` would error until the first commit is made.

---

## Step 2: Create the initial files and commit them

```bash
echo "# log-parser" > README.md
printf '#!/usr/bin/env bash\necho "parsing logs"\n' > parser.sh
git status
git add README.md parser.sh
git commit -m "initial commit"
```

Run `git status` between `add` and `commit` — it confirms both files moved to "Changes to be committed" before the commit becomes permanent.

---

## Step 3: Edit a tracked file and commit the change in isolation

```bash
printf '# Usage: ./parser.sh <logfile>\n' >> parser.sh
git diff
git add parser.sh
git diff --staged
git commit -m "add usage comment to parser.sh"
```

Bare `git diff` shows the unstaged addition before `git add`; `git diff --staged` shows the same change once it's in the index, comparing against `HEAD` instead of the working tree.

---

## Step 4: Write a `.gitignore` for the future `build/` directory

```bash
echo "build/" > .gitignore
git add .gitignore
git commit -m "add .gitignore for build artifacts"
```

A trailing `/` matches the directory and everything inside it. This works even before `build/` exists on disk — the pattern is evaluated the moment a matching path shows up.

**Note:** a `.gitignore` rule never retroactively untracks a file that was already committed before the rule existed — that requires an explicit `git rm --cached <path>` first.

---

## Step 5: Create the stand-in remote and push with upstream tracking

```bash
git init --bare /repositories/log-parser-origin.git
git remote add origin /repositories/log-parser-origin.git
git remote -v
git push -u origin main
```

`--bare` creates a repository with no working tree — just the object database and refs, exactly what a real Git host runs server-side. `-u` pushes `main` and records the tracking association in one step, so future plain `push`/`pull`/`fetch` on this branch need no arguments.

---

## Step 6: Confirm `fetch` and `pull` work with no extra flags

```bash
git fetch
git pull
```

Both succeed with zero arguments because `-u` already told Git which remote and branch `main` is associated with.
