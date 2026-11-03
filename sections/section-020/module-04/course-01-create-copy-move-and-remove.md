# Create, Copy, Move And Remove

Astronaut, the cargo hold is only useful if you can put crates in it, copy them, move them between compartments and clear them out. This part shows the five orders you will type most often, and the one option on each that decides whether the result is what you meant.

## Making folders and empty files

A folder is a cargo compartment, and a file is a crate. `mkdir` (short for *make directory*) builds a compartment. `touch` makes an empty crate, or, if the crate already exists, it only updates its time stamp.

### Build a whole path in one order

Create the compartments `reports/2026/q1` inside `~/cargo`, even though none of them exists yet:

<!-- astrona:playground:renew -->

```sh
cd ~/cargo
mkdir -p reports/2026/q1
ls -R reports
```

Plain `mkdir reports/2026/q1` would fail, because `reports` and `2026` do not exist. The `-p` option (short for *parents*) creates every missing compartment on the way. It also stays quiet if the folder is already there, which makes it safe to run twice in a script.

### Make an empty file

```sh
touch reports/2026/q1/summary.txt
ls -l reports/2026/q1
```

The new file has size `0`. Run `touch` on it again and the size stays `0`, but the modification time moves to now.

## Copying without surprises

`cp` makes a second crate with the same contents. The copy is a new file, so it gets a new owner (you), a new time stamp and a mode that your `umask` shapes. When you need the copy to look like the original, ask for that.

### Plain copy and faithful copy

Copy `manifest.txt` twice, once plain and once with `-p`, and compare the time stamps:

```sh
cp manifest.txt manifest-plain.txt
cp -p manifest.txt manifest-faithful.txt
ls -l --time-style=long-iso manifest.txt manifest-plain.txt manifest-faithful.txt
```

The original and `manifest-faithful.txt` show `2026-01-15 10:00`. The plain copy shows the time of the moment you ran the command. The option `-p` (short for *preserve*) keeps the mode, the owner where you may and the time stamps. A third option, `-a` (short for *archive*), is `-p` plus recursion and link handling, and it is the usual choice to copy a whole tree.

### Copy a folder

`cp` refuses to copy a folder unless you say `-r` (short for *recursive*):

```sh
cp -r crates crates-copy
ls crates-copy
```

Without `-r`, `cp` prints `cp: -r not specified; omitting directory 'crates'` and copies nothing.

## Moving and removing

`mv` has two jobs that look like one. Inside the same compartment it renames a crate. Into another compartment it moves the crate there. Either way the crate is the same, and only its label or place changes.

### Rename and move

```sh
mv manifest-plain.txt manifest-old.txt
mv manifest-old.txt reports/2026/
ls reports/2026
```

The first order renames the file. The second moves it into the `2026` compartment. If the destination already holds a file of that name, `mv` replaces it without asking. Use `mv -i` to be asked first.

### Remove with care

`rm` throws a crate out of the airlock. There is no trash can and no undo:

```sh
rm manifest-faithful.txt
rm -r crates-copy
```

A file needs plain `rm`. A folder and everything in it needs `rm -r`. Add `-i` to be asked for every file. Always check the path before you press Enter, and be most careful with `rm -r` and a wildcard.

## Common pitfalls

> [!WARNING]
> - **Forgetting `-p` when the time stamp or mode matters.** A plain `cp` gives the copy a new time and a mode shaped by the `umask`.
> - **Forgetting `-r` on a folder.** `cp` and `rm` both refuse a folder without it.
> - **Treating `mv` as a copy.** After `mv` the old path is gone. A `mv` onto an existing name replaces that file without a question.
> - **Expecting `rm` to be undoable.** The file is gone as soon as the command ends.
