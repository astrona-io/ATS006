# Overview: PLAYGROUND - Git Fundamentals

This is a **playground**, not a lab. The environment starts clean, runs
`bootstrap/prepare.sh`, and then waits. There is no task, no `astrona submit`,
and no pass or fail. Explore, break things, `astrona destroy`, start over.

## What is in the box

- A qemu Ubuntu 24.04 virtual machine, reached with `astrona ssh git-basics-playground`.
- Git installed, with the identity `Candidate <candidate@example.com>` set for the `candidate` user.
- An empty bare repository `/repositories/ship-log.git` that you can use as a remote.
- An empty folder `~/projects`.

## Things to try

- Run `git init` in a new folder under `~/projects`, create a file and make the first commit.
- Add `/repositories/ship-log.git` as `origin` and push.
- Change a file and compare it with `git diff`, then add a `.gitignore`.

## When you are done

```sh
astrona destroy git-basics-playground
```
