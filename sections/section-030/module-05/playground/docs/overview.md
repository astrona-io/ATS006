# Overview: PLAYGROUND - Finding Help and Editing Files

This is a **playground**, not a lab. The environment starts clean, runs
`bootstrap/prepare.sh`, and then waits. There is no task, no `astrona submit`,
and no pass or fail. Explore, break things, `astrona destroy`, start over.

## What is in the box

- A qemu Ubuntu 24.04 virtual machine, reached with `astrona ssh docs-editor-playground`.
- The manual pages (`man-db`, `manpages`), `vim` and `nano` installed.
- The file `~/flightplan.conf` with six lines, three of which hold the word `PLACEHOLDER`.

## Things to try

- Find a command by topic with `man -k password` and read one result with `man 5 passwd`.
- Open `~/flightplan.conf` in `vim`, replace every `PLACEHOLDER` with `:%s/PLACEHOLDER/ready/g` and save with `:wq`.
- Open it in `nano`, make a change and save it.

## When you are done

```sh
astrona destroy docs-editor-playground
```
