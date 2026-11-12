# Text Processing: Targeted Extraction with grep and Redaction with sed

Astronaut, every ship keeps logs, and no log is ever the size you want. It is either three lines too short to tell you anything, or fifty thousand lines too long to read by eye. This module gives you the two tools that make logs bearable: `grep`, the signal scanner, and `sed`, the redaction officer.

`grep` reads a file and keeps only the lines that fit a pattern. It never changes the file. `sed` reads a file line by line and rewrites the lines that fit a pattern, without you opening an editor. Think of `grep` as a highlighter that shows you where to look, and `sed` as a redaction marker that blacks out exactly the text it is dragged across, and nothing else.

Both tools work the same way underneath. You hand them a *pattern* that describes the shape of the text you care about, and they act on every line that fits that shape.

## Learning objectives

After this module you can:

- Write a regular expression that pins a match to the start or the end of a line with `^` and `$`.
- Use `.` and `.*` to say "anything here", and escape a literal dot as `\.`.
- Choose between basic and extended regular expressions, and switch with `grep -E` or `sed -E`.
- Extract lines that meet two independent conditions by chaining two `grep` commands with a pipe.
- Replace whole lines with `sed 's/PATTERN/REPLACEMENT/'`, preview the change first, then apply it with `sed -i`.
- Avoid the trap of redirecting output into the same file you are reading.

## Before you start

Every mission starts with a pre-flight check, astronaut. Make sure you know the basics below and have a terminal ready.

### What you should already know

- **How to move around and read files at the console.** You can use `cd`, `ls`, `cat` and `wc -l`.
- **What redirection does.** `>` sends a command's output into a file, and creates or empties that file first. A pipe (`|`) is a tube that carries one command's output straight into the next command.

### What you need

A playground: one Ubuntu 24.04 training ship in the simulator, with the `bash` shell. Everything the examples use is already on it, so you do not need to install anything.

### What is in your playground

Your playground is a virtual machine on your computer. It already has:

- The file `~/logs/access.log` with ten made-up web request lines (status codes `200`, `404` and `500`).
- The file `~/logs/app.log` with a few lines that contain a made-up password and an email address.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->

Open a terminal on it:

```sh
astrona ssh grep-sed-playground
```

Every command block in the parts runs **inside that virtual machine**, as the user `candidate`, who can use `sudo`.

## How this module is laid out

1. [Patterns: Describing A Shape](./course-01-patterns-describing-a-shape.md): anchors, wildcards, escaping and the two kinds of regular expression.
2. [Extract With grep, Redact With sed](./course-02-extract-with-grep-redact-with-sed.md): two conditions at once, whole-line replacement, previewing and the redirection trap.
   - Mission: [grep & sed Text Processing Lab](../../../labs/lab-031/docs/question.md)
3. [Wrap-Up: Mission Debrief](./course-03-wrap-up.md)

## Why this matters

Reading logs is a large share of every administrator's working day, and on the exam you get no time to scroll and squint. A precise pattern pulls exactly the lines you need out of a wall of text in one command. A careful `sed` rewrite removes sensitive lines without touching anything else. Both skills come back on every real incident call.

<!-- curriculum-practice -->
## Practice and assessment

- [grep & sed Text Processing Lab](../../../labs/lab-031/docs/question.md): Extract only the log lines that match two conditions at once with grep; Replace whole matching lines in place with sed and leave every other line untouched.
- [Everyday Shell Craft Capstone Lab](../../../labs/lab-030/docs/question.md): Extract and redact incident log lines with grep and sed, and recover exact commands from shell history; Persist aliases, and build reports with sort, uniq, cut and awk; Edit a file in an editor and look up facts in the manual pages.
