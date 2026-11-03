---
estimated_duration: 15m
---

# umask Default Permissions Lab

Welcome to a cargo mission, astronaut. Every new crate the user `candidate` creates on this training ship gets the default lock setting, the `umask`, and that setting is not what the crew needs.

Your job is to predict what the current mask produces, then make new files come out `640` and new directories `750` at every login, with no `chmod` at all.

## Launching the Lab

Run this command to start the lab machine:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-022
```

Open a terminal on it:

```bash
astrona ssh ats-006-lab-022
```

When you think you have finished, send it for grading:

```bash
astrona submit -c labs/lab-022
```

When you are done, remove the lab:

```bash
astrona destroy ats-006-lab-022
```
