# Manual Pages And Help

Astronaut, the ship's manual is stored on the ship. This part shows how to find the right page and how to read it quickly.

## Reading a page

`man NAME` opens the manual page of a command. It opens in a pager, so use the keys `Space` for the next screen, `b` for the previous one, `/word` then `n` to search forward, and `q` to quit:

<!-- astrona:playground:renew -->

```sh
man ls
```

Inside the page, type `/sort` and press Enter to jump to the first mention of sorting.

### Sections

Pages are grouped in numbered sections, and a name can exist in more than one:

| Section | Holds |
| --- | --- |
| 1 | user commands |
| 5 | file formats and configuration files |
| 8 | administration commands |

`passwd` is both a command (section 1) and a file format (section 5). `man passwd` shows the first match, so ask for the other one with the number:

```sh
man 5 passwd
```

The top line of the page shows the name and section, such as `PASSWD(5)`.

## Finding a page by topic

When you do not know the command name, search the one-line descriptions:

```sh
man -k password
apropos password
```

Both print lines such as `passwd (1) - change user password`. `apropos` is the same as `man -k`. Pick the entry and open it with `man 1 passwd`.

## Shorter help

Many commands print a short summary with `--help`:

```sh
ls --help | head -n 20
```

`info ls` opens a longer, linked manual for GNU tools, and `type -a NAME` shows whether a name is a program, a shell built-in or an alias. A built-in such as `cd` has no manual page of its own. Read it with `help cd`.

## Common pitfalls

> [!WARNING]
> - **Reading the wrong section.** `man passwd` is the command. The file format is `man 5 passwd`.
> - **Empty search results.** Update the index with `sudo mandb` if `man -k` finds nothing.
> - **Built-ins have no man page.** Use `help NAME`.
> - **Getting lost in the pager.** Press `q` to quit.
