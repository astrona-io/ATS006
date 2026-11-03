# Overview: PLAYGROUND - Shell History

This is a **playground**, not a lab. The environment starts clean, runs
`bootstrap/prepare.sh`, and then waits. There is no task, no `astrona submit`,
and no pass or fail. Explore, break things, `astrona destroy`, start over.

## What is in the box

- A qemu Ubuntu 24.04 virtual machine, reached with `astrona ssh history-playground`.
- A `~/.bash_history` with eight earlier commands, including one that holds a made-up token.
- The default history settings of the `candidate` user.

## Things to try

- Run `history | tail` and repeat a command with `!<number>` and with `!!`.
- Search backward with `Ctrl+R`.
- Look at `HISTSIZE`, `HISTCONTROL` and `HISTFILE`, then delete one entry with `history -d`.

## When you are done

```sh
astrona destroy history-playground
```
