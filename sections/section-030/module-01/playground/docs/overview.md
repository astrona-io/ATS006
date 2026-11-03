# Overview: PLAYGROUND - Searching and Rewriting Text with grep and sed

This is a **playground**, not a lab. The environment starts clean, runs
`bootstrap/prepare.sh`, and then waits. There is no task, no `astrona submit`,
and no pass or fail. Explore, break things, `astrona destroy`, start over.

## What is in the box

- A qemu Ubuntu 24.04 virtual machine, reached with `astrona ssh grep-sed-playground`.
- The file `~/logs/access.log` with ten made-up web request lines (status codes `200`, `404` and `500`).
- The file `~/logs/app.log` with a few lines that contain a made-up password and an email address.

## Things to try

- Count the lines with status `500` using `grep -c`.
- Print only the matching part of each line with `grep -o` and an extended pattern.
- Blank out the made-up password with `sed -E 's/password=[^ ]+/password=REDACTED/'`.

## When you are done

```sh
astrona destroy grep-sed-playground
```
