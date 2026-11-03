# Overview: PLAYGROUND - Permission Bits and Special Bits

This is a **playground**, not a lab. The environment starts clean, runs
`bootstrap/prepare.sh`, and then waits. There is no task, no `astrona submit`,
and no pass or fail. Explore, break things, `astrona destroy`, start over.

## What is in the box

- A qemu Ubuntu 24.04 virtual machine, reached with `astrona ssh chmod-bits-playground`.
- The folder `/srv/chmod-practice` with `notes.txt`, a script `run-report.sh` (not yet executable) and a subfolder `shared`.
- The group `crew` and the user `crewmate`, who is a member of `crew`.

## Things to try

- Read the modes with `ls -l /srv/chmod-practice` and change them with both octal and symbolic `chmod`.
- Make `run-report.sh` executable and run it.
- Set the setgid bit on `shared`, create a file inside it and see which group owns it.

## When you are done

```sh
astrona destroy chmod-bits-playground
```
