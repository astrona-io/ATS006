# Solution Guide: Git Operations Capstone

This guide chains all three module skills into one flowing task: clone, cross-branch inspection and merge, and upstream reconciliation via rebase.

---

## Step 1: Clone the repository

```bash
git clone /repositories/deploy-configs.git /home/candidate/deploy-configs
cd /home/candidate/deploy-configs
```

---

## Step 2: Inspect the candidate branches and merge the correct one

```bash
for b in env-staging env-canary env-prod; do
  echo "== $b =="
  git show origin/$b:app.conf | grep feature_flag
done
```

`env-canary` is the branch setting `feature_flag: enabled`.

```bash
git switch main
git merge origin/env-canary
```

---

## Step 3: Create the `scripts/` directory with a `.keep` placeholder

```bash
mkdir -p scripts
touch scripts/.keep
git add scripts/.keep
git commit -m "add scripts directory"
```

---

## Step 4: Push `main` with upstream tracking

```bash
git push -u origin main
```

---

## Step 5: Create the topic branch and make the focused change

```bash
git switch -c bump-retry-limit
sed -i 's/retry_limit: 3/retry_limit: 10/' app.conf
git add app.conf
git commit -m "increase retry limit to 10"
```

---

## Step 6: Simulate a teammate pushing directly to upstream

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

---

## Step 7: Fetch and rebase the topic branch

```bash
git fetch origin
git switch bump-retry-limit
git rebase origin/main
```

Because the teammate's change appended a new line and the topic branch's change modified a different, existing line, the rebase replays with no conflict.

---

## Step 8: Fast-forward `main` and push the final state

```bash
git switch main
git merge origin/main
git merge bump-retry-limit
git push origin main
```

The first merge fast-forwards `main` to include the teammate's timeout commit; since `bump-retry-limit` was just rebased on top of that exact same tip, the second merge is also a fast-forward — the end result is a single linear history with no merge commits.

**Note:** verify the final state with `git log --oneline --graph` and `cat app.conf` — you should see `feature_flag: enabled`, `retry_limit: 10`, and `timeout: 60` together, in a straight line.
