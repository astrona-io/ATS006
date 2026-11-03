---
estimated_duration: 20m
---

# Shell Script Arguments, Tests and Loops Lab

Welcome to a scripting mission, astronaut. Mission control needs a small standard procedure that counts the lines in every text file of a folder, and that complains in the right way when it is called wrongly.

Write `/home/candidate/scripts/count-lines.sh`: it checks its argument, loops over the text files and reports with the right exit code.

## Launching the Lab

Run this command to start the virtual machine:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-013
```

Open a terminal on it:

```bash
astrona ssh ats-006-lab-013
```

When you think you have finished, send it for grading:

```bash
astrona submit -c labs/lab-013
```

When you are done, remove the lab:

```bash
astrona destroy ats-006-lab-013
```
