---
estimated_duration: 20m
---

# Diskspace Troubleshooting Lab

Welcome to a repair mission, astronaut. The log deck of your training ship is almost full, but counting the visible files finds almost nothing. A service still holds a deleted file open.

Your job is to prove that `df` and `du` disagree, find the process that holds the deleted file, and free the space without deleting any real log file.

## Launching the Lab

Run this command to start the virtual machine:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-061
```

Open a terminal on it:

```bash
astrona ssh ats-006-lab-061
```

When you think you have finished, send it for grading:

```bash
astrona submit -c labs/lab-061
```

When you are done, remove the lab:

```bash
astrona destroy ats-006-lab-061
```
