# Overview: PLAYGROUND - Branches, Clone and Merge

This is a **playground**, not a lab. The environment starts clean, runs
`bootstrap/prepare.sh`, and then waits. There is no task, no `astrona submit`,
and no pass or fail. Explore, break things, `astrona destroy`, start over.

## What is in the box

- A qemu Ubuntu 24.04 virtual machine, reached with `astrona ssh git-branches-playground`.
- The repository `/repositories/crew-manifest` on `main`, with three extra branches: `feature-alpha`, `feature-bravo` and `feature-charlie`. Each branch adds one file.
- Git installed and a throwaway identity set.

## Things to try

- Clone the repository with `git clone /repositories/crew-manifest ~/crew-copy`.
- List the branches with `git branch -a` and read each one with `git log --oneline`.
- Merge one branch into `main` and look at the history with `git log --graph --oneline`.

## When you are done

```sh
astrona destroy git-branches-playground
```
