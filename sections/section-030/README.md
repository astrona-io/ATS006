# Everyday Shell Craft: Text Processing, History & Aliases

Astronaut, this section is about working *faster and more precisely* at the bridge console you already have. It is the difference between an administrator who retypes a fifteen-word command they got right two minutes ago, and one who recalls it with two keystrokes.

Three everyday habits separate a fluent shell user from someone still fighting the terminal. First, pulling exact lines out of a wall of log text with a signal pattern, instead of scrolling and squinting. Second, recalling and reusing orders from the bridge's order log, instead of retyping them. Third, turning repeated typing into short nicknames for orders that never surprise anyone later. None of these are exotic. You use them all the time, under time pressure, on the exam and on every real incident call after it.

**Exam topics covered:** analysing text with regular expressions, and using the shell efficiently

---

## What You Will Master

- Regular expressions as signal patterns: anchors (`^`, `$`), wildcards (`.`, `.*`), escaping a real dot (`\.`), and basic versus extended expressions (`-E`).
- Pulling out lines that meet two independent conditions by chaining two `grep` commands with a pipe.
- Replacing whole lines with `sed`, previewing first, then writing with `sed -i`, and avoiding the redirect-into-the-source trap.
- Recalling commands with `!!`, `!n`, `!string` and the reverse search, `Ctrl+R`.
- Controlling history with `HISTSIZE`, `HISTFILESIZE`, `HISTCONTROL` and `HISTTIMEFORMAT`, and making it last in `~/.bashrc`.
- Why two open terminals do not share history live, and the `history -a`, `-c`, `-r` and `-w` options.
- Where aliases sit in `bash`'s lookup order, checking a name with `type`, and making aliases permanent.
- When a shell function is the right tool instead of an alias.
- Running the real command once with `\rm`, and why aliases never reach scripts or scheduled jobs.

---

## Modules In This Section

Work through the modules in this order. Each part teaches one idea. A mission (a graded lab) comes right after the part it practises, and the last page of each module is a wrap-up. The capstone at the end uses everything in the section at once.

### [Text Processing: Targeted Extraction with grep and Redaction with sed](module-01/course.md)

2 parts and 1 mission:

1. [Patterns: Describing A Shape](module-01/course-01-patterns-describing-a-shape.md)
2. [Extract With grep, Redact With sed](module-01/course-02-extract-with-grep-redact-with-sed.md)
   - Mission: [grep & sed Text Processing Lab](../../labs/lab-031/docs/question.md)
3. [Wrap-Up: Mission Debrief](module-01/course-03-wrap-up.md)

### [Shell Command History: Recall, Search, and Control What Gets Remembered](module-02/course.md)

2 parts and 1 mission:

1. [Recall Commands Without Retyping](module-02/course-01-recall-commands-without-retyping.md)
2. [Control What History Remembers](module-02/course-02-control-what-history-remembers.md)
   - Mission: [Shell History Recall Lab](../../labs/lab-032/docs/question.md)
3. [Wrap-Up: Mission Debrief](module-02/course-03-wrap-up.md)

### [Command Aliases: Safe Shortcuts Without Surprising Anyone](module-03/course.md)

2 parts and 1 mission:

1. [How Bash Expands An Alias](module-03/course-01-how-bash-expands-an-alias.md)
2. [Bypass, Scripts, And Safe Aliases](module-03/course-02-bypass-scripts-and-safe-aliases.md)
   - Mission: [Command Aliases Lab](../../labs/lab-033/docs/question.md)
3. [Wrap-Up: Mission Debrief](module-03/course-03-wrap-up.md)

### Knowledge check

Test your reasoning before the capstone: **[Section 030 Knowledge Check: Everyday Shell Craft](./quiz.md)**.

### Capstone

Your final mission for this section: **[Everyday Shell Craft Capstone Lab](../../labs/lab-030/docs/question.md)**. It combines all three modules in one incident handoff: mine and redact a compromised host's logs with `grep` and `sed`, recover a previous responder's exact commands from shell history, and leave safe, working aliases for the next shift.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-030
```
