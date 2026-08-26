# Section 030: Everyday Shell Craft: Text Processing, History & Aliases

Welcome to Section 030. The commands you've learned so far let you move around the filesystem and inspect the system. This section is about working *faster and more precisely* inside the shell you already have — the difference between a sysadmin who re-types a fifteen-word command they got right two minutes ago, and one who recalls it with two keystrokes.

Three everyday habits separate a fluent shell user from someone still fighting the terminal: surgically pulling exact lines out of a wall of log text instead of scrolling and squinting, recalling and reusing commands you've already run instead of retyping them, and compressing repetitive typing into short, predictable shortcuts that never surprise you later. None of these are exotic — they are used constantly, under time pressure, on the LFCS exam and on every real incident call that follows it.

---

## What You Will Master

By completing this section, you will acquire three core shell-fluency capabilities:
*   **Targeted Log Extraction & Redaction:** How to pull lines matching multiple simultaneous conditions out of a log file with `grep`, and how to rewrite lines matching a shape — starts with X, ends with Y, contains Z in between — with `sed`, safely and precisely.
*   **Command Recall & History Control:** How to re-run and search past commands instantly with `!!`, `!n`, and `Ctrl+R`, and how to configure exactly what your shell remembers, for how long, and in what format.
*   **Safe, Predictable Aliases:** How to build persistent shortcuts that save keystrokes without silently changing how a familiar command behaves out from under you — or anyone else who inherits your shell.

---

## The Learning & Lab Path

This section is divided into three modules, each paired with a hands-on practice lab:

### 1. Text Processing: Targeted Extraction with grep and Redaction with sed
*   **Module Reader:** **[Module 1: Text Processing: Targeted Extraction with grep and Redaction with sed](./module-01/course.md)**
*   **Associated Lab:** **[lab-031](../../labs/lab-031)**
*   **Lab Run Command:**
    ```bash
    astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-031
    ```
*   **Hands-on Objective:** Extract every log line satisfying two independent conditions at once into a new file, and redact every line matching a start/contains/end shape with a whole-line `sed` substitution — without disturbing anything else in either file.

### 2. Shell Command History: Recall, Search, and Control What Gets Remembered
*   **Module Reader:** **[Module 2: Shell Command History: Recall, Search, and Control What Gets Remembered](./module-02/course.md)**
*   **Associated Lab:** **[lab-032](../../labs/lab-032)**
*   **Lab Run Command:**
    ```bash
    astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-032
    ```
*   **Hands-on Objective:** Persist `HISTSIZE`, `HISTFILESIZE`, `HISTCONTROL`, and `HISTTIMEFORMAT` behavior for future sessions, then reconstruct a specific prior command sequence by searching an existing shell history.

### 3. Command Aliases: Safe Shortcuts Without Surprising Anyone
*   **Module Reader:** **[Module 3: Command Aliases: Safe Shortcuts Without Surprising Anyone](./module-03/course.md)**
*   **Associated Lab:** **[lab-033](../../labs/lab-033)**
*   **Lab Run Command:**
    ```bash
    astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-033
    ```
*   **Hands-on Objective:** Persist a long-listing shortcut, a confirm-before-delete safety alias, and a single-purpose IP-printing alias, then prove each resolves correctly and bypass the safety alias for exactly one invocation without weakening it.

---

## Capstone: Everyday Shell Craft Capstone Lab

Once all three modules are complete, **[lab-030](../../labs/lab-030)** combines them into a single incident-handoff scenario: mine and redact a compromised host's logs with `grep`/`sed`, reconstruct a previous responder's exact command sequence from shell history, and leave behind a set of safe, working aliases for the next engineer.

```bash
astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-030
```

---

## Ready for Assessment?

Test your theoretical knowledge and diagnostic reasoning before tackling the section's capstone lab mission:

*   **[Take the Section 030 Knowledge Check Quiz](./quiz.md)**
