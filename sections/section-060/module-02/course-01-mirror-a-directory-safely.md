# Mirror A Directory Safely

`rsync` compares a source and a destination directly. It sends only the parts of files that changed, and it can make the destination an exact copy of the source, including removing files the source no longer has. That last ability is also the most dangerous one: swap the source and the destination, and you erase the wrong side. This part builds the safe habits around that risk.

## What `-a` bundles together

Almost every serious `rsync` command starts with `-a`, archive mode. Here is a typical command that sends a folder of photos to a storage machine called `nas`:

```bash
rsync -avz -e ssh /photos/2024-shoot/ nas:/backup/2024-shoot/
```

`-a` is a documented short form for `-rlptgoD`:

- `-r`: recursive, go into every folder.
- `-l`: copy symbolic links as symbolic links.
- `-p`: keep permissions.
- `-t`: keep modification times.
- `-g` and `-o`: keep the group and the owner.
- `-D`: keep device and special files.

This matters because a backup that silently drops permissions or times is not a faithful copy. It only looks like one until something needs the lost details.

The other options in the command:

- `-v` prints each file as it transfers.
- `-z` compresses data on the way. This helps for text, and helps little for content that is already compressed, such as photos.
- `-e ssh` names the remote shell that `rsync` uses to reach the other machine. SSH is a sealed communications channel between two ships.

## The trailing slash

Whether the **source** path ends in a slash changes what lands at the destination. It catches out experienced administrators, so learn it by heart.

### With a trailing slash: the contents

With a trailing slash, `rsync` copies the **contents** of the source directory straight into the destination:

```bash
rsync -a /photos/2024-shoot/ nas:/backup/current/
# -> /backup/current/img001.jpg, /backup/current/img002.jpg, ...
```

### Without a trailing slash: the directory itself

Without it, `rsync` copies the source directory itself, and creates a directory of the same name inside the destination:

```bash
rsync -a /photos/2024-shoot nas:/backup/current/
# -> /backup/current/2024-shoot/img001.jpg, ...
```

Neither form is wrong. Both are useful in different jobs. But usually only one of them is what you meant, and you cannot see the difference until you look at the result.

## `--delete`: a true mirror

By default, `rsync` only adds. It copies new and changed files, but it never removes anything from the destination, even when the source file is long gone. To make the destination a true mirror, you must ask for it.

### Mirror with `--delete`

```bash
rsync -avz --delete -e ssh /photos/2024-shoot/ nas:/backup/current/
```

If you deleted `img003.jpg` from the source, this run removes it from the destination too. That is the point. But it also means a mistake does not fail loudly. If the source and the destination are swapped, or one path is wrong, `rsync` quietly and permanently deletes files on the wrong side. Think of it as a supply run that also throws crates overboard at the destination when the source no longer has them.

### Preview it first with a dry run

`rsync` has no "are you sure?" question for `--delete`. So you build that check into your own routine, every time:

```bash
rsync -avzn --delete -e ssh /photos/2024-shoot/ nas:/backup/current/
```

`-n` (or `--dry-run`) does every comparison a real run would do. It scans both trees and decides what it would transfer, update or delete. Then it prints that list without changing a single byte at the destination.

Lines that start with `*deleting` show exactly what would be removed. Read every one of them before you drop `-n`. That is the whole safety routine, and there is no shortcut.

> [!TIP]
> Make the dry run a habit: run the command with `-n`, read the `*deleting` lines, then press the up arrow, remove `-n` and run it for real. The command you run is then exactly the one you checked.

## `--exclude`: keep a subtree out

Some folders should never travel, such as a cache that rebuilds itself. `--exclude` keeps them out:

```bash
rsync -avz --delete --exclude=cache/ -e ssh /photos/2024-shoot/ nas:/backup/current/
```

An excluded path is invisible to `rsync`'s comparison in **both** directions. It is not copied when it is new, and it is not deleted when the destination has an old copy of it.

That matters when you run the same sync again. If you forget the exclude on the next run, files that were ignored before can suddenly be copied. And with `--delete`, a destination folder you meant to protect can suddenly look like it vanished from the source. Keep the exclude list the same on every run in a chain.

## Practise between two local folders

You can practise the whole routine without a second machine:

1. Create a source folder with a few files, and an empty destination folder. Run `rsync -avzn --delete` between them and check that the dry run output matches what you expect before you ever drop `-n`.
2. Run the real sync. Then delete one file from the source and run the dry run again. Check that it shows a `*deleting` line for exactly that file. Then run it for real and check that the destination lost it too.
3. Test the trailing slash: run the same sync once with a trailing slash on the source and once without, and compare the two destination layouts.

## Common pitfalls

> [!WARNING]
> - **Running `--delete` without a dry run.** Swapped or wrong paths delete files on the wrong side, with no warning. Always run with `-n` first and read every `*deleting` line.
> - **Forgetting the trailing slash, or adding one by habit.** `/src/` copies the contents; `/src` copies the folder itself into the destination.
> - **Changing the exclude list between runs.** Excluded paths are skipped in both directions. Drop an exclude, and those files start to sync or get deleted.
> - **Leaving out `-a`.** Without it, permissions, owners and times are not kept, and the copy is not faithful.
