# Solution Walkthrough

Astronaut, this mission is about reading three flight paths from the chart without flying any of them, joining only the right one, and then committing a directory Git would otherwise ignore. Work through the steps in order.

---

## Step 1: Clone the repository

```bash
git clone /repositories/auto-verifier /home/candidate/repositories/auto-verifier
cd /home/candidate/repositories/auto-verifier
```

Cloning from a local path works exactly like a network clone. The whole object database comes along, including every branch, as `origin/dev4`, `origin/dev5` and `origin/dev6`.

---

## Step 2: Read `config.yaml` on each candidate branch without checking it out

```bash
for b in dev4 dev5 dev6; do
  echo "== $b =="
  git show origin/$b:config.yaml | grep user_registration_level
done
```

```text
== dev4 ==
user_registration_level: invite_only
== dev5 ==
user_registration_level: open
== dev6 ==
user_registration_level: waitlist
```

`git show <ref>:<path>` prints a file as it is at that branch's tip, with no checkout, no stash and no change to your working tree. The output shows that `dev5` is the branch with `user_registration_level: open`.

---

## Step 3: Make sure you are on `main`, then merge only the matching branch

```bash
git switch main
git merge origin/dev5
```

`git merge` always lands on the branch you have checked out, which is why you switch to `main` first. Only `dev5` gets merged, not `dev4` or `dev6`.

Check the setting on `main`:

```bash
grep user_registration_level config.yaml
```

```text
user_registration_level: open
```

---

## Step 4: Create the `logs` directory with a `.keep` placeholder

```bash
mkdir -p logs
touch logs/.keep
```

Git only tracks content, not directories. An empty `logs/` directory stays invisible to Git until something exists inside it. `.keep` is a naming habit, not a Git feature.

---

## Step 5: Stage and commit

```bash
git add logs/.keep
git status
git commit -m "added log directory"
```

`git status` should show only `logs/.keep` as a new file to be committed, on branch `main`. The grader checks that this commit changes `logs/.keep` and nothing else, and it compares the message word for word.

---

## Step 6: Check the result and submit

Check the branch and the last commit message:

```bash
git branch --show-current
git log -1 --format=%s
```

```text
main
added log directory
```

When everything matches, send the mission for grading from your own computer:

```sh
astrona submit -c labs/lab-042
```
