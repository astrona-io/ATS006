---
estimated_duration: 20m
---

# Manual Pages and Editing a File Lab

Welcome to a flight-planning mission, astronaut. The flight plan of this training ship is half filled in, and two facts you need are in the ship's manuals.

Look up two facts in the manual pages, and edit the flight plan in a text editor.

## Launching the Lab

Run this command to start the virtual machine:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-035
```

Open a terminal on it:

```bash
astrona ssh ats-006-lab-035
```

When you think you have finished, send it for grading:

```bash
astrona submit -c labs/lab-035
```

When you are done, remove the lab:

```bash
astrona destroy ats-006-lab-035
```
