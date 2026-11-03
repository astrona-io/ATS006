# Overview: PLAYGROUND - Comparing and Shaping Text

This is a **playground**, not a lab. The environment starts clean, runs
`bootstrap/prepare.sh`, and then waits. There is no task, no `astrona submit`,
and no pass or fail. Explore, break things, `astrona destroy`, start over.

## What is in the box

- A qemu Ubuntu 24.04 virtual machine, reached with `astrona ssh text-filters-playground`.
- The file `~/data/crew.csv` with a header and eight crew rows (`name,role,deck,hours`).
- The file `~/data/visits.log` with fifteen lines, each holding one station name.
- Two settings files, `~/data/settings-old.conf` and `~/data/settings-new.conf`, that differ in three lines.

## Things to try

- Sort the crew by hours with `sort -t, -k4 -n` and cut one column with `cut -d, -f1`.
- Count how often each station appears with `sort | uniq -c | sort -rn`.
- Compare the two settings files with `diff -u` and save a result with `tee`.

## When you are done

```sh
astrona destroy text-filters-playground
```
