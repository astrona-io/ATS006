# Solution Guide: Branch Inspection & Merge

This guide shows how to identify the correct branch without checking it out, merge it, and commit an otherwise-empty directory.

---

## Step 1: Clone the repository

```bash
git clone /repositories/auto-verifier /home/candidate/repositories/auto-verifier
cd /home/candidate/repositories/auto-verifier
```

Cloning from a local path works exactly like a network clone — the entire object database, including every branch, comes along.

---

## Step 2: Inspect `config.yaml` on each candidate branch without checking out

```bash
for b in dev4 dev5 dev6; do
  echo "== $b =="
  git show origin/$b:config.yaml | grep user_registration_level
done
```

`git show <ref>:<path>` prints a file's content at that branch's tip with no checkout, no stash, and no change to your working tree. Suppose the output shows `dev5` is the branch with `user_registration_level: open`.

---

## Step 3: Make sure you're on `main`, then merge only the matching branch

```bash
git switch main
git merge origin/dev5
```

`git merge` always applies to your currently checked-out branch, which is why confirming (or switching to) `main` first matters. Only `dev5` gets merged — not `dev4` or `dev6`.

---

## Step 4: Create the `logs` directory with a `.keep` placeholder

```bash
mkdir -p logs
touch logs/.keep
```

Git only tracks content, not directories — an empty `logs/` directory is invisible to Git until something exists inside it. `.keep` is a filename convention, not a Git feature.

---

## Step 5: Stage and commit

```bash
git add logs/.keep
git status
git commit -m "added log directory"
```

**Note:** grading on Git tasks like this typically checks the commit message verbatim, so match the wording and capitalization exactly.
