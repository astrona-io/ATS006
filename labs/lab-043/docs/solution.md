# Solution Walkthrough

Astronaut, this mission runs the full cycle of a shared change: branch off, make one focused change, let a teammate push something new, and replay your work on top with a rebase. The grader checks the commit messages word for word, and it checks that your commit has exactly one parent.

---

## Step 1: Clone the upstream repository

```bash
git clone /repositories/upstream-app.git /home/candidate/repositories/upstream-app
cd /home/candidate/repositories/upstream-app
git branch -vv
```

The clone checks out the default branch, `main`, and sets it to track `origin/main` with no extra configuration. `git branch -vv` shows `[origin/main]` next to `main`.

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

`sed` changes the one line in place. `git diff` confirms that only the `timeout` line changed before you stage it.

---

## Step 4: Show exactly what the topic branch changed

```bash
git log main..fix-timeout-value --oneline
git diff main..fix-timeout-value
```

The two-dot range lists the commits reachable from `fix-timeout-value` but not from `main`, and shows their combined change. Here that is one commit, `increase timeout to 90s`, which turns `timeout: 30` into `timeout: 90`.

---

## Step 5: Simulate the upstream moving on

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

This plays a teammate who pushes straight to the shared upstream while your topic branch is in progress. It changes a different line (`retries`, not `timeout`), so it does not conflict with your change.

---

## Step 6: Fetch, then reconcile with a rebase

```bash
git fetch origin
git log main..origin/main --oneline
git rebase origin/main
```

`git fetch` only moves the `origin/main` remote-tracking reference; your checked-out branch is untouched until you act. The `git log` range lists the teammate's commit. `git rebase origin/main`, run while you are on `fix-timeout-value`, lifts your one commit off, moves the branch's start to the new upstream tip and replays your commit on top.

If the rebase stops with a conflict, fix the markers, `git add` the file and run `git rebase --continue`. `git rebase --abort` always takes you back to where you started.

---

## Step 7: Check the result and submit

Look at the graph and the file:

```bash
git log --oneline --graph --all
cat config.yaml
```

The graph is one straight line with no merge commit, and the file now holds both changes:

```text
timeout: 90
max_connections: 100
log_level: info
retries: 5
```

Check that your commit sits directly on top of the teammate's commit:

```bash
git log -2 --format=%s fix-timeout-value
```

```text
increase timeout to 90s
bump retry count for flaky network
```

When everything matches, send the mission for grading from your own computer:

```sh
astrona submit -c labs/lab-043
```
