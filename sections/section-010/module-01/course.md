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

- A terminal on an Ubuntu 24.04 machine with the bash shell. Any Ubuntu 24.04 machine works for the examples in the parts.
- Or a running lab machine: start a lab with `astrona run` and open a terminal on it with `astrona ssh <lab name>`. The mission in this module gives you the exact commands.

## How this module is laid out

1. [Three Signal Lines](./course-01-three-signal-lines.md): stdin, stdout and stderr, and how to send stdout or stderr to a file on its own.
2. [Combining Both Streams In The Right Order](./course-02-combining-both-streams.md): `> file 2>&1`, why the order matters, and the `&>` shorthand.
3. [Reading The Exit Code](./course-03-reading-the-exit-code.md): `$?`, why it is overwritten so easily, and how to capture it.
   - Mission: [Shell Redirection & Exit Code Diagnostics Lab](../../../labs/lab-011/docs/question.md)
4. [Wrap-Up: Mission Debrief](./course-04-wrap-up.md)

## Why this matters

A log file that is missing the one error line you needed is worse than no log file at all. It looks complete, so nobody checks it. Getting redirection right means the right text lands in the right place. Getting the exit code right means a script knows when something failed, instead of carrying on as if everything worked.
