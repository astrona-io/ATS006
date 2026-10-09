# Wrap-Up: Mission Debrief

Well flown, astronaut. You have finished every part and the mission in this module. Before you move on, look back at what you learned, check yourself, and clean up anything still running.

## What you learned

This module was about the three signal lines every program has, how bash re-patches them, and the status code a program hands back when it ends.

**From [Three Signal Lines](./course-01-three-signal-lines.md):**

- Every process starts with three file descriptors: fd 0 (stdin), fd 1 (stdout) and fd 2 (stderr). By default all three are wired to the terminal.
- `>` moves only stdout into a file. `2>` moves only stderr. Each one leaves the other stream where it was.
- Write `2>` with no space. Well-behaved tools send warnings to stderr so their stdout stays clean for other programs.

**From [Combining Both Streams In The Right Order](./course-02-combining-both-streams.md):**

- Bash reads redirections from left to right, and `2>&1` copies where fd 1 points at that moment.
- `cmd > file 2>&1` puts both streams in the file. `cmd 2>&1 > file` puts only stdout in the file and leaves stderr on the terminal.
- `&>` is a bash shorthand for `> file 2>&1`. Use the long form in scripts that must run under `sh`.

**From [Reading The Exit Code](./course-03-reading-the-exit-code.md):**

- Bash stores a command's exit code in `$?`. `0` means success, 1 to 255 mean failure.
- The next command overwrites `$?`, so read it on the very next line.
- Sending output to `/dev/null` does not change the exit code.

## Your missions

You proved these skills in a graded mission, right after the part that taught the last of them:

| Mission | After the part | What you proved |
| --- | --- | --- |
| [Shell Redirection & Exit Code Diagnostics Lab](../../../labs/lab-011/docs/question.md) | Reading The Exit Code | sent stdout, stderr and both streams to separate files, and captured the exit code |

If you skipped it, go back to it now. It is short, and the exam asks for exactly these skills.

## Check yourself

Try to answer each question before you open the answer.

<details>
<summary>1. Which file descriptor numbers do stdin, stdout and stderr use?</summary>

stdin is 0, stdout is 1 and stderr is 2.
</details>

<details>
<summary>2. You run <code>backup-tool > success.log</code> and an error still appears on your screen. Why?</summary>

`>` only moves stdout (fd 1). The error went to stderr (fd 2), which still points at the terminal.
</details>

<details>
<summary>3. What is the difference between <code>cmd > file 2>&1</code> and <code>cmd 2>&1 > file</code>?</summary>

Bash reads them left to right. In the first, fd 1 goes to the file first, so `2>&1` sends fd 2 there too. In the second, `2>&1` copies fd 1 while it still points at the terminal, so stderr stays on the screen and only stdout reaches the file.
</details>

<details>
<summary>4. When should you avoid <code>&></code>?</summary>

In a script that must also run under `sh` or `dash`. `&>` is a bash feature. Use `> file 2>&1` instead.
</details>

<details>
<summary>5. You run a program, then <code>ls</code>, then <code>echo $?</code>. Whose exit code do you see?</summary>

The exit code of `ls`. `$?` holds the code of the most recently finished command, so `ls` overwrote the program's code.
</details>

<details>
<summary>6. Does <code>cmd > /dev/null 2>&1</code> change the exit code of <code>cmd</code>?</summary>

No. Redirection decides where the text goes. The exit code is a separate number, and `$?` still holds it.
</details>

## Clean up

Each mission runs a virtual machine on your computer. When you are done with this module, remove any mission that is still running.

First, see what is still running:

```sh
astrona list
```

If the mission is still there, remove it. The command takes its **name**, not its folder path:

```sh
astrona destroy ats-006-lab-011
```

Then check that everything is gone:

```sh
astrona list
```

```text
No astrona labs running.
```

> *Read redirections from left to right, and read `$?` straight away.*
