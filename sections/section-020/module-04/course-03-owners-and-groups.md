# Owners And Groups

Astronaut, every crate has an owner and a team. The mode bits only say what the owner, the team and everyone else may do. They do not say who the owner and the team are. This part shows how to read those two names, and how to change them with `chown` and `chgrp`.

## Reading the owner and the group

Every file has one owner (a user) and one group. `ls -l` prints them in the third and fourth columns, and `stat` can print them on their own.

### See who owns what

Look at the crates in your playground:

<!-- astrona:playground:renew -->

```sh
cd ~/cargo
ls -l crew.txt
stat -c '%U:%G %n' crew.txt crates crates/one.txt
id loadmaster
```

`%U` is the owner name and `%G` is the group name, so each line reads `candidate:candidate` followed by the path. `id loadmaster` shows that this user belongs to the group `loaders`. A file is shared with a team by giving the file to the team's group.

## Changing the owner and the group

`chown` (short for *change owner*) changes the owner, the group or both. Only `root` may give a file to another owner, so you use `sudo`.

### Change both at once

The form is `chown OWNER:GROUP file`. Give `crew.txt` to `loadmaster` and the group `loaders`:

```sh
sudo chown loadmaster:loaders crew.txt
stat -c '%U:%G %n' crew.txt
```

The second command prints `loadmaster:loaders` and the path. You wrote the file, but the owner is now someone else. Because the mode is a normal one, you can still read it but may no longer be able to change it.

### Change only the group

Two shorter forms change only one name. `chown :loaders file` changes only the group, and `chown loadmaster file` changes only the owner. The older command `chgrp` (short for *change group*) does the same as the first form:

```sh
sudo chgrp loaders crates/one.txt
stat -c '%U:%G %n' crates/one.txt
```

An ordinary user may use `chgrp` without `sudo` only on files they own, and only to give them to a group they belong to. `candidate` is not in `loaders`, so `sudo` is needed here.

### Change a whole tree

A folder and the files in it have their own owners. `-R` (short for *recursive*) goes through the whole tree:

```sh
sudo chgrp -R loaders crates
stat -c '%U:%G %n' crates crates/one.txt crates/two.txt
```

All three lines now read `candidate:loaders`. The owner stayed `candidate`, because `chgrp` only touches the group.

### Put back what you changed

Return `crew.txt` to your own ownership so the playground is tidy:

```sh
sudo chown candidate:candidate crew.txt
```

## Common pitfalls

> [!WARNING]
> - **Using `chown` without `sudo`.** An ordinary user cannot give a file away. The command fails with `Operation not permitted`.
> - **Forgetting `-R` on a folder.** Without it only the folder changes, and the files inside keep the old owner.
> - **A dot or a colon.** Write `owner:group`. A command that gives only `owner:` also sets the group to that user's login group.
> - **Running `sudo chown -R` on the wrong path.** A typo such as `/ home` or a stray `/` can change the owner of a whole system. Check the path first.

## Your mission: File Operations, Links and Ownership Lab

You can now build a path with `mkdir -p`, copy a file faithfully, move and remove files, make both kinds of link and hand a tree to a group. The mission asks you to do all of these on a fresh cargo hold: a tree to build, a manifest to copy with its mode and time, a file to move, a hard link and a symbolic link to make, a scratch folder to remove and a crates folder to hand to the group `loaders`.

The mission runs on its own training ship, so first pause your playground. Nothing in it is lost:

```sh
astrona stop file-ops-links-playground
```

Then start the mission:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-024
```

Open a terminal on the mission ship:

```sh
astrona ssh ats-006-lab-024
```

Read the task in [the question](../../../labs/lab-024/docs/question.md) and solve it on your own first. When you think you are done, send it for grading from your own computer:

```sh
astrona submit -c labs/lab-024
```

When the mission is done, remove it and wake your playground up again:

```sh
astrona destroy ats-006-lab-024
astrona start file-ops-links-playground
```
