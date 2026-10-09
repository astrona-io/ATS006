# Wrap-Up: Mission Debrief

Well flown, astronaut. You have finished every part and the mission in this module. Before you move on, look back at what you learned, check yourself, and land your lab machine cleanly.

## What you learned

This module was about the `umask`, the default lock setting on every new crate: where it comes from, what it produces, and how to make it last.

**From [How The umask Shapes New Files](./course-01-how-the-umask-shapes-new-files.md):**

- A new file starts from `666`, a new directory from `777`. The kernel switches off the mask's bits.
- The mask can only remove bits. A new file never gets execute from the mask alone, because `666` has no execute bit.
- `umask` prints the mask in octal. `umask -S` prints the permissions you get.
- With `027`, files come out `640` and directories `750`. Check every prediction with a test file and `stat -c '%a'`.

**From [Making The umask Stick](./course-02-making-the-umask-stick.md):**

- `umask` at the prompt lasts for that shell only. For every login, put it in `~/.bash_profile` or `~/.profile`, then `source` the file or log in again.
- `/etc/login.defs` holds the system-wide default in its `UMASK` line.
- Type the mask, not the result: `027` for `640` files and `750` directories.
- Services and scheduled jobs inherit their own mask. `systemd` units can set `UMask=`.
- The mask sets bits, not the group. A team folder also needs setgid on the directory.

## Your missions

You proved the skills in a graded mission, right after the part that taught them:

| Mission | After the part | What you proved |
| --- | --- | --- |
| [umask Default Permissions Lab](../../../labs/lab-022/docs/question.md) | Making The umask Stick | made a fresh login for `candidate` create `640` files and `750` directories with no `chmod` |

If you skipped it, go back to it now. It is short, and the exam asks for exactly this skill.

## Check yourself

Try to answer each question before you open the answer.

<details>
<summary>1. The mask is <code>022</code>. What mode does a new file get, and a new directory?</summary>

The file gets `644` (`666` with group and other write switched off). The directory gets `755`.
</details>

<details>
<summary>2. Why can a mask of <code>000</code> never make a new file executable?</summary>

The file's starting base is `666`, which has no execute bit. The mask can only remove bits that were in the base, never add new ones.
</details>

<details>
<summary>3. A task says new files must be <code>640</code> and new directories <code>750</code>. What do you type?</summary>

`umask 027`. You type the mask, the bits to switch off, not the result.
</details>

<details>
<summary>4. You typed <code>umask 027</code> at the prompt. After the next login, new files are <code>644</code> again. Why?</summary>

A `umask` typed at the prompt lasts only for that shell session. Put `umask 027` in a login startup file such as `~/.bash_profile`.
</details>

<details>
<summary>5. You added <code>umask 027</code> to <code>~/.bash_profile</code>, but your current shell still uses the old mask. What is missing?</summary>

Adding the line does not change a running shell. Run `source ~/.bash_profile`, or start a fresh login session.
</details>

<details>
<summary>6. A service writes files with odd permissions, but your own <code>umask</code> is correct. Where do you look?</summary>

At the service's own mask. It inherits the mask of the process that started it, not your login shell's. A `systemd` unit can set it with `UMask=`.
</details>

<details>
<summary>7. Every team member has a loose mask, but nobody can open each other's new files in the team folder. What is missing?</summary>

The group. New files get each creator's own primary group. Set setgid on the team directory so new entries get the directory's group.
</details>

## Practise on your own

Repeat the module's key checks without help:

1. Run `umask` and `umask -S` and write down the mask and the resulting permissions.
2. Work out by hand what a new file and a new directory get under that mask. Create one of each and confirm with `stat -c '%a'`.
3. Pick a target, for example files `600` and directories `700`. Work backwards to the mask, set it in the current shell only, and check.
4. Persist the same mask in a login startup file, start a fresh login session (or `source` the file), and confirm it still produces the right results.
5. Explain out loud why a mask of `000` can never make a new file executable, using the file's `666` starting base.

## Clean up

When you are done with this module, remove any mission that is still running.

First, see what is still running:

```sh
astrona list
```

Remove the lab. The command takes its **name**, not its folder path:

```sh
astrona destroy ats-006-lab-022
```

Then check that everything is gone:

```sh
astrona list
```

```text
No astrona labs running.
```

You can start the mission again at any time with the `astrona run` command. It always starts clean, so nothing you broke carries over.

> *The umask is a stencil: it only blocks bits, so type what to block, and put it where every login reads it.*
