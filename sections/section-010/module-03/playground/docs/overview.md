# Overview: PLAYGROUND - Shell Scripting Basics

This is a **playground**, not a lab. The environment starts clean, runs
`bootstrap/prepare.sh`, and then waits. There is no task, no `astrona submit`,
and no pass or fail. Explore, break things, `astrona destroy`, start over.

## What is in the box

- A qemu Ubuntu 24.04 virtual machine, reached with `astrona ssh script-basics-playground`.
- The folder `~/inbox` with three `.txt` files (of 2, 5 and 9 lines), one `.log` file and one empty subfolder named `archive`.
- An empty folder `~/scripts` where you can save your own scripts.

## Things to try

- Write a script that prints how many arguments it received and exits with code `2` if there are none.
- Loop over `~/inbox/*.txt` and print each file name with its line count.
- Run the script with a folder that does not exist and check that `echo $?` shows your failure code.

## When you are done

```sh
astrona destroy script-basics-playground
```
