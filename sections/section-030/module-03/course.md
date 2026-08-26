# Command Aliases: Safe Shortcuts Without Surprising Anyone

An alias is the simplest kind of shell customization there is: a pure text substitution the shell performs on the words you type, before it even starts looking for a program to run. Type the alias's name, and bash silently swaps in the command it stands for, as if you'd typed the longer version yourself.

That simplicity is exactly what makes aliases both powerful and quietly dangerous. Powerful, because a long, easy-to-typo command becomes three memorable letters. Dangerous, because if you alias a name that already belongs to a real command, you've just changed what that command does for you — permanently, silently, until the day you forget it's aliased and can't figure out why a completely standard command "isn't behaving like the man page says."

## Where Aliases Sit in the Lookup Order

When you type a word at the prompt, bash doesn't go straight to `PATH`. It checks, in order: is this word an alias? Is it a shell function? Is it a builtin? Only then does it search `PATH` for a matching executable file. Aliases are checked *first* — they win over a same-named real command every time, with no warning that a substitution even happened.

```bash
alias ls='ls --color=auto'
```

Type `ls` after this, and you're always running `ls --color=auto`, not plain `ls` — even though you typed the same four letters you always have. This is completely intentional and, for a sensibly chosen alias like this one, harmless. The risk only shows up when the substituted behavior meaningfully diverges from what the name normally means.

### Confirming What a Name Actually Resolves To

Rather than guessing whether unexpected behavior comes from an alias, a function, or the real binary, ask directly:

```bash
type ls
```

`type` reports exactly what a name resolves to — `ls is aliased to 'ls --color=auto'`, or a plain file path if it isn't aliased at all, or `ls is a function` if someone defined a shell function with that name instead. This is the single fastest way to stop guessing and start knowing, and it's worth reaching for the moment a command "isn't behaving like the docs say" — a stray alias, possibly defined months ago and long forgotten, is one of the most common causes.

## Temporary vs. Persistent Aliases

A bare `alias name='command'` typed at the prompt only lasts for the current shell session — it vanishes the moment that shell exits.

```bash
alias gs='git status'
```

To make an alias survive into future sessions, it has to be written into a shell startup file — `~/.bashrc` for a per-user interactive shell, by convention, since there's no separate alias-only configuration file. The pattern is always the same: define it once, append it to the startup file, then `source` that file (or open a new shell) to pick it up immediately:

```bash
echo "alias gs='git status'" >> ~/.bashrc
source ~/.bashrc
```

## Aliases vs. Functions: Where Arguments Go

An alias can only ever *append* arguments to the end of the substituted text — it has no concept of inserting an argument somewhere in the middle.

```bash
alias grep='grep --color=auto'
grep -i error app.log        # becomes: grep --color=auto -i error app.log
```

This works fine because `-i error app.log` tacking onto the end of `grep --color=auto` is exactly what you want. But try to alias something that needs an argument to land in the *middle* of a longer pipeline, and it simply can't be done with `alias` — the substitution model doesn't support it. That's the signal to reach for a shell function instead, which behaves like a real command and can reference its arguments (`$1`, `$2`, ...) anywhere it needs to:

```bash
mkcd() {
  mkdir -p "$1" && cd "$1"
}
```

`mkcd projectname` creates the directory and changes into it — something no alias could express, because `projectname` needs to be used twice, in two different places, not just appended once at the end.

## Bypassing an Alias for One Invocation

Sometimes you need the *real*, unaliased version of a command exactly once, without giving up the alias's protection for everything else. Two ways to do this, both leaving the alias fully intact afterward:

```bash
\rm somefile        # leading backslash disables alias expansion for this word only
/bin/rm somefile    # an absolute path also bypasses alias lookup entirely
```

The backslash trick is the faster of the two, since it doesn't require knowing or typing the binary's full path. Compare this to `unalias rm`, which works but is slower and easy to forget to reverse — leaving `rm` unprotected for the rest of the session by accident.

## Why Aliases Don't Reach Scripts or Cron

Alias expansion is, by design, disabled by default in non-interactive shells — the kind that run a script or a cron job, as opposed to the kind you type into directly.

```bash
bash -c 'type rm'
```

Run this in a shell where `rm` is aliased to `rm -i` in your interactive `~/.bashrc`, and it still reports the real path to the `rm` binary — not the alias — because this `bash -c` invocation is non-interactive, and non-interactive shells don't perform alias expansion by default, regardless of what's defined in your interactive shell's startup file.

This matters even more than it first appears: many distributions' default `~/.bashrc` starts with a guard like `[ -z "$PS1" ] && return`, which causes non-interactive invocations to skip everything below it — including alias definitions — even if a script explicitly sources `~/.bashrc` at the top. So a script that calls `rm` runs the real, unmodified `rm`, full stop, regardless of any safety alias defined for interactive use. If a task genuinely needs a behavior to apply inside scripts or cron jobs, an alias is the wrong tool — reach for a real script on `PATH`, or a function, instead.

## What Makes an Alias "Safe"

A good alias adds behavior a reasonable person would expect and want by default: `alias cp='cp -i'`, `alias grep='grep --color=auto'`, `alias df='df -h'`. A dangerous alias silently changes a command's blast radius in a way nobody typing that command name would expect — for instance, quietly adding a flag that suppresses confirmation prompts, or one that makes a normally safe command destructive. The entire point of an alias is to save keystrokes on something you'd type the same way every time regardless; it should never be the mechanism by which a command becomes *less* predictable to the next person (including future you) who types it.

## Self-Check and Verification

To confirm you can build and reason about aliases confidently:

1. Define a temporary alias in your current shell for a long command you use often (for example, `alias gs='git status'` or similar), and confirm with `type` that it resolves as an alias, not a file path.
2. Persist that alias into your shell's startup file, open a fresh shell, and confirm it's still active.
3. Alias `cp` to `cp -i` (confirm-before-overwrite), test that it prompts as expected, then use the backslash trick to run the real `cp` exactly once without removing the alias.
4. Run `bash -c 'type cp'` and confirm it reports the real binary path, not the alias — and be able to explain why, in terms of interactive vs. non-interactive shells.
5. Try to write a single alias that inserts an argument in the *middle* of a command rather than the end. Confirm it can't be done, then rewrite the same behavior as a shell function instead.
