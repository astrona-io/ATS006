# Overview: PLAYGROUND - Archives and Compression

This is a **playground**, not a lab. The environment starts clean, runs
`bootstrap/prepare.sh`, and then waits. There is no task, no `astrona submit`,
and no pass or fail. Explore, break things, `astrona destroy`, start over.

## What is in the box

- A qemu Ubuntu 24.04 virtual machine, reached with `astrona ssh archive-convert-playground`.
- The folder `~/archive-practice/reports` with three small text files.
- The archive `~/archive-practice/sample.tar.bz2`, which holds those three files.
- `tar`, `gzip`, `bzip2` and `xz` installed.

## Things to try

- List the archive with `tar -tvf` before you unpack it.
- Unpack it into a new folder and convert it to `.tar.gz`.
- Compare the sizes of the two archives with `ls -l` and check one with `tar -tzf`.

## When you are done

```sh
astrona destroy archive-convert-playground
```
