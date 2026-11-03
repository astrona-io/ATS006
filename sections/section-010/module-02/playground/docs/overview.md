# Overview: PLAYGROUND - Environment Variables and Scope

This is a **playground**, not a lab. The environment starts clean, runs
`bootstrap/prepare.sh`, and then waits. There is no task, no `astrona submit`,
and no pass or fail. Explore, break things, `astrona destroy`, start over.

## What is in the box

- A qemu Ubuntu 24.04 virtual machine, reached with `astrona ssh env-scope-playground`.
- A line in `~/.bashrc` that exports `SHIP_NAME=odyssey`, so every new shell already has it.
- The script `/usr/local/bin/show-env`. It prints the values of `SHIP_NAME` and `CREW_ROLE` as the child process sees them.

## Things to try

- Run `show-env`. `SHIP_NAME` is set and `CREW_ROLE` is empty.
- Set `CREW_ROLE=pilot` without `export`, run `show-env`, then run `export CREW_ROLE` and run it again.
- Open a second terminal with `astrona ssh env-scope-playground` and check which variables survive there.

## When you are done

```sh
astrona destroy env-scope-playground
```
