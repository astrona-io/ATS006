# Solution Walkthrough

Astronaut, this mission builds a flight log archive from the very first entry. You create the repository, seal three entries one at a time, keep build output out, and then give the archive a second home at a bare `origin`. The grader checks the exact commit messages, so type them exactly as shown.

---

## Step 1: Initialize the repository

Create the directory and turn it into a repository:

```bash
mkdir -p /home/candidate/projects/log-parser
cd /home/candidate/projects/log-parser
git init
```

`git init` only creates the `.git/` object database. No commits exist yet, so `git log` would report an error until you make the first commit.

---

## Step 2: Create the first files and commit them

Create the README:

```bash
echo "# log-parser" > README.md
```

Save this as `parser.sh`:

```bash
#!/usr/bin/env bash
echo "parsing logs"
```

Check the status, then stage and commit both files together:

```bash
git status
git add README.md parser.sh
git status
git commit -m "initial commit"
```

The first `git status` lists both files as untracked. The second one, between `add` and `commit`, lists them under "Changes to be committed". That is your check before the commit becomes permanent.

---

## Step 3: Edit a tracked file and commit the change on its own

Add the usage comment, look at the change, stage it and look again:

```bash
printf '# Usage: ./parser.sh <logfile>\n' >> parser.sh
git diff
git add parser.sh
git diff --staged
git commit -m "add usage comment to parser.sh"
```

Plain `git diff` shows the new line before `git add`, because it compares the working tree with the staging area. After staging, `git diff --staged` shows the same line, because it compares the staging area with the last commit (`HEAD`).

---

## Step 4: Write a `.gitignore` for the future `build/` directory

Save this as `.gitignore` in `/home/candidate/projects/log-parser`:

```text
build/
```

Apply it by committing the file:

```bash
git add .gitignore
git commit -m "add .gitignore for build artifacts"
```

Then check the result. `git check-ignore` prints the path when an ignore rule matches it:

```bash
git check-ignore build/output.bin
```

```text
build/output.bin
```

A trailing `/` matches the directory and everything inside it. The rule works even before `build/` exists, because Git checks the pattern the moment a matching path shows up. A `.gitignore` rule never untracks a file that was already committed before the rule existed; that needs `git rm --cached <path>` first.

---

## Step 5: Create the stand-in remote and push with upstream tracking

Create the bare repository, register it as `origin` and push:

```bash
git init --bare /repositories/log-parser-origin.git
git remote add origin /repositories/log-parser-origin.git
git remote -v
git push -u origin main
```

`--bare` creates a repository with no working tree, only the object database and references, which is what a real Git host runs on its server. `git remote -v` shows `origin` with the path `/repositories/log-parser-origin.git` for both fetch and push. `-u` pushes `main` and records the tracking link in one step.

---

## Step 6: Confirm `fetch` and `pull` work with no extra arguments

```bash
git fetch
git pull
```

Both succeed with no arguments because `-u` already told Git which remote and branch `main` follows.

---

## Step 7: Check the result and submit

Check the three commit messages, oldest first:

```bash
git log --reverse --format=%s
```

```text
initial commit
add usage comment to parser.sh
add .gitignore for build artifacts
```

Check the upstream link:

```bash
git rev-parse --abbrev-ref main@{upstream}
```

```text
origin/main
```

When everything matches, send the mission for grading from your own computer:

```sh
astrona submit -c labs/lab-041
```
