# Shell Redirection, stdout/stderr, and Exit Codes

Astronaut, every program you start on a Linux machine is a crew member on your spaceship. Each crew member has three signal lines: one for orders coming in, one for normal reports going out, and one for alarms going out. By default all three are wired to your screen, so you see reports and alarms mixed together.

This module teaches you how to re-patch those lines. You will send reports to one file and alarms to another, catch both in one file in the right order, and read the status code a program radios back when it finishes. These skills sit under every other command in this course, and the exam tests them directly.

## Learning objectives

After this module you can:

- Name the three standard streams (stdin, stdout and stderr) and their file descriptor numbers 0, 1 and 2.
- Send only stdout to a file with `>`, and only stderr to a file with `2>`.
- Capture both streams in one file with `> file 2>&1`, and explain why `2>&1 > file` does not do the same thing.
- Use the bash shorthand `&>` and say when the portable form is the safer choice.
- Read a program's exit code from `$?`, and capture it before another command overwrites it.
- Throw away output with `/dev/null` without changing the exit code.

## Before you start

Check that you have the knowledge and the tools this module expects before you begin.

### What you should already know

- **How to type a command at a prompt.** You open a terminal, type a command such as `ls` or `echo hello`, and press Enter.
- **What a file path is.** For example `/var/log/syslog` is a file inside the folder `/var/log`.

### What you need

A playground: one Ubuntu 24.04 training ship in the simulator, with the `bash` shell. Everything the examples use is already on it, so you do not need to install anything.

### What is in your playground

Your playground is a virtual machine on your computer. It already has:

- The program `/usr/local/bin/backup-tool`. It prints `backup finished: 12 files copied` on stdout, prints `warning: 1 file skipped` on stderr, and exits with code `3` every time.
- An empty folder `~/streams-practice` for the files you create.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->

Open a terminal on it:

```sh
astrona ssh shell-streams-playground
```

Every command block in the parts runs **inside that virtual machine**, as the user `candidate`, who can use `sudo`.

## How this module is laid out

1. [Three Signal Lines](./course-01-three-signal-lines.md): stdin, stdout and stderr, and how to send stdout or stderr to a file on its own.
2. [Combining Both Streams In The Right Order](./course-02-combining-both-streams.md): `> file 2>&1`, why the order matters, and the `&>` shorthand.
3. [Reading The Exit Code](./course-03-reading-the-exit-code.md): `$?`, why it is overwritten so easily, and how to capture it.
   - Mission: [Shell Redirection & Exit Code Diagnostics Lab](../../../labs/lab-011/docs/question.md)
4. [Wrap-Up: Mission Debrief](./course-04-wrap-up.md)

## Why this matters

A log file that is missing the one error line you needed is worse than no log file at all. It looks complete, so nobody checks it. Getting redirection right means the right text lands in the right place. Getting the exit code right means a script knows when something failed, instead of carrying on as if everything worked.

<!-- curriculum-practice -->
## Practice and assessment

- [Shell Redirection & Exit Code Diagnostics Lab](../../../labs/lab-011/docs/question.md): Send a program's stdout and stderr to separate files; Capture both streams in one file with the redirections in the right order; Record a program's exit code before another command overwrites it.
- [Shell Semantics Integration Capstone Lab](../../../labs/lab-010/docs/question.md): Export one variable to a child process while keeping another one local to the script; Capture a child's stdout, stderr, both streams together and its exit code in separate files; Use an argument, an if test and a for loop to write a summary, then exit with the program's own exit code.
