# Solution Guide: Cloning Upstream and Reconciling a Topic Branch

This guide walks through branching off a clone, making a focused commit, simulating upstream drift, and reconciling with a rebase.

---

## Step 1: Clone the upstream repository

```bash
git clone /repositories/upstream-app.git /home/candidate/repositories/upstream-app
cd /home/candidate/repositories/upstream-app
git branch -vv
```

The clone automatically checks out the default branch and sets it up to track `origin/main` with no extra configuration.

---

## Step 2: Create and switch to a topic branch

```bash
git switch -c fix-timeout-value
```

`-c` creates the branch from the current `HEAD` and checks it out in one step.

---

## Step 3: Make one focused change and commit it

```bash
sed -i 's/timeout: 30/timeout: 90/' config.yaml
git diff
git add config.yaml
git commit -m "increase timeout to 90s"
```

---

## Step 4: Show exactly what the topic branch changed

```bash
git log main..fix-timeout-value --oneline
git diff main..fix-timeout-value
```

The two-dot range lists commits (and shows the combined diff) reachable from `fix-timeout-value` but not from `main` — exactly what this branch added.

---

## Step 5: Simulate upstream moving on

```bash
git clone /repositories/upstream-app.git /tmp/someone-else
cd /tmp/someone-else
sed -i 's/retries: 3/retries: 5/' config.yaml
git add config.yaml
git commit -m "bump retry count for flaky network"
git push origin main
cd /home/candidate/repositories/upstream-app
rm -rf /tmp/someone-else
```

This models a teammate pushing directly to the shared upstream while your topic branch was in progress. Since it touches a different line (`retries`, not `timeout`), it isn't a conflict by itself.

---

## Step 6: Fetch, then reconcile with a rebase

```bash
git fetch origin
git log main..origin/main --oneline
git rebase origin/main
```

`git fetch` only updates the `origin/main` remote-tracking ref — your checked-out branch is untouched until you act on it. `git rebase origin/main` (run while on `fix-timeout-value`) detaches your one commit, moves the branch base to the new upstream tip, and replays your commit on top of it.

```bash
git log --oneline --graph --all
cat config.yaml
```

Both `timeout: 90` and `retries: 5` should be present, in a single linear history with no merge commit.

**Note:** if the rebase stops with a conflict, resolve the markers, `git add` the file, and run `git rebase --continue`; `git rebase --abort` is always available as a clean escape hatch.
