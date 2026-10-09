# Reading The Exit Code

Astronaut, when a crew member finishes a job, they radio back one number: the status code. `0` means the job went fine, anything else means something went wrong. This part shows where bash keeps that number, why it disappears so easily, and how to capture it safely, even when you throw the program's output away.

## The exit code and `$?`

Redirection controls where a program's text goes. It has no effect on whether the program thinks it succeeded. That is a separate signal: the **exit code** (also called exit status), a number the program hands back to the shell when it ends. Bash stores it in the special parameter `$?` the moment the command finishes.

### Read it right after the command

```bash
backup-tool
echo $?
```

By convention, `0` means success and any other value from 1 to 255 means some kind of failure. The exact number often says *which* failure. Check a program's manual page or its `--help` output if you need to tell "configuration file missing" from "network timeout", for example.

### The next command overwrites it

The detail that matters most in practice: `$?` holds the exit code of the *most recently finished* foreground command, and nothing older. Bash overwrites it after the very next command you run. Even a harmless check like `ls` in between replaces it before you get the chance to read it.

```bash
backup-tool
ls              # this silently destroys backup-tool's exit code
echo $?         # now shows ls's exit code, not backup-tool's
```

## Throwing output away and keeping the exit code

Sometimes you want a program to run silently, and you only care whether it worked. Bash can send both streams into `/dev/null` and still give you the exit code.

### `/dev/null` and `$?` are independent

`/dev/null` is a special device file: anything written to it is thrown away. Think of it as an airlock to open space. Whatever goes in is gone.

To silence a program and capture its exit code, redirect the output on the same command, then read `$?` on the very next line, with nothing in between:

```bash
backup-tool > /dev/null 2>&1
echo $? > status.log
```

Sending output to `/dev/null` has no effect on the number in `$?`. The two mechanisms are completely separate: one is about text (where the program's output goes), the other is a number the program hands back to whoever started it.

## Try it: catch and lose an exit code

This step uses the same small test script that writes one line to each stream and ends with `exit 3`. If you already saved `two-streams.sh` and made it executable, skip the next two steps.

Save this as `two-streams.sh` in your home directory:

```bash
#!/bin/bash
echo "ok"
echo "warn" >&2
exit 3
```

Apply it:

```sh
chmod +x two-streams.sh
```

### Capture the exit code

Run the script with both streams in `/dev/null`, then read `$?` straight away:

```sh
./two-streams.sh > /dev/null 2>&1
echo $?
```

```text
3
```

Nothing printed from the script itself, and `$?` still holds `3`, the number from the script's `exit 3` line.

### Lose the exit code

Now run another command in between:

```sh
./two-streams.sh > /dev/null 2>&1
ls > /dev/null
echo $?
```

This time `echo $?` prints `0`: the exit code of `ls`, which succeeded. The script's `3` is gone, because bash overwrote `$?` when `ls` finished.

> [!TIP]
> When a script needs an exit code later, save it in a variable on the very next line, for example `result=$?`. Then you can run other commands and still use `$result`.

## Common pitfalls

> [!WARNING]
> - **Running anything between the command and `echo $?`.** Even `ls` or `echo "checking..."` overwrites `$?`. Read it on the very next line.
> - **Thinking `/dev/null` changes the result.** Throwing the output away does not change the exit code.
> - **Treating any output as success.** A program can print normal-looking text and still exit with a non-zero code. Check `$?`, not the screen.

## Your mission: Shell Redirection & Exit Code Diagnostics Lab

You can now send stdout and stderr to separate files, catch both in one file in the right order, and capture an exit code. The mission asks you to do all four with a program that always prints the same two lines and always exits with the same code.

Start the mission:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-011
```

Open a terminal on the lab machine:

```sh
astrona ssh ats-006-lab-011
```

Read the task in [the question](../../../labs/lab-011/docs/question.md) and solve it on your own first. When you think you are done, send it for grading:

```sh
astrona submit -c labs/lab-011
```

When the mission is done, remove it:

```sh
astrona destroy ats-006-lab-011
```
