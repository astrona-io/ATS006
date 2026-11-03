# Overview: PLAYGROUND - Shell Streams, Redirection and Exit Codes

This is a **playground**, not a lab. The environment starts clean, runs
`bootstrap/prepare.sh`, and then waits. There is no task, no `astrona submit`,
and no pass or fail. Explore, break things, `astrona destroy`, start over.

## What is in the box

- A qemu Ubuntu 24.04 virtual machine, reached with `astrona ssh shell-streams-playground`.
- The program `/usr/local/bin/backup-tool`. It prints `backup finished: 12 files copied` on stdout, prints `warning: 1 file skipped` on stderr, and exits with code `3` every time.
- An empty folder `~/streams-practice` for the files you create.

## Things to try

- Run `backup-tool` with no redirection, then send only stdout and only stderr to separate files.
- Compare `backup-tool > all.log 2>&1` with `backup-tool 2>&1 > all.log` and read both files.
- Run `backup-tool > /dev/null 2>&1; echo $?` and confirm the exit code is still `3`.

## When you are done

```sh
astrona destroy shell-streams-playground
```
