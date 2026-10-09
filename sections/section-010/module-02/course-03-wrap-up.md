# Wrap-Up: Mission Debrief

Well flown, astronaut. You have finished every part and the mission in this module. Before you move on, look back at what you learned, check yourself, and clean up anything still running.

## What you learned

This module was about the briefing pack every new process receives, and how you decide what goes into it.

**From [Shell Variables And Export](./course-01-shell-variables-and-export.md):**

- Every process has an environment. A child process gets a one-way copy of it at the moment it starts.
- A plain `NAME=value` is a shell variable: only the current shell sees it.
- `export` marks a variable so every child process gets a copy. `export -p` lists the exported variables as `declare -x NAME="value"`.

**From [Scope In Scripts, Braces And Quotes](./course-02-scope-in-scripts.md):**

- In a script, export only the values a child program must read. Scratch values stay local.
- Services, scheduled jobs and programs started by a script only see what was exported where they were started.
- Use `${VAR}` when the variable is followed by a letter, digit or underscore.
- Single quotes stop expansion. Double quotes expand and protect the result.

## Your missions

You proved these skills in a graded mission, right after the part that taught the last of them:

| Mission | After the part | What you proved |
| --- | --- | --- |
| [Environment Variable Scope Lab](../../../labs/lab-012/docs/question.md) | Scope In Scripts, Braces And Quotes | wrote a script with one local and one exported variable, built from an existing exported variable |

If you skipped it, go back to it now. It is short, and the exam asks for exactly these skills.

## Check yourself

Try to answer each question before you open the answer.

<details>
<summary>1. You run <code>GREETING=hello</code> and then <code>bash -c 'echo "$GREETING"'</code>. What prints, and why?</summary>

An empty line. `GREETING` is a plain shell variable, so the child shell started by `bash -c` never got a copy of it.
</details>

<details>
<summary>2. What does <code>export</code> actually do?</summary>

It marks an existing shell variable so that every child process the shell starts from then on gets a copy of it in its environment. It does not create a new kind of variable.
</details>

<details>
<summary>3. A child process changes an exported variable. Does the parent see the new value?</summary>

No. The child has its own copy. Changes stay in the child.
</details>

<details>
<summary>4. A script sets <code>DB_HOST</code> to build <code>DB_URL</code>, and then starts a client that reads <code>DB_URL</code>. Which of the two must be exported?</summary>

Only `DB_URL`. The client reads it. `DB_HOST` is scratch work inside the script.
</details>

<details>
<summary>5. Why does <code>echo "$SUFFIX_backup"</code> print nothing when <code>SUFFIX=prod</code>?</summary>

Bash reads `SUFFIX_backup` as one variable name, and that variable is not set. Write `${SUFFIX}_backup`.
</details>

<details>
<summary>6. What is exported by <code>export CONFIG_PATH='${HOME}/app-extended'</code>?</summary>

The literal text `${HOME}/app-extended`. Single quotes stop expansion. Use double quotes to get the real path.
</details>

## Clean up

Each mission runs a virtual machine on your computer. When you are done with this module, remove any mission that is still running.

First, see what is still running:

```sh
astrona list
```

If the mission is still there, remove it. The command takes its **name**, not its folder path:

```sh
astrona destroy ats-006-lab-012
```

Then check that everything is gone:

```sh
astrona list
```

```text
No astrona labs running.
```

> *A note on the console stays on the console. Only `export` puts it into the briefing pack.*
