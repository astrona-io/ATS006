# Solution Walkthrough

This walkthrough repacks `import001.tar.bz2` as a level 9 gzip archive and proves that the two archives hold the same files. `tar` does the bundling, `bzip2` and `gzip` do the compression, and sorted listings plus `diff` give the proof. The original archive is only ever read.

## Step 1: Look at the starting state

Note the size and time of the original archive before you touch anything:

```bash
ls -lh /imports/import001.tar.bz2
```

This is your baseline. If anything looks wrong later, you can compare against it. The grader checks the original with a checksum taken when the machine was set up, so any change to it fails the mission.

`/imports` was created by `root`. If your user cannot write files there, run the steps below from a root shell (`sudo -i`); the commands stay the same.

## Step 2: List the bzip2 archive, sorted

```bash
tar -tjf /imports/import001.tar.bz2 | sort > /imports/import001.tar.bz2_list
```

`-t` lists the archive's index without extracting anything, and `-j` reads it through `bzip2`. `sort` puts the lines in a fixed order, so this listing can be compared with the new archive's listing later.

## Step 3: Extract into a throwaway staging directory

```bash
mkdir -p /tmp/import001-extract
tar -xjf /imports/import001.tar.bz2 -C /tmp/import001-extract
```

`-C` sends the extraction into the staging directory only. `tar` opens the original archive in `/imports` for reading, never for writing.

## Step 4: Repack as gzip at maximum compression

```bash
cd /tmp/import001-extract
tar --use-compress-program="gzip -9" -cf /imports/import001.tar.gz .
```

`tar -czf` alone would silently use the default `gzip` level (6), not the best one. `--use-compress-program="gzip -9"` skips that shortcut and runs `gzip` with `-9`. Archiving `.` from inside the staging directory keeps the new archive's internal paths in the same relative form as the original's.

## Step 5: List the gzip archive, sorted

```bash
tar -tzf /imports/import001.tar.gz | sort > /imports/import001.tar.gz_list
```

`-z` reads the new archive through `gzip`. The grader checks that both listing files match the real, sorted contents of their archives, so always build them with `tar -t` and `sort`, never by hand.

## Step 6: Remove the staging directory

```bash
rm -rf /tmp/import001-extract
```

Leftover extracted files only confuse a later disk space check.

## Step 7: Check the result and submit

Compare the two listings:

```bash
diff /imports/import001.tar.bz2_list /imports/import001.tar.gz_list
```

No output means both archives hold the same files.

Check the type of the new archive, and read the extra flags byte of its gzip header:

```bash
file /imports/import001.tar.gz
od -An -tu1 -j8 -N1 /imports/import001.tar.gz
```

`file` should report `gzip compressed data`. The byte at offset 8 is the one the grader reads: `2` means level 9. A `0` means the default level was used, so repeat Step 4.

Check that the original is unchanged:

```bash
ls -lh /imports/import001.tar.bz2
```

The size and time should match Step 1.

Do not rely on `GZIP=-9 tar -czf ...` as your only method. Newer `gzip` releases deprecate that environment variable, and `--use-compress-program` is the durable way to force a level through `tar` on any version.

When every check passes, send the mission for grading from your own computer:

```bash
astrona submit -c labs/lab-051
```
