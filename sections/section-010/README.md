# Section 010: Shell Semantics: Redirection, Exit Codes & Environment

Welcome to Section 010. Before you can diagnose a service, chase down a failing cron job, or debug why a script "just doesn't work on the other server," you need to be fluent in the plumbing every single command in this course sits on top of: where a program's output actually goes, how it reports success or failure, and which variables a child process can and cannot see.

None of this is optional background reading. It is the mechanism underneath every command you will run for the rest of this training. Get stdout and stderr redirection backwards, and you'll silently capture the wrong stream in a log file — invisible until something depends on the missing output. Confuse a shell-local variable with an exported one, and a script will mysteriously fail to see a value that "is clearly set" in your terminal. Both mistakes are common, both are entirely avoidable once the underlying model clicks, and both are exam-favorite traps.

---

## What You Will Master

By completing this section, you will acquire two foundational shell-diagnostics capabilities:
*   **Stream & Exit Code Discipline:** How to independently redirect stdout and stderr with `>`, `2>`, `2>&1`, and `&>`, why redirection order matters, and how to reliably capture a command's numeric exit status via `$?` before it gets overwritten.
*   **Environment Scope Control:** The difference between a plain shell variable and a true environment variable, what `export` actually does at the process level, and how to reason about what a child process will and will not inherit.

---

## The Learning & Lab Path

This section is divided into two modules, each paired with a hands-on practice lab:

### 1. Shell Redirection, stdout/stderr, and Exit Codes
*   **Module Reader:** **[Module 1: Shell Redirection, stdout/stderr, and Exit Codes](./module-01/course.md)**
*   **Associated Lab:** **[lab-011](../../labs/lab-011)**
*   **Lab Run Command:**
    ```bash
    astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-011
    ```
*   **Hands-on Objective:** Run the same fixed-output program four different ways, isolating stdout, isolating stderr, combining both correctly, and capturing the numeric exit status into separate files.

### 2. Environment Variables and Scope
*   **Module Reader:** **[Module 2: Environment Variables and Scope](./module-02/course.md)**
*   **Associated Lab:** **[lab-012](../../labs/lab-012)**
*   **Lab Run Command:**
    ```bash
    astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-012
    ```
*   **Hands-on Objective:** Write a script that defines a shell-local variable and an exported variable side by side, without ever touching an existing `.bashrc` entry, and prove the difference between what a child process can and cannot see.

---

## Ready for Assessment?

Test your theoretical knowledge and diagnostic reasoning before tackling the capstone lab mission:

*   **[Take the Section 010 Knowledge Check Quiz](./quiz.md)**
