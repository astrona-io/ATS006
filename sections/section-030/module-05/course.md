# Finding Help And Editing Files

Astronaut, nobody remembers every option. The exam lets you use the manual pages on the machine, so reading them fast is a skill. You also need to change a file with an editor when no script is available. This module shows both.

## Learning objectives

After this module you can:

- Read a manual page with `man`, name its section, and search with `/` inside it.
- Find a command by topic with `man -k` or `apropos`, and read short help with `--help` and `info`.
- Open, change, save and quit a file in `vim`, and use search and replace.
- Do the same job in `nano`.

## Before you start

### What you should already know

- **Paths and files** from the earlier modules.

### What you need

A playground: one Ubuntu 24.04 training ship with the manual pages, `vim` and `nano` installed.

### What is in your playground

Your playground is a virtual machine on your computer. It already has:

- The manual pages (`man-db`, `manpages`), `vim` and `nano`.
- `~/flightplan.conf`, six lines, three of which hold the word `PLACEHOLDER`.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->

Open a terminal on it:

```sh
astrona ssh docs-editor-playground
```

## How this module is laid out

1. [Manual Pages And Help](./course-01-manual-pages-and-help.md): `man`, sections, `man -k`, `--help` and `info`.
2. [Editing With Vim And Nano](./course-02-editing-with-vim-and-nano.md): modes, saving, search and replace.
   - Mission: [Manual Pages and Editing a File Lab](../../../labs/lab-035/docs/question.md)
3. [Summary](./course-03-summary.md)

## Why this matters

On a rescue console there is no browser and often only `vi`. An administrator who can find the right option in a manual page and fix a config file with an editor is never stuck.

<!-- curriculum-practice -->
## Practice and assessment

- [Manual Pages and Editing a File Lab](../../../labs/lab-035/docs/question.md): Edit a configuration file with an editor and keep every other line unchanged; Find a manual page section and a command option with the manual pages.
- [Everyday Shell Craft Capstone Lab](../../../labs/lab-030/docs/question.md): Extract and redact incident log lines with grep and sed, and recover exact commands from shell history; Persist aliases, and build reports with sort, uniq, cut and awk; Edit a file in an editor and look up facts in the manual pages.
