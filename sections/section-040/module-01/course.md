# Git Fundamentals: Init, Status, Diff, Log, and Remotes

Astronaut, every ship keeps a flight log. Every event gets written down and dated, and nothing is ever torn out. If an earlier entry turns out to be wrong, the crew adds a new entry that corrects it, and the old one stays for context.

**Git** is that flight log for a directory of files. A Git **repository** is the flight log archive: it stores every version of your files that you asked it to remember, in order. In this module you learn the basic mechanics of the archive: how an entry gets written, how to check what is about to be written before it is sealed, and how to share your archive with another place.

## Learning objectives

After this module you can:

- Create a new repository with `git init` and explain what it creates.
- Name the three states a file moves through (working tree, staging area, history) and read them from `git status`.
- Tell `git diff` and `git diff --staged` apart, and use each one at the right moment.
- Write a `.gitignore` that keeps generated files out of the repository, and explain why it does not affect files Git already tracks.
- Read the history with `git log` and `git log --oneline`.
- Explain what a remote is, create a bare repository, and push to it with upstream tracking (`-u`).
- Explain the difference between `git fetch` and `git pull`.

## Before you start

Check that you have the knowledge and the tools this module expects before you begin.

### What you should already know

- **How to use a terminal.** You can change directories with `cd`, create directories with `mkdir`, and write a line into a file with `echo "text" > file`.
- **What a file and a directory are.** Git works on an ordinary directory of files. Nothing else is needed.

### What you need

A playground: one Ubuntu 24.04 training ship in the simulator, with the `bash` shell. Everything the examples use is already on it, so you do not need to install anything.

### What is in your playground

Your playground is a virtual machine on your computer. It already has:

- Git installed, with the identity `Candidate <candidate@example.com>` set for the `candidate` user.
- An empty bare repository `/repositories/ship-log.git` that you can use as a remote.
- An empty folder `~/projects`.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->

Open a terminal on it:

```sh
astrona ssh git-basics-playground
```

Every command block in the parts runs **inside that virtual machine**, as the user `candidate`, who can use `sudo`.

## How this module is laid out

1. [The Three States Of A File](./course-01-the-three-states-of-a-file.md)
2. [Diff, Ignore And Log](./course-02-diff-ignore-and-log.md)
3. [Remotes, Push And Fetch](./course-03-remotes-push-and-fetch.md)
   - Mission: [Git Fundamentals Lab](../../../labs/lab-041/docs/question.md)
4. [Wrap-Up: Mission Debrief](./course-04-wrap-up.md)

## Why this matters

Configuration files, scripts and firewall rules more and more often live in a Git repository before they reach a server. An administrator who can create a repository, read its state and push it to a shared place can be trusted with that history. Every other Git skill, such as branches, merges and rebases, builds on the three states and the remote you learn here.
