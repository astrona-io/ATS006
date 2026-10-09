---
estimated_duration: 40m
---

# Everyday Shell Craft Capstone Lab

Welcome to your section capstone, astronaut. A web server on this ship was attacked overnight, and you are handing it over to the next shift. Scan the logs for the attacker's signals, black out the brute-force lines, dig the previous responder's exact orders out of the order log, and leave safe nicknames for the next crew.

## Launching the Lab

Run this command to start the lab machine:

```bash
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-030
```

Open a terminal on it:

```bash
astrona ssh ats-006-lab-030
```

When you think you have finished, send it for grading:

```bash
astrona submit -c labs/lab-030
```

When you are done, remove the lab:

```bash
astrona destroy ats-006-lab-030
```
