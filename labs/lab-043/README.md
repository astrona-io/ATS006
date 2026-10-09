---
estimated_duration: 25m
---

# Git Upstream Reconciliation Lab

Welcome to a reconciliation mission, astronaut. You branch off a shared upstream to make one focused change, and while you work a teammate pushes a change of their own. Your job is to fetch that change and rebase your topic branch on top of it, so your commit sits directly on the teammate's commit with no merge commit.

## Launching the Lab

Run this command to start the lab machine:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-043
```

Open a terminal on it:

```bash
astrona ssh ats-006-lab-043
```

When you think you have finished, send it for grading:

```bash
astrona submit -c labs/lab-043
```

When you are done, remove the lab:

```bash
astrona destroy ats-006-lab-043
```
