# Comparing And Shaping Text

Astronaut, logs and crew lists arrive as raw text. Mission control wants them sorted, counted, trimmed to one column and compared with last week's copy. A handful of small filters does this, and each one reads a line at a time, so you can join them with pipes.

## Learning objectives

After this module you can:

- Sort text by a column and as numbers with `sort -t -k -n -r`, and drop repeats with `sort -u` and `uniq`.
- Count lines, words and repeated values with `wc` and `uniq -c`.
- Cut columns with `cut -d -f`, and translate or delete characters with `tr`.
- Print and sum fields with `awk`.
- Compare two files with `diff -u` and keep a copy of a stream with `tee`.

## Before you start

### What you should already know

- **Pipes and redirection** from the module on shell streams.
- **Searching text** with `grep` and `sed` from the first module of this section.

### What you need

A playground: one Ubuntu 24.04 training ship. Nothing needs to be installed.

### What is in your playground

Your playground is a virtual machine on your computer. It already has:

- `~/data/crew.csv`, a header and eight crew rows with the columns `name,role,deck,hours`.
- `~/data/visits.log`, fifteen lines that each hold one station name.
- `~/data/settings-old.conf` and `~/data/settings-new.conf`, which differ in three lines.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->

Open a terminal on it:

```sh
astrona ssh text-filters-playground
```

## How this module is laid out

1. [Sort, Count And Cut](./course-01-sort-count-and-cut.md): `sort`, `uniq`, `wc` and `cut`.
2. [Translate, Awk, Diff And Tee](./course-02-tr-awk-diff-and-tee.md): `tr`, `awk`, `diff` and `tee`.
   - Mission: [Sort, Count, Cut and Compare Text Lab](../../../labs/lab-034/docs/question.md)
3. [Summary](./course-03-summary.md)

## Why this matters

Most reports on a Linux machine are made by a short pipeline, not by a program. A pipeline that sorts as text when you meant numbers puts `9` after `10`, and one that forgets `sort` before `uniq` counts nothing right. Knowing each filter's one habit saves hours.

<!-- curriculum-practice -->
## Practice and assessment

- [Sort, Count, Cut and Compare Text Lab](../../../labs/lab-034/docs/question.md): Rank values by count with sort and uniq; Sum and select fields with cut and awk; Compare two files and save the difference.
- [Everyday Shell Craft Capstone Lab](../../../labs/lab-030/docs/question.md): Extract and redact incident log lines with grep and sed, and recover exact commands from shell history; Persist aliases, and build reports with sort, uniq, cut and awk; Edit a file in an editor and look up facts in the manual pages.
