---
estimated_duration: 40m
---

# Permissions & File Triage Capstone Lab

Welcome to your section capstone, astronaut. The `ops` team is moving into a new shared compartment on this training ship, and nothing is set up right: new crates get the wrong default lock, the shared folders have the wrong bits, and a legacy incoming folder is a junk drawer.

Your job is to fix all of it in one mission: a persistent `umask` for `opsuser`, setgid, owner-only and sticky permissions on the workspace, and a four-pass `find` triage in the order given.

## Launching the Lab

Run this command to start the lab machine:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-020
```

Open a terminal on it:

```bash
astrona ssh ats-006-lab-020
```

When you think you have finished, send it for grading:

```bash
astrona submit -c labs/lab-020
```

When you are done, remove the lab:

```bash
astrona destroy ats-006-lab-020
```
