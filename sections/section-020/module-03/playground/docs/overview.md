# Overview: PLAYGROUND - Finding Files by Age, Size and Permission

This is a **playground**, not a lab. The environment starts clean, runs
`bootstrap/prepare.sh`, and then waits. There is no task, no `astrona submit`,
and no pass or fail. Explore, break things, `astrona destroy`, start over.

## What is in the box

- A qemu Ubuntu 24.04 virtual machine, reached with `astrona ssh find-triage-playground`.
- The folder `/srv/triage` with a `logs` folder, a `uploads` folder and a `tmp` folder.
- Files with ages from today back to 90 days, sizes from empty to 5 MiB, and a few files that anyone can write (`0666`).
- A file `/srv/triage/uploads/old-report.csv`, set 60 days old.

## Things to try

- Find files older than 30 days with `find /srv/triage -type f -mtime +30`.
- Find files larger than 1 MiB, then files that anyone can write with `-perm -o+w`.
- Combine the tests and use `-exec ls -l {} +` to look at the matches.

## When you are done

```sh
astrona destroy find-triage-playground
```
