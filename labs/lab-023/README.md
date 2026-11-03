---
estimated_duration: 20m
---

# find Triage by Criteria Lab

Welcome to a cargo mission, astronaut. A backup compartment on this training ship is full of old crates, tiny crates, huge crates and crates with wide-open locks.

Your job is to send out `find`, your cargo search drone, in four passes: delete by date, then sort by size, then quarantine by permission, in that order, so no pass undoes another.

## Launching the Lab

Run this command to start the lab machine:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-023
```

Open a terminal on it:

```bash
astrona ssh ats-006-lab-023
```

When you think you have finished, send it for grading:

```bash
astrona submit -c labs/lab-023
```

When you are done, remove the lab:

```bash
astrona destroy ats-006-lab-023
```
