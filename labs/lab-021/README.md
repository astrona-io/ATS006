---
estimated_duration: 15m
---

# chmod Permission Bits Lab

Welcome to a cargo mission, astronaut. The `analysts` team shares a compartment on this training ship, and its locks are set wrong: new files land in the wrong group, a script is open to everyone, and anyone can remove anyone's crates from the drop folder.

Your job is to set the three right modes with `chmod`, including the special bits, and prove that a team member's new file gets the team's group.

## Launching the Lab

Run this command to start the lab machine:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-021
```

Open a terminal on it:

```bash
astrona ssh ats-006-lab-021
```

When you think you have finished, send it for grading:

```bash
astrona submit -c labs/lab-021
```

When you are done, remove the lab:

```bash
astrona destroy ats-006-lab-021
```
