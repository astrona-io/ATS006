# Making The umask Stick

Astronaut, a lock setting that resets every time you leave the bridge console is not much use. This part shows how to change the `umask`, the default lock setting on every new crate, for the current shell only and for every future login. It also covers two places where a personal `umask` does not reach: services, and the group of a team's shared files.

## One shell versus every login

The shell's `umask` command changes the mask of the shell you type it in. This section shows why that change disappears, and where to put it so it lasts.

### A change at the prompt

Typing `umask 027` at a prompt changes the mask for that one interactive shell session only. Programs you start from that shell inherit it. As soon as the session ends, the change is gone, and the next login starts with the old mask again.

### Try it: work backwards and test in the current shell

Pick a target result, for example new files at `600` and new directories at `700`. Work backwards: which bits must be switched off? For the directory, `777` must become `700`, so the group and others lose everything: mask `077`. For the file, `666` with `077` switched off also gives `600`. Set it in a subshell and check:

```bash
rm -rf /tmp/target-file /tmp/target-dir
( umask 077; touch /tmp/target-file; mkdir /tmp/target-dir )
stat -c '%a %n' /tmp/target-file /tmp/target-dir
```

```text
600 /tmp/target-file
700 /tmp/target-dir
```

The parentheses run the commands in a subshell, so your own shell keeps its mask.

### Persisting the mask in a login startup file

To make a mask stick for every future login, put it in a startup file that `bash` reads when a login shell starts. For a login shell, that is usually `~/.bash_profile` or `~/.profile`:

```bash
echo 'umask 027' >> ~/.bash_profile
source ~/.bash_profile
```

The `source` step, or simply starting a fresh login session, is what applies the change to a shell that is already running. Adding the line alone does not change the current shell.

For a system-wide default that applies to every user who does not set their own, the setting lives in `/etc/login.defs`, in the `UMASK` line.

### Try it: prove the mask survives a new login

Test persistence on a throwaway user, so your own startup files stay as they are. `sudo -iu maskcadet` starts a fresh login shell as that user, and `bash -lc` runs the commands in a login shell that reads `~/.bash_profile`, exactly like a new login would:

```bash
sudo useradd -m -s /bin/bash maskcadet
echo 'umask 077' | sudo tee -a /home/maskcadet/.bash_profile
sudo -iu maskcadet bash -lc 'touch ~/verify-file; mkdir ~/verify-dir; stat -c "%a %n" ~/verify-file ~/verify-dir'
```

```text
umask 077
600 /home/maskcadet/verify-file
700 /home/maskcadet/verify-dir
```

The first line is `tee` repeating what it wrote. The last two lines prove that a brand-new login for `maskcadet` read the mask from `~/.bash_profile`, with no `chmod` involved.

### Type the mask, not the result

`umask` takes the mask, never the result you want. If a requirement says "new files should come out `640`", the number to type is `027`, the value that turns `666` into `640`. It is not `640` itself. Mixing the two up is one of the most common `umask` mistakes.

## Services and scheduled jobs have their own umask

A per-user `umask` only reaches processes that inherit that user's login shell. This section explains which processes do not, and where to look instead.

### Where a service gets its mask

A service run by `systemd`, the ship's duty officer, a `cron` job (a scheduled task) or a daemon started from a startup script usually does not run inside anyone's interactive shell. It inherits the mask of the process that started it, which often has nothing to do with any user's `~/.bash_profile`.

If a service creates files with permissions that look wrong, and its own configuration sets no permissions, check the `umask` its process runs with first. `systemd` units have an explicit `UMask=` directive for exactly this reason: a service often needs a different mask from a person.

## The umask and team folders are different problems

It is tempting to use the `umask` alone to solve "everyone on the team should be able to work with everyone's files". This section shows why that is only half the answer.

### Bits versus group

The `umask` only decides the permission bits when a file is created. It says nothing about which group the new file belongs to. A new file always gets the creating user's own primary group, unless the directory says otherwise.

So a loose mask alone does not give a team shared access: the files still land in each person's private group. The group half of the problem is solved by the setgid bit on the directory. With setgid set, every new entry gets the directory's group instead of the creator's. Real team folders usually need both: a mask loose enough that group members can read and write each other's files, and setgid so those files land in the team's group.

## Common pitfalls

> [!WARNING]
> - **Typing the result instead of the mask.** For `640` files and `750` directories, type `umask 027`, not `umask 640`.
> - **Setting the mask at the prompt only.** It is gone at the next login. Put it in `~/.bash_profile` or `~/.profile`.
> - **Forgetting to apply it.** Adding the line does not change a running shell. Run `source ~/.bash_profile` or start a new login.
> - **Creating `~/.bash_profile` where none existed.** When it exists, a `bash` login shell reads it and skips `~/.profile`, so settings kept only in `~/.profile` stop loading.
> - **Blaming a user's mask for a service's files.** Services inherit their own mask. Look at the unit's `UMask=` setting.
> - **Expecting the mask to set the group.** It only sets bits. A team folder also needs setgid.

## Your mission: umask Default Permissions Lab

You can now predict what a mask produces, work backwards from a required result, and make the mask last for every login. The mission asks you to do this for the user `candidate`, so that a brand-new login creates `640` files and `750` directories with no `chmod` at all.

Start the mission:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-022
```

Open a terminal on the lab machine:

```sh
astrona ssh ats-006-lab-022
```

Read the task in [the question](../../../labs/lab-022/docs/question.md) and solve it on your own first. When you think you are done, send it for grading:

```sh
astrona submit -c labs/lab-022
```

When the mission is done, remove it:

```sh
astrona destroy ats-006-lab-022
```
