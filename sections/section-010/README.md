# Section 010: Shell Semantics: Redirection, Exit Codes & Environment

Astronaut, before you can chase down a failing service, a broken scheduled job or a script that "just doesn't work on the other server", you need to know the wiring under every command you type. Every program is a crew member with three signal lines: orders in, reports out and alarms out. When it finishes, it radios back a status code. And when it starts a new crew member, it hands over a briefing pack of exported variables, and nothing else.

None of this is background reading. Wire the error line to the wrong place, and a log file silently misses the one line you needed. Forget to `export` a variable, and a script cannot see a value that is "clearly set" in your terminal. Both mistakes are common, both are easy to avoid once the model clicks, and both are favourite exam traps.

**Exam topics covered:** input and output redirection, and the shell environment.

---

## What You Will Master

- The three standard streams, stdin, stdout and stderr, on file descriptors 0, 1 and 2.
- Sending stdout or stderr to a file on its own with `>` and `2>`.
- Capturing both streams in one file with `> file 2>&1`, why the order matters, and the bash shorthand `&>`.
- Reading a program's exit code from `$?` before the next command overwrites it, and throwing output away with `/dev/null`.
- The difference between a shell variable and an exported environment variable, and how a child process gets a copy of the environment.
- Checking exported variables with `export -p`, and deciding which variables in a script need `export`.
- Using `${VAR}` braces and double quotes so values expand correctly.

---

## Modules In This Section

Work through the modules in this order. Each part teaches one idea. A mission (a graded lab) comes right after the part it practises, and the last page of each module is a wrap-up. The capstone at the end uses everything in the section at once.

### [Shell Redirection, stdout/stderr, and Exit Codes](module-01/course.md)

3 parts and 1 mission:

1. [Three Signal Lines](module-01/course-01-three-signal-lines.md)
2. [Combining Both Streams In The Right Order](module-01/course-02-combining-both-streams.md)
3. [Reading The Exit Code](module-01/course-03-reading-the-exit-code.md)
   - Mission: [Shell Redirection & Exit Code Diagnostics Lab](../../labs/lab-011/docs/question.md)
4. [Wrap-Up: Mission Debrief](module-01/course-04-wrap-up.md)

### [Environment Variables and Scope](module-02/course.md)

2 parts and 1 mission:

1. [Shell Variables And Export](module-02/course-01-shell-variables-and-export.md)
2. [Scope In Scripts, Braces And Quotes](module-02/course-02-scope-in-scripts.md)
   - Mission: [Environment Variable Scope Lab](../../labs/lab-012/docs/question.md)
3. [Wrap-Up: Mission Debrief](module-02/course-03-wrap-up.md)

### Knowledge check

Before the capstone, test your reasoning with the [Section 010 Knowledge Check](./quiz.md).

### Capstone

Your final mission for this section: **[Shell Semantics Integration Capstone Lab](../../labs/lab-010/docs/question.md)**. You build a wrapper script that exports the right variable to a health-check program, keeps another one local, and captures the program's stdout, stderr, both streams together and its exit code.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-010
astrona ssh ats-006-lab-010
astrona submit -c labs/lab-010
astrona destroy ats-006-lab-010
```
