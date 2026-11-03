---
estimated_duration: 20m
---

# Git Branch Inspection & Merge Lab

Welcome to a branch-reading mission, astronaut. The Auto-Verifier repository has three candidate branches, and only one of them opens user registration. Your job is to find that branch without checking any of them out, merge only it into `main`, and commit a new `logs` directory with a `.keep` placeholder.

## Launching the Lab

Run this command to start the lab machine:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-042
```

Open a terminal on it:

```bash
astrona ssh ats-006-lab-042
```

When you think you have finished, send it for grading:

```bash
astrona submit -c labs/lab-042
```

When you are done, remove the lab:

```bash
astrona destroy ats-006-lab-042
```
