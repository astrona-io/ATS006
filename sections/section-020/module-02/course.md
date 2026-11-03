# umask: Why New Files Are Not 777 By Default

Astronaut, create a new file with `touch notes.txt` and check its permissions. You almost always see `644`, never `666` and never `777`, even though you never ran `chmod`. Create a new directory with `mkdir project` and it usually comes out `755`. Nobody typed those numbers. They come from the `umask`: the default lock setting on every new crate in your cargo hold.

This module shows how that setting works, how to predict what it produces, and how to make it stick for every future login.

## Learning objectives

After this module you can:

- Name the starting permissions the kernel uses for a new file (`666`) and a new directory (`777`).
- Explain why the `umask` can only remove permission bits, never add them, and why a new file is never executable from the `umask` alone.
- Read the current mask with `umask` and `umask -S`, and predict the mode of a new file and a new directory by hand.
- Work backwards from a required result (files `640`, directories `750`) to the mask that produces it (`027`).
- Set a `umask` for the current shell only, and persistently in a login startup file.
- Explain why services and scheduled jobs have their own `umask`, and why the `umask` alone does not make a folder shared by a team.

## Before you start

Check these few things before your first mission.

### What you should already know

- **Permission bits.** A mode like `640` gives the owner `rw-`, the group `r--` and everyone else nothing. Read is `4`, write `2`, execute `1`.
- **Files and directories.** On a directory, execute (`x`) means "may enter it".
- **`sudo` and `root`.** `root` is the captain of the ship, and `sudo` borrows the captain's authority for one command.

### What you need

A playground: one Ubuntu 24.04 training ship in the simulator, with the `bash` shell. Everything the examples use is already on it, so you do not need to install anything.

### What is in your playground

Your playground is a virtual machine on your computer. It already has:

- The default `umask` of the `candidate` user, with no override in any start-up file.
- An empty folder `~/umask-practice`.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->

Open a terminal on it:

```sh
astrona ssh umask-playground
```

Every command block in the parts runs **inside that virtual machine**, as the user `candidate`, who can use `sudo`.

## How this module is laid out

Read the parts in order. The mission comes right after the part that teaches its skills.

1. [How The umask Shapes New Files](./course-01-how-the-umask-shapes-new-files.md): the starting permissions, the mask, and predicting the result.
2. [Making The umask Stick](./course-02-making-the-umask-stick.md): current shell versus every login, services, and team folders.
   - Mission: [umask Default Permissions Lab](../../../labs/lab-022/docs/question.md)
3. [Wrap-Up: Mission Debrief](./course-03-wrap-up.md)

## Why this matters

A wrong `umask` creates wrong permissions silently, on every file, every day, until someone notices. A mask that is too loose leaves new files readable by everyone. A mask that is too strict breaks a team's shared work. The exam asks you to set a persistent `umask` from a required result, so you must be able to work the numbers both ways.
