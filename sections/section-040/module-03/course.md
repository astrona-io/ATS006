# Cloning an Upstream Repository, Working on a Topic Branch, and Reconciling Changes

Astronaut, every crew that shares a flight log archive lives through the same story. You copy the archive aboard, branch off onto your own flight path to make one focused change, and while you work, someone else adds an unrelated entry at mission control. That is not a mistake or a conflict by itself. It is the normal rhythm of an archive more than one person touches. What matters is noticing that it happened and folding your work back in cleanly.

This module covers that whole cycle: what a clone sets up for you, how to keep new work on a **topic branch** (a short-lived flight path for one change), how to measure exactly what your branch changed, and the two tools, `rebase` and `merge`, that bring your work together with an upstream that moved on without you.

## Learning objectives

After this module you can:

- Explain what `git clone` sets up automatically, and show the tracking link with `git branch -vv`.
- Create and switch to a topic branch in one step with `git switch -c`.
- Make one focused commit and check it with `git diff` first.
- Use the two-dot range (`A..B`) with `git log` and `git diff` to show exactly what a branch adds.
- Explain why `git fetch` never changes your working tree or your current branch.
- Rebase a topic branch onto a new upstream tip, and handle or abort a conflict.
- Choose between `rebase` and `merge`, and name the one case where you must not rebase.

## Before you start

Check that you have the knowledge and the tools this module expects before you begin.

### What you should already know

- **The three states of a file and the basic commands.** `git status`, `git add`, `git commit -m` and `git log --oneline`.
- **Branches and remotes.** A branch is a pointer to a commit. A clone brings every branch as `origin/<name>`, and `git merge` lands on the branch you have checked out.

### What you need

A playground: one Ubuntu 24.04 training ship in the simulator, with the `bash` shell. Everything the examples use is already on it, so you do not need to install anything.

### What is in your playground

Your playground is a virtual machine on your computer. It already has:

- The bare repository `/repositories/mission-plan.git` with one commit on `main`.
- Git installed and a throwaway identity set.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->

Open a terminal on it:

```sh
astrona ssh git-upstream-playground
```

Every command block in the parts runs **inside that virtual machine**, as the user `candidate`, who can use `sudo`.

## How this module is laid out

1. [A Topic Branch And A Focused Commit](./course-01-a-topic-branch-and-a-focused-commit.md)
2. [Fetch, Rebase Or Merge](./course-02-fetch-rebase-or-merge.md)
   - Mission: [Git Upstream Reconciliation Lab](../../../labs/lab-043/docs/question.md)
3. [Wrap-Up: Mission Debrief](./course-03-wrap-up.md)

## Why this matters

Shared configuration repositories change while you work on them. An administrator who can isolate a change, see exactly what it does, and replay it on top of the newest upstream keeps the history clean and never overwrites a teammate's work. The exam asks for this full cycle, including the rebase.

<!-- curriculum-practice -->
## Practice and assessment

- [Git Upstream Reconciliation Lab](../../../labs/lab-043/docs/question.md): Make one focused commit on a topic branch and show exactly what it changed; Fetch new upstream work and rebase the topic branch on top of it.
- [Git Operations Capstone Lab](../../../labs/lab-040/docs/question.md): Find and merge the one branch with the right setting without checking the candidates out; Push with upstream tracking and rebase a topic branch onto an upstream that moved; Keep main's history linear with fast-forward merges.
