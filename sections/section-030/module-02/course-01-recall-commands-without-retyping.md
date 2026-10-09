# Recall Commands Without Retyping

Astronaut, the bridge console remembers every order you type. That memory is the shell's **history**: the bridge's order log. In this part you learn the fastest ways to pull an earlier order back out of the log, run it again, or edit it first.

`bash`, the shell, keeps this log for each interactive session. You see it with the `history` command, which prints each entry with a number in front of it.

## Fast recall with history expansion

`bash` gives you three closely related shortcuts to run something you already typed. Together they are called **history expansion**: `bash` swaps the shortcut for the old command before it runs anything. This section shows the three forms and their one real risk.

### The three shortcuts

- `!!` runs the most recent command again.
- `!n` runs the command with history number `n`.
- `!string` runs the most recent command that *started with* `string`.

```bash
sudo systemctl restart nginx
!!                              # re-runs "sudo systemctl restart nginx"
history | tail -5               # look up a specific number, for example 482
!482                            # re-runs whatever command was numbered 482
!sudo                           # re-runs the most recent command starting with "sudo"
```

The numbers on your machine are different from `482`. Always read them from your own `history` output.

### Try it at your console

Run three or four different commands, for example `date`, `whoami` and `uname -r`. Then run the last one again with `!!`:

```sh
!!
```

`bash` first prints the command it expanded to, then runs it. Now look up the numbers:

```sh
history | tail -5
```

Pick the number in front of an earlier command from your batch and run it with `!` followed by that number. `bash` runs exactly that entry again.

### Look before it runs

These shortcuts are fast, but they run immediately. If you are not certain `!482` is the command you think it is, put it on the prompt for editing instead of running it. In many `bash` setups you can press `→` (the right arrow) or `Esc` right after typing a history-expansion shortcut to expand it onto the line without running it, so you can check or edit it first.

## Reverse incremental search: Ctrl+R

The fastest general way to recall a command needs neither a number nor the exact start of the command. This section shows how the reverse search works and how to use what it finds.

### How the search works

Press `Ctrl+R` to start a **reverse incremental search**. Type any piece of text that appeared *anywhere* in a past command. `bash` jumps straight to the most recent match and updates it live as you keep typing.

- Press `Ctrl+R` again to walk further back through older matches.
- Press `Enter` to run the found command as it is.
- Press `Esc` or an arrow key to drop back to the prompt with the command filled in, ready to edit.

While you search, the prompt looks like this:

```
(reverse-i-search)`ssh': ssh admin@10.20.30.42
```

The text between the quotes is what you typed so far. After the colon is the most recent command that contains it.

### Try a search from the middle

Pick a command you ran several steps ago. Press `Ctrl+R` and type only a piece from the *middle* of it, not the start. Press `Ctrl+R` again until `bash` shows the entry you want, then press `Esc` to edit it before you run it.

> [!TIP]
> Make `Ctrl+R` a habit, not a last resort. It beats scrolling or guessing a history number almost every time, and it finds a command from any word you remember in it.

## Common pitfalls

> [!WARNING]
> - **Running `!n` blind.** History expansion runs at once. If you are not sure what number `n` holds, check `history` first or expand it onto the line before you press `Enter`.
> - **Trusting another machine's numbers.** History numbers are different on every machine and in every session. Read them from your own `history` output.
> - **Expecting `!string` to search the middle.** `!sudo` only matches commands that *start* with `sudo`. To search anywhere in a command, use `Ctrl+R`.
> - **Retyping a long command from memory.** One wrong option and the command does something else. Recall it instead.
