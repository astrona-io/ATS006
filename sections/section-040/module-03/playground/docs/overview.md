# Overview: PLAYGROUND - Reconciling with an Upstream Repository

This is a **playground**, not a lab. The environment starts clean, runs
`bootstrap/prepare.sh`, and then waits. There is no task, no `astrona submit`,
and no pass or fail. Explore, break things, `astrona destroy`, start over.

## What is in the box

- A qemu Ubuntu 24.04 virtual machine, reached with `astrona ssh git-upstream-playground`.
- The bare repository `/repositories/mission-plan.git` with one commit on `main`.
- Git installed and a throwaway identity set.

## Things to try

- Clone it twice, into `~/copy-one` and `~/copy-two`, to act as two crew members.
- Push a commit from `copy-one`, then use `git fetch` in `copy-two` and look at `git log origin/main`.
- Update `copy-two` with `git pull --rebase` and with a merge, and compare the history.

## When you are done

```sh
astrona destroy git-upstream-playground
```
