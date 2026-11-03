# Editing With Vim And Nano

Astronaut, sometimes the fix is one line in one file. This part shows the two editors you will find on a ship: `vim`, which is nearly everywhere, and `nano`, which is easier to start with.

## Vim has modes

`vim` does different things in different modes. You start in **normal mode**, where keys are commands. Press `i` to enter **insert mode** and type text, and press `Esc` to go back:

<!-- astrona:playground:renew -->

```sh
cp ~/flightplan.conf ~/practice.conf
vim ~/practice.conf
```

The keys you need:

| Keys | Does |
| --- | --- |
| `i` | insert before the cursor |
| `Esc` | back to normal mode |
| `dd` | delete the current line |
| `yy` then `p` | copy a line and paste it below |
| `u` | undo |
| `/word` then `n` | search forward and repeat |
| `:w` | save |
| `:q` | quit |
| `:wq` | save and quit |
| `:q!` | quit and throw away changes |

### Search and replace

In normal mode, type a command that starts with a colon:

```
:%s/PLACEHOLDER/TBD/g
```

`%` means every line, `s` is substitute and `g` replaces every match in a line, not only the first. Press Enter, then type `:wq`. Check the result outside the editor:

```sh
grep -c TBD ~/practice.conf
```

The output is `3`, since the file held three lines with the word.

## Nano

`nano` has no modes. You type, and the shortcuts are listed at the bottom of the screen. `^` means the `Ctrl` key:

```sh
nano ~/practice.conf
```

Use `Ctrl+O` then Enter to save, `Ctrl+W` to search, and `Ctrl+X` to quit. `nano` asks whether to save if you changed the file.

## Common pitfalls

> [!WARNING]
> - **Typing in normal mode.** Keys act as commands. Press `i` first.
> - **Stuck in vim.** Press `Esc`, then `:q!` to leave without saving.
> - **Editing a root-owned file as yourself.** Use `sudoedit FILE` or `sudo vim FILE`.
> - **No `g` on the replace.** Only the first match on each line changes.

## Your mission: Manual Pages and Editing a File Lab

You can now find help and edit a file by hand. The mission asks you to change a flight plan with an editor and to answer two questions by reading the manual pages.

Pause your playground first. Nothing in it is lost:

```sh
astrona stop docs-editor-playground
```

Then start the mission:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-035
```

Open a terminal on the mission ship:

```sh
astrona ssh ats-006-lab-035
```

Read the task in [the question](../../../labs/lab-035/docs/question.md) and solve it on your own first. When you think you are done, send it for grading from your own computer:

```sh
astrona submit -c labs/lab-035
```

When the mission is done, remove it and wake your playground up again:

```sh
astrona destroy ats-006-lab-035
astrona start docs-editor-playground
```
