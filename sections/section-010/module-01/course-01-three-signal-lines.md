# Three Signal Lines

Astronaut, every program you start is a crew member on your ship, and every crew member is born with three signal lines already plugged in. This part shows you what those lines are, where they go by default, and how to re-patch one of them into a file while the other keeps going to your screen.

## The three standard streams

Every process on Linux starts with three open **file descriptors**, whether you think about them or not. A file descriptor is a small number that a process uses to talk to a file or a device. Picture it as a numbered socket on the crew member's console, with a signal line plugged into it.

The three that every process gets are:

| Number | Name | What it carries | Space picture |
| --- | --- | --- | --- |
| fd 0 | **stdin** (standard input) | What the program reads, for example your keystrokes | Orders coming in |
| fd 1 | **stdout** (standard output) | The program's normal output | Reports going out |
| fd 2 | **stderr** (standard error) | Warnings and errors | Alarms going out |

By default, all three are wired to your terminal. The program reads your keystrokes from fd 0. It prints normal output to fd 1 and warnings to fd 2. You see both outputs mixed on one screen, because both lines end at the same place.

The shell (bash, the bridge console where you type orders) can unplug any of these lines and plug it into something else: a file, another stream, or `/dev/null`. It does this for each line on its own, without touching the other two. That is called **redirection**.

This is not a cosmetic feature. It decides whether a log file holds the error that broke something, or is empty because the error text went to your terminal instead.

## Isolating stdout, isolating stderr

The two simplest redirections each move one line and leave the other alone. Here they are with a made-up program called `backup-tool`.

### Send only stdout to a file

```bash
backup-tool > success.log
```

Bash connects fd 1 to `success.log` before the program starts. Anything the program writes as normal output lands in the file. If the program also writes a warning to stderr, that warning is not affected. It still prints on your terminal, because bash only re-patched fd 1.

### Send only stderr to a file

```bash
backup-tool 2> errors.log
```

The `2` right before `>` targets fd 2. There must be no space between them: `2 > file` (with a space) is a different piece of syntax to the shell, and it does not mean "send stderr". Now stdout is untouched and still prints on the terminal, while only the error stream lands in `errors.log`.

Separating the two streams into two files is useful on its own. It is how you build a log pipeline where the normal record and the trouble ticket never get mixed. It is also why well-behaved Linux tools send their warnings to stderr: another program may be reading and parsing their stdout, and warnings there would get in its way.

## Try it with a test script

You can see both redirections work with a tiny script that writes one line to each stream.

Save this as `two-streams.sh` in your home directory:

```bash
#!/bin/bash
echo "ok"
echo "warn" >&2
exit 3
```

The first `echo` writes to stdout. The second one writes to stderr, because `>&2` sends that one line to fd 2. The `exit 3` line sets the status code the script reports when it finishes.

Apply it:

```sh
chmod +x two-streams.sh
```

### Redirect only stdout

Run the script with only `>`:

```sh
./two-streams.sh > out.log
```

The `warn` line still appears on your terminal. Then check the file:

```sh
cat out.log
```

```text
ok
```

Only the stdout line landed in the file. The stderr line went to the screen, because nothing re-patched fd 2.

### Redirect only stderr

Now run it with only `2>`:

```sh
./two-streams.sh 2> err.log
```

This time `ok` appears on your terminal. Then check the file:

```sh
cat err.log
```

```text
warn
```

The file holds only the stderr line. Each redirection moved exactly one signal line and left the other where it was.

## Common pitfalls

> [!WARNING]
> - **Expecting `>` to catch errors.** `>` only moves stdout (fd 1). Warnings and errors on stderr still go to the terminal and are missing from the file.
> - **Putting a space in `2>`.** Write `2> file`, not `2 > file`. With the space, bash no longer reads the `2` as "file descriptor 2".
> - **Mixing up the numbers.** fd 1 is stdout (normal output), fd 2 is stderr (warnings and errors). `2>` is for errors.
