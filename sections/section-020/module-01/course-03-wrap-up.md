# Wrap-Up: Mission Debrief

Well flown, astronaut. You have finished every part and the mission in this module. Before you move on, look back at what you learned, check yourself, and land your lab machine cleanly.

## What you learned

This module was about the lock badge on every crate and compartment: the nine normal permission bits, the three special bits, and the two ways `chmod` writes them.

**From [Reading And Setting Permission Bits](./course-01-reading-and-setting-permission-bits.md):**

- The first column of `ls -l` holds three groups of three bits: owner, group, other, each with read, write and execute.
- On a directory, `x` means "may enter and open files by name". Without it, `r` only shows the names.
- Symbolic notation (`g+w`, `o-rwx`, `u=rwx,g=rx,o=`) changes named bits. Octal notation (`750`) sets all nine bits at once, with read `4`, write `2` and execute `1`.
- `chmod -R u+rwX,g+rX,o+rX` keeps directories enterable without making plain data files executable.

**From [The Three Special Bits](./course-02-the-three-special-bits.md):**

- The special bits live in a fourth octal digit: setuid `4000`, setgid `2000`, sticky `1000`.
- Setuid runs a program with its owner's privileges, which is how `passwd` works.
- Setgid on a directory gives every new entry the directory's group. It is not retroactive.
- The sticky bit on a writable directory lets only a file's owner, the directory's owner or root delete it. `/tmp` is `1777`.
- A lowercase `s` or `t` means the special bit and execute are both set. An uppercase `S` or `T` means execute is missing.

## Your missions

You proved the skills in a graded mission, right after the part that taught them:

| Mission | After the part | What you proved |
| --- | --- | --- |
| [chmod Permission Bits Lab](../../../labs/lab-021/docs/question.md) | The Three Special Bits | set setgid on a team directory, lock a script to its owner, and add the sticky bit to a shared drop folder |

If you skipped it, go back to it now. It is short, and the exam asks for exactly these skills.

## Check yourself

Try to answer each question before you open the answer.

<details>
<summary>1. What does <code>-rwxr-xr--</code> mean, and what is it in octal?</summary>

The owner can read, write and execute. The group can read and execute. Everyone else can only read. In octal it is `754`.
</details>

<details>
<summary>2. A task says "the group can read and enter, but not change anything; others get nothing; the owner has full access". Which mode do you set on the directory?</summary>

`750`. Owner `7` (`rwx`), group `5` (`r-x`), other `0` (`---`).
</details>

<details>
<summary>3. Why is <code>chmod -R 755</code> a bad idea on a tree of scripts and text files?</summary>

It gives every file the execute bit, including plain text files. Use `chmod -R u+rwX,g+rX,o+rX` so only directories and files that were already executable get execute.
</details>

<details>
<summary>4. You set <code>2770</code> on a team directory. A file that was already inside still has the wrong group. Is setgid broken?</summary>

No. Setgid only affects entries created after the bit is set. Change the group of existing files yourself, for example with `chgrp`.
</details>

<details>
<summary>5. Everyone can write to <code>/srv/shared/dropbox</code>. How do you stop people from deleting each other's files?</summary>

Set the sticky bit: `chmod 1777 /srv/shared/dropbox`. Deleting a file is a directory operation, so plain write access lets anyone delete anything. The sticky bit limits deletion to the file's owner, the directory's owner or root.
</details>

<details>
<summary>6. <code>ls -ld</code> shows <code>drwxrwxrwT</code>. What is unusual about it?</summary>

The uppercase `T` means the sticky bit is set but the execute bit for others is missing. The normal shared-folder pattern shows a lowercase `t`.
</details>

<details>
<summary>7. How can an ordinary user change their password when only root can write the password database?</summary>

`passwd` is owned by root and has the setuid bit. The kernel runs it with root's privileges for that one operation.
</details>

## Practise on your own

Use a spare machine or a running lab to repeat the module's key checks without help:

1. Create a test directory and a test group, set the group as its owner, and apply `2770`. Confirm with `stat -c '%a %A' <dir>` that it reads `2770 drwxrws---`.
2. As a member of that group, create a file inside. Check it with `stat -c '%G' <file>` and confirm it shows the directory's group, not the user's own primary group.
3. Create a small script, apply `chmod 700`, and confirm `stat -c '%a %A'` reads `700 -rwx------`.
4. Create a second directory, apply `chmod 1777`, and confirm `ls -ld` shows a lowercase `t` (`drwxrwxrwt`).
5. Build a tree with a script and a plain text file, run `chmod -R u+rwX,g+rX,o+rX`, and confirm only the script is executable.

## Clean up

When you are done with this module, remove any mission that is still running.

First, see what is still running:

```sh
astrona list
```

Remove the lab. The command takes its **name**, not its folder path:

```sh
astrona destroy ats-006-lab-021
```

Then check that everything is gone:

```sh
astrona list
```

```text
No astrona labs running.
```

You can start the mission again at any time with the `astrona run` command. It always starts clean, so nothing you broke carries over.

> *Nine bits say who may look, change and run; the fourth digit adds the team tag, the owner's rank and the shared locker.*
