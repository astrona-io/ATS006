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

A terminal on an Ubuntu 24.04 machine with `bash`, `tar`, `gzip` and `bzip2`. You can also use a running lab machine: start a lab and open a terminal on it with `astrona ssh <lab name>`. There is no playground for this module.

## How this module is laid out

1. [Archives And Compressors](./course-01-archives-and-compressors.md): what `tar` does, what the compressor does, how to force the best gzip level, and how to look inside an archive.
2. [Convert And Prove](./course-02-convert-and-prove.md): compare two archives honestly, and convert one without touching the original.
   - Mission: Archive Conversion & Verification Lab
3. [Wrap-Up: Mission Debrief](./course-03-wrap-up.md)

## Why this matters

Archives move data between machines, teams and years. If a conversion drops a file or quietly ignores a compression request, nobody notices until the day the data is needed. The habits in this module (list before you trust, sort before you compare, never write to the original) protect you on the exam and on every real server.
