# Archive Conversion & Content Verification

Astronaut, your mission in this module is a repacking job. A sealed shipping container of crates has arrived, vacuum-packed with one machine. Mission control wants it packed with a different machine, as tightly as possible, and wants proof that not one crate went missing on the way.

On Linux that container is a `tar` archive, and the vacuum-packing is compression with `bzip2` or `gzip`. The commands are short. The traps are not: a "best compression" request that is silently ignored, two listings that look different when the content is the same, and an original archive that gets damaged during the move.

## Learning objectives

After this module you can:

- Explain the difference between an archive (`tar`) and compression (`gzip`, `bzip2`, `xz`), and which program does each job.
- Pick the right `tar` flag for each compressor: `-z`, `-j` or `-J`.
- Force the best gzip compression level through `tar` with `--use-compress-program="gzip -9"`, and explain why `-z` alone cannot do it.
- Prove which gzip level was used by reading the gzip header.
- List an archive's contents with `tar -t` without extracting anything.
- Prove two archives hold the same files with sorted listings and `diff`.
- Convert a `.tar.bz2` archive to `.tar.gz` without ever writing to the original.

## Before you start

Every mission starts with a pre-flight check, astronaut. Make sure you know the basics below and have a terminal ready.

### What you should already know

- **How to move around the filesystem.** You can use `cd`, `ls -la` and `mkdir -p`, and you know the difference between a relative path (`srv/reports`) and an absolute path (`/srv/reports`).
- **How a pipe works.** `command-one | command-two` sends the output of the first command straight into the second.

### What you need

A playground: one Ubuntu 24.04 training ship in the simulator, with the `bash` shell. Everything the examples use is already on it, so you do not need to install anything.

### What is in your playground

Your playground is a virtual machine on your computer. It already has:

- The folder `~/archive-practice/reports` with three small text files.
- The archive `~/archive-practice/sample.tar.bz2`, which holds those three files.
- `tar`, `gzip`, `bzip2` and `xz` installed.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->

Open a terminal on it:

```sh
astrona ssh archive-convert-playground
```

Every command block in the parts runs **inside that virtual machine**, as the user `candidate`, who can use `sudo`.

## How this module is laid out

1. [Archives And Compressors](./course-01-archives-and-compressors.md): what `tar` does, what the compressor does, how to force the best gzip level, and how to look inside an archive.
2. [Convert And Prove](./course-02-convert-and-prove.md): compare two archives honestly, and convert one without touching the original.
   - Mission: Archive Conversion & Verification Lab
3. [Wrap-Up: Mission Debrief](./course-03-wrap-up.md)

## Why this matters

Archives move data between machines, teams and years. If a conversion drops a file or quietly ignores a compression request, nobody notices until the day the data is needed. The habits in this module (list before you trust, sort before you compare, never write to the original) protect you on the exam and on every real server.
