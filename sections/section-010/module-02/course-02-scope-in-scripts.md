# Scope In Scripts, Braces And Quotes

Astronaut, a script often does two kinds of work: scratch work for itself, and handing a value on to a program it starts. Only the second kind needs to go into the briefing pack, the environment that child processes receive. This part shows how to decide which variables to `export`, and two habits that keep a variable's value correct when you build longer strings: braces and double quotes.

A quick reminder: a plain `NAME=value` creates a **shell variable**, seen only by the current shell. `export NAME` turns it into an **environment variable**, which every child process gets a copy of when it starts.

## Which variables need `export`

Picture a wrapper script that builds a database connection string and then calls a separate client program to use it:

```bash
#!/bin/bash
DB_HOST="db.internal"          # only needed inside this script
export DB_URL="postgres://${DB_HOST}/app"   # the client binary needs this

my-db-client
```

### Scratch work stays local

`DB_HOST` is scratch work: a value this script uses to build something else, and nothing outside the script reads it. It does not need `export`. Adding it would not be wrong, just pointless, because nothing downstream looks at `DB_HOST`.

### Values for a child must be exported

`DB_URL` is different. `my-db-client` reads it, and `my-db-client` is a separate process that the script starts. Without `export`, `my-db-client` would start and find `DB_URL` undefined, because a plain assignment never leaves the script's own shell process.

This is the practical reason the Linux Foundation Certified System Administrator (LFCS) exam cares about the difference: **the scope of a variable decides what configuration a started service or child process can see.** A systemd service, a cron job, a container, a program started by a script: each one only gets what was exported into the environment it was started from. A variable that was set correctly but never exported might as well not exist for a child process.

## Braces: `${VAR}` vs `$VAR`

When you join a variable to text right after it, bash has to decide where the variable name ends. Braces remove any doubt.

### An example that goes wrong

```bash
SUFFIX="prod"
echo "$SUFFIX_backup"      # looks for a variable named SUFFIX_backup — probably empty!
echo "${SUFFIX}_backup"    # correctly expands SUFFIX, then appends the literal text
```

Without braces, bash reads `$SUFFIX_backup` as one variable name, `SUFFIX_backup`. It does not read it as the value of `SUFFIX` followed by the text `_backup`.

### When it matters

This only becomes a bug when the next character could be part of a variable name: a letter, a digit or an underscore. `${VAR}-suffix` and `$VAR-suffix` behave the same, because `-` can never be part of a variable name. But the underscore case above really does produce different, silently wrong output. The safe habit is to always put braces around a variable that is directly followed by more text.

## Quotes during expansion

The kind of quotes you use decides whether bash replaces `$VAR` with its value at all.

### Single quotes stop expansion

```bash
export CONFIG_PATH="${HOME}/app-extended"     # correct: expands, then exports
export CONFIG_PATH='${HOME}/app-extended'     # wrong: single quotes suppress expansion entirely
```

Single quotes in bash turn off all expansion, including variable replacement. So the second line exports the literal text `${HOME}/app-extended`, not the path you meant.

### Double quotes expand and protect

Double quotes still let `$VAR` and `${VAR}` expand. They also protect the result from being split into separate words or treated as a file name pattern. That is why "double-quote your expansions" is close to a universal rule in shell scripts.

## Try it: build a new exported variable

This step builds a new variable from an existing one, with braces and double quotes, and checks that a child shell sees it. It needs the variable `LOCAL_ONLY` set to `abc` and exported. Set it first:

```sh
export LOCAL_ONLY=abc
```

### Build and export the new variable

```sh
export TAGGED="${LOCAL_ONLY}_v2"
echo "$TAGGED"
```

```text
abc_v2
```

The braces end the name `LOCAL_ONLY` before `_v2`, and the double quotes let it expand.

### Check that a child sees it

Then check the result from a child shell:

```sh
bash -c 'echo "$TAGGED"'
```

```text
abc_v2
```

The child sees the full value because `TAGGED` was exported.

> [!TIP]
> When you write a script, ask one question for each variable: "Does a program this script starts need to read it?" Export it only if the answer is yes.

## Common pitfalls

> [!WARNING]
> - **Forgetting `export` for a value a child program reads.** The child starts with the variable undefined.
> - **Writing `$VAR_suffix` without braces.** Bash looks for a variable called `VAR_suffix`. Write `${VAR}_suffix`.
> - **Using single quotes around a value that must expand.** `'${HOME}/dir'` stays literal text. Use double quotes.
> - **Exporting everything "to be safe".** A variable meant to stay inside the script then reaches every child process, which can change how those programs behave.

## Your mission: Environment Variable Scope Lab

You can now decide which variables in a script stay local and which a child process must see, and build one value from another with braces and double quotes. The mission asks you to write a script that keeps one variable local, exports another built from an existing variable, and leaves `~/.bashrc` alone.

Start the mission:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-012
```

Open a terminal on the lab machine:

```sh
astrona ssh ats-006-lab-012
```

Read the task in [the question](../../../labs/lab-012/docs/question.md) and solve it on your own first. When you think you are done, send it for grading:

```sh
astrona submit -c labs/lab-012
```

When the mission is done, remove it:

```sh
astrona destroy ats-006-lab-012
```
