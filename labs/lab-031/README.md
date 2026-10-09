---
estimated_duration: 15m
---

# grep & sed Text Processing Lab

Welcome to a log mission, astronaut. A scanning bot has been probing a web server, and its traces are mixed in with normal traffic. Your job is to pull out exactly the bot's requests with the signal scanner, `grep`, and to black out sensitive lines with the redaction officer, `sed`, without disturbing anything else.

## Launching the Lab

Run this command to start the lab machine:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-031
```

Open a terminal on it:

```bash
astrona ssh ats-006-lab-031
```

When you think you have finished, send it for grading:

```bash
astrona submit -c labs/lab-031
```

When you are done, remove the lab:

```bash
astrona destroy ats-006-lab-031
```
