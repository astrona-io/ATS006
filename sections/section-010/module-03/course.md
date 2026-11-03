# Shell Scripting Basics

Astronaut, a good crew does not type the same ten commands every morning. It writes them down once as a standard procedure and runs the procedure. A shell script is that procedure: a text file of commands that the shell reads from top to bottom.

This module teaches the small set of scripting tools the exam asks for: arguments, exit codes, tests, loops and functions.

## Learning objectives

After this module you can:

- Write a script with a `#!/bin/bash` first line, make it executable and run it.
- Read the arguments with `$1`, `$@` and `$#`, and read the exit code of the last command with `$?`.
- Test a value or a file with `if`, `[[ ]]` and the operators `-d`, `-f`, `-z`, `-eq` and `==`.
- Repeat work with `for` and `while`, and quote variables so file names with spaces survive.
- Group commands in a function and stop a script with `exit` and a meaningful code.

## Before you start

### What you should already know

- **Redirection and pipes.** You know `>`, `2>` and `|` from the module on shell streams.
- **Variables.** You know that `NAME=value` sets a variable and `$NAME` reads it.

### What you need

A playground: one Ubuntu 24.04 training ship with `bash`. Nothing needs to be installed.

### What is in your playground

Your playground is a virtual machine on your computer. It already has:

- The folder `~/inbox` with three `.txt` files (2, 5 and 9 lines), one `.log` file and an empty subfolder `archive`.
- An empty folder `~/scripts` where you save your own scripts.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->

Open a terminal on it:

```sh
astrona ssh script-basics-playground
```

Every command block in the parts runs **inside that virtual machine**, as the user `candidate`.

## How this module is laid out

1. [Arguments, Exit Codes And Tests](./course-01-arguments-and-tests.md): `$1`, `$#`, `$?`, `if` and `[[ ]]`.
2. [Loops And Functions](./course-02-loops-and-functions.md): `for`, `while`, quoting and `function`.
   - Mission: [Shell Script Arguments, Tests and Loops Lab](../../../labs/lab-013/docs/question.md)
3. [Summary](./course-03-summary.md)

## Why this matters

A script that guesses its input breaks on the first odd file name. A script that checks its arguments, quotes its variables and returns an honest exit code can be trusted by cron, by a pipeline and by the next administrator.
