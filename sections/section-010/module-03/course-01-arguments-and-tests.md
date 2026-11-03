# Arguments, Exit Codes And Tests

Astronaut, a procedure that only works for one crate is not much use. This part shows how a script receives its input, how it reports success or failure, and how it makes a decision.

## The smallest script

A script is a text file. The first line, `#!/bin/bash`, tells the system which program reads it. Save it, mark it executable with `chmod +x`, and run it with a path:

<!-- astrona:playground:renew -->

```sh
cd ~/scripts
cat > hello.sh <<'SCRIPT'
#!/bin/bash
echo "Hello, $1"
SCRIPT
chmod +x hello.sh
./hello.sh crew
```

The output is `Hello, crew`. Without `chmod +x`, `./hello.sh` fails with `Permission denied`.

## Arguments

The words after the script name are its arguments. Inside the script:

| Name | Holds |
| --- | --- |
| `$1`, `$2`, ... | the first, second, ... argument |
| `$#` | how many arguments there are |
| `$@` | all arguments, each one kept as its own word when written `"$@"` |
| `$0` | the name the script was run with |

```sh
cat > args.sh <<'SCRIPT'
#!/bin/bash
echo "count: $#"
echo "first: $1"
SCRIPT
chmod +x args.sh
./args.sh one two three
```

The output is `count: 3` and `first: one`.

## Exit codes

Every command ends with a number. `0` means success and anything else means failure. The shell keeps the number of the last command in `$?`:

```sh
ls ~/inbox > /dev/null
echo $?
ls /no/such/folder 2> /dev/null
echo $?
```

The first prints `0`. The second prints `2`, the code `ls` uses for a missing path. A script sets its own code with `exit N`. Use `1` for a general failure and a different number, such as `2`, for a wrong usage, so a caller can tell them apart.

## Making a decision

`if` runs a block when a test succeeds. In bash, write the test in double brackets:

```sh
cat > check.sh <<'SCRIPT'
#!/bin/bash
if [[ $# -eq 0 ]]; then
    echo "usage: check.sh <path>" >&2
    exit 2
fi
if [[ -d "$1" ]]; then
    echo "$1 is a directory"
elif [[ -f "$1" ]]; then
    echo "$1 is a file"
else
    echo "not found: $1" >&2
    exit 1
fi
SCRIPT
chmod +x check.sh
./check.sh ~/inbox; echo "code $?"
./check.sh; echo "code $?"
```

The first run prints the folder line and `code 0`. The second prints the usage line on stderr and `code 2`. The messages go to stderr with `>&2`, so they do not mix with normal output.

Common tests:

- `-d PATH` is true for a folder, `-f PATH` for a regular file, `-e PATH` for anything that exists.
- `-z STR` is true for an empty string, and `-n STR` for a non-empty one.
- `-eq`, `-ne`, `-lt`, `-gt` compare numbers. `==` and `!=` compare text.

## Common pitfalls

> [!WARNING]
> - **No spaces inside the brackets.** `[[ -d $1 ]]` works. `[[-d $1]]` fails with `command not found`.
> - **Comparing numbers with `==`.** Use `-eq` for numbers so `5` and `05` compare as numbers.
> - **Printing errors on stdout.** Send the error text to stderr with `>&2`.
> - **Forgetting `exit`.** A script that finds an error but keeps going may end with a success code.
