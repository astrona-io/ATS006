# Overview: PLAYGROUND - Command Aliases

This is a **playground**, not a lab. The environment starts clean, runs
`bootstrap/prepare.sh`, and then waits. There is no task, no `astrona submit`,
and no pass or fail. Explore, break things, `astrona destroy`, start over.

## What is in the box

- A qemu Ubuntu 24.04 virtual machine, reached with `astrona ssh alias-playground`.
- The folder `~/scrap` with three throwaway files named `one.tmp`, `two.tmp` and `three.tmp`.
- A default `~/.bashrc`, with no aliases of your own yet.

## Things to try

- Make an alias `rm='rm -i'` for this shell and see it ask before deleting.
- Bypass the alias with `\\rm`, with `command rm` and with the full path `/usr/bin/rm`.
- Save an alias in `~/.bashrc` and load it with `source ~/.bashrc`.

## When you are done

```sh
astrona destroy alias-playground
```
