# Matching Files By Age, Size And Permission

Astronaut, `find` is your cargo search drone. You give it a starting compartment and a list of tests, and it walks every compartment below, reporting each crate that passes all the tests. This part covers the three kinds of test you need most, by age, by size and by permission, and how to act on what `find` matches.

`find` does all the work itself: it reads each file's details (its modification time, size and mode) and compares them with your tests. Nothing changes on disk until you add an action such as `-delete` or `-exec`.

## A test compartment to search

The examples in this part all run against one small test folder. Build it first, so every command has something real to find.

### Try it: build the test folder

`head -c 1024 /dev/zero` writes 1024 zero bytes, so each file gets an exact size. `touch -d` sets a file's modification time to a date you choose:

```bash
mkdir -p /tmp/triage-demo
cd /tmp/triage-demo
head -c 1024 /dev/zero > old-log.txt
touch -d "2019-05-01" old-log.txt
head -c 1024 /dev/zero > small.txt
head -c 20480 /dev/zero > big.bin
head -c 5120 /dev/zero > open.sh
chmod 777 open.sh
```

You now have four files: an old 1 KiB log, a new 1 KiB file, a new 20 KiB file and a new 5 KiB file with mode `777`. A KiB (kibibyte) is 1024 bytes.

## Age: a relative day count or an absolute date

`find` can test a file's age in two ways. One counts days back from right now, the other compares with a fixed calendar date. This section shows when each is the right tool.

### Relative days with `-mtime`

`-mtime` counts whole days back from the moment you run the command. `-mtime +30` means "modified more than 30 days ago, as of right now". That is useful for questions that really are relative, like "what has not changed in the last month".

It is the wrong tool as soon as a task names an absolute calendar date. A relative count drifts depending on the day you run it.

### An absolute date with `-newermt`

For an absolute cutoff, `-newermt` (GNU `find`'s "newer than this time" test) compares with a literal date:

```bash
find /var/log/app-events -maxdepth 1 -type f ! -newermt "2022-06-01" -print
```

`-newermt "2022-06-01"` matches files modified after midnight at the start of that date. The `!` in front turns the test around: it matches everything that is not newer than the cutoff, so everything modified at or before it. `-type f` keeps only regular files, and `-maxdepth 1` keeps `find` in the top level of the folder.

### Try it: preview an age match

Run the same kind of test in the test folder:

```bash
cd /tmp/triage-demo
find . -maxdepth 1 -type f ! -newermt "2022-06-01" -print
```

```text
./old-log.txt
```

Only the file you dated 2019 matches. The others were just created, so they are newer than the cutoff.

### From a preview to a delete

`-print` is `find`'s default action, so leaving out the action does the same thing. A preview costs nothing and shows exactly what you are about to change. Once it looks right, swap `-print` for `-delete`:

```bash
find /var/log/app-events -maxdepth 1 -type f ! -newermt "2022-06-01" -delete
```

`-delete` removes the matched files directly, as a `find` action. That is safer than piping names into `xargs rm`, because only files `find` itself matched are touched, with no shell word-splitting in between.

On systems whose `find` has no `-newermt`, you get the same result with a reference file. `touch -d` gives the reference file the cutoff date, and `! -newer` matches everything not newer than it:

```bash
touch -d "2022-06-01" /tmp/cutoff-marker
find /var/log/app-events -maxdepth 1 -type f ! -newer /tmp/cutoff-marker -delete
```

> [!TIP]
> Make it a habit: run every destructive `find` once with `-print` first, read the list, then press the up arrow and change only the action.

## Size: bare, minus and plus

`-size` tests a file's size. Its three prefix forms mean genuinely different things, so this section shows them side by side, then the two ways to act on a match.

### The three forms

- A bare number, `3k`, means exactly that size.
- A minus prefix, `-3k`, means less than that size.
- A plus prefix, `+3k`, means more than that size.

The lowercase `k` means units of 1024 bytes, that is KiB. That matters when a task gives sizes in KiB. `M` means units of 1024 KiB.

`find` first rounds the file's size up to whole units, then compares. So `-size -3k` matches files that round up to 1 or 2 KiB. A file of 2.5 KiB rounds up to 3 and does not match `-3k`.

### Try it: match by size

```bash
cd /tmp/triage-demo
find . -maxdepth 1 -type f -size +10k
```

```text
./big.bin
```

Only the 20 KiB file is larger than 10 KiB. Now look for small files. `sort` puts the names in a fixed order, because `find` lists them in the order the directory stores them:

```bash
find . -maxdepth 1 -type f -size -3k | sort
```

```text
./old-log.txt
./small.txt
```

Both 1 KiB files match. The 5 KiB `open.sh` is neither small nor large here.

### Acting on a match with `-exec`

`-exec` runs a command for the matched files. `{}` stands for the file name, and `\;` ends the command:

```bash
find /srv/exports -maxdepth 1 -type f -size -500k -exec mv {} /srv/exports/tiny/ \;
find /srv/exports -maxdepth 1 -type f -size +50M -exec mv {} /srv/exports/oversized/ \;
```

The `\;` form starts one process per matched file. It is simple, and safe even with unusual file names, but slow on a very large number of files.

The `+` form batches many file names into far fewer runs, a bit like `xargs`. With `+`, the `{}` must come last, right before the `+`. For `mv` that means naming the target directory first with `-t`:

```bash
find /srv/exports -maxdepth 1 -type f -size -500k -exec mv -t /srv/exports/tiny/ {} +
```

The `+` form only works with commands that accept many file names at the end, like `mv -t dir file1 file2 ...` or `cp -t`. That is common, but not true of every command.

## Permission: exact, all bits, any bit

`-perm` tests a file's mode, and it has three forms that are easy to mix up. This section shows each one, and which to pick for an audit.

### The three forms

- A bare mode, `-perm 0777`, matches permissions that are exactly that value, nothing more and nothing less.
- A mode with a `-` prefix, `-perm -0002`, matches files where all the listed bits are set, whatever else is set too. `-perm -0002` finds every file that others can write to.
- A mode with a `/` prefix, `-perm /022`, matches files where any of the listed bits is set. `/022` finds files that the group or others can write to.

```bash
find /srv/exports -maxdepth 1 -type f -perm 0777 -exec mv {} /srv/exports/quarantine/ \;
```

### Which one to use

For an exact-match audit, "flag only files that are precisely wide open", the bare mode is correct. For a security sweep, "any file that the group or others can write to", the `/022` form casts a much wider net. In the same way, `-perm -0002` finds every file that others can write to, whatever else is set. Wider forms usually find more files worth a second look.

### Try it: match by permission

```bash
cd /tmp/triage-demo
find . -maxdepth 1 -type f -perm 0777
```

```text
./open.sh
```

Only the file you gave mode `777` matches the exact test.

## Common pitfalls

> [!WARNING]
> - **Using `-mtime` for a calendar date.** A relative day count drifts. Use `! -newermt "YYYY-MM-DD"` for "modified before a date".
> - **Adding `-delete` before a preview.** Run the same command with `-print` first and read the list.
> - **Mixing up `-3k` and `+3k`.** Minus means smaller, plus means larger, a bare number means exactly that size.
> - **Forgetting that `-size` rounds up.** A 2.5 KiB file counts as 3 KiB and does not match `-3k`.
> - **Putting anything between `{}` and `+`.** With `+`, `{}` must come last. Use `mv -t <dir> {} +`.
> - **Mixing up the three `-perm` forms.** A bare mode is an exact match, `-` means all listed bits, `/` means any listed bit.
