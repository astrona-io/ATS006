# Environment Variables and Scope

Astronaut, when a crew member hands a job to a new crew member, they also hand over a briefing pack. The new crew member gets a copy of that pack, and nothing else. A note you scribbled on your own console does not go into the pack unless you put it there.

That is exactly how variables work on Linux. This module shows the difference between a note on the console (a shell variable) and a line in the briefing pack (an environment variable), what `export` does, and the two syntax habits that keep expansions correct: braces and double quotes.

## Learning objectives

After this module you can:

- Explain what a process's environment is, and how a child process gets a copy of it.
- Tell a shell variable from an environment variable, and predict which one a child process can see.
- Use `export` to make a variable visible to child processes, and check the result with `export -p`.
- Decide which variables in a script need `export` and which should stay local.
- Use `${VAR}` braces when a variable is followed by more text.
- Choose double quotes over single quotes when a value must expand.

## Before you start

Check that you have the knowledge and the tools this module expects before you begin.

### What you should already know

- **How to type a command at a prompt** and run a script from a file.
- **That `echo` prints text**, and that `$NAME` in a command is replaced by the value of the variable `NAME`.

### What you need

- A terminal on an Ubuntu 24.04 machine with the bash shell. Any Ubuntu 24.04 machine works for the examples in the parts.
- Or a running lab machine: start a lab with `astrona run` and open a terminal on it with `astrona ssh <lab name>`. The mission in this module gives you the exact commands.

## How this module is laid out

1. [Shell Variables And Export](./course-01-shell-variables-and-export.md): the environment, why a plain variable goes nowhere, and what `export` changes.
2. [Scope In Scripts, Braces And Quotes](./course-02-scope-in-scripts.md): which variables a script must export, `${VAR}` braces, and quoting during expansion.
   - Mission: [Environment Variable Scope Lab](../../../labs/lab-012/docs/question.md)
3. [Wrap-Up: Mission Debrief](./course-03-wrap-up.md)

## Why this matters

A service, a scheduled job or a program started by a script only sees what was exported into the environment it was started from. A variable that is set correctly but never exported does not exist from that program's point of view. Knowing the rule turns "but I set it!" from a mystery into a two-second fix.
