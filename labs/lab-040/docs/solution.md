# Solution Walkthrough

Astronaut, this capstone chains every Git skill of the section into one flight: clone, read the candidate branches and merge the right one, commit a new directory, push, then rebase a topic branch onto a teammate's newer work and push a straight history. The grader reads the upstream repository, so every result must be pushed.

---

## Step 1: Clone the repository

```bash
git clone /repositories/deploy-configs.git /home/candidate/deploy-configs
cd /home/candidate/deploy-configs
```

The clone brings every branch as `origin/env-staging`, `origin/env-canary` and `origin/env-prod`, and sets `origin` to `/repositories/deploy-configs.git`.

---

## Step 2: Read the candidate branches and merge the correct one

Read `app.conf` on each candidate without checking any of them out:

```bash
for b in env-staging env-canary env-prod; do
  echo "== $b =="
  git show origin/$b:app.conf | grep feature_flag
done
```

```text
== env-staging ==
feature_flag: staging_only
== env-canary ==
feature_flag: enabled
== env-prod ==
feature_flag: disabled  # matches production default
```

`env-canary` is the branch that sets `feature_flag: enabled`. Make sure you are on `main`, then merge only that branch:

```bash
git switch main
git merge origin/env-canary
```

`main` has had no new commits since `env-canary` branched off, so Git simply moves `main` forward to the `env-canary` commit (a fast-forward). No merge commit is created, which keeps the history straight.

---

## Step 3: Create the `scripts/` directory with a `.keep` placeholder

```bash
mkdir -p scripts
touch scripts/.keep
git add scripts/.keep
git commit -m "add scripts directory"
```

Git only tracks content, so the placeholder file is what makes the directory part of the commit. The grader checks that this commit changes `scripts/.keep` and nothing else.

---

## Step 4: Push `main` with upstream tracking

```bash
git push -u origin main
```

`-u` pushes `main` and records that it follows `origin/main`.

---

## Step 5: Create the topic branch and make the focused change

```bash
git switch -c bump-retry-limit
sed -i 's/retry_limit: 3/retry_limit: 10/' app.conf
git add app.conf
git commit -m "increase retry limit to 10"
```

---

## Step 6: Simulate a teammate pushing straight to the upstream

```bash
git clone /repositories/deploy-configs.git /tmp/someone-else
cd /tmp/someone-else
echo "timeout: 60" >> app.conf
git add app.conf
git commit -m "add default timeout to app.conf"
git push origin main
cd /home/candidate/deploy-configs
rm -rf /tmp/someone-else
```

The throwaway clone already contains your pushed `add scripts directory` commit, so the teammate's commit lands on top of it.

---

## Step 7: Fetch and rebase the topic branch

```bash
git fetch origin
git switch bump-retry-limit
git rebase origin/main
```

`git fetch` only moves `origin/main`. `git rebase origin/main` replays your retry-limit commit on top of the teammate's timeout commit. The teammate appended a new line and your change edits a different, existing line, so the rebase replays with no conflict.

---

## Step 8: Fast-forward `main` and push the final state

```bash
git switch main
git merge origin/main
git merge bump-retry-limit
git push origin main
```

The first merge fast-forwards `main` to include the teammate's timeout commit. `bump-retry-limit` was just rebased on top of that same tip, so the second merge is also a fast-forward. The end result is one straight history with no merge commits.

---

## Step 9: Check the result and submit

Check the commit sequence on the upstream, oldest first:

```bash
git -C /repositories/deploy-configs.git log --reverse --format=%s main
```

```text
initial commit
enable feature flag for canary rollout
add scripts directory
add default timeout to app.conf
increase retry limit to 10
```

Check the final `app.conf` on the upstream:

```bash
git -C /repositories/deploy-configs.git show main:app.conf
```

```text
feature_flag: enabled
retry_limit: 10
max_connections: 100
log_level: info
timeout: 60
```

`git log --oneline --graph` in `/home/candidate/deploy-configs` shows the same commits in one straight line. When everything matches, send the mission for grading from your own computer:

```sh
astrona submit -c labs/lab-040
```
