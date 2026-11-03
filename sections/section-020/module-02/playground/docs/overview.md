# Overview: PLAYGROUND - Default Permissions with umask

This is a **playground**, not a lab. The environment starts clean, runs
`bootstrap/prepare.sh`, and then waits. There is no task, no `astrona submit`,
and no pass or fail. Explore, break things, `astrona destroy`, start over.

## What is in the box

- A qemu Ubuntu 24.04 virtual machine, reached with `astrona ssh umask-playground`.
- The default `umask` of the `candidate` user, with no override in any start-up file.
- An empty folder `~/umask-practice`.

## Things to try

- Run `umask`, then create a file and a folder in `~/umask-practice` and read their modes with `ls -l`.
- Change the `umask` for this shell only and create new files again.
- Add a `umask` line to `~/.bashrc` and open a new shell to see it stick.

## When you are done

```sh
astrona destroy umask-playground
```
