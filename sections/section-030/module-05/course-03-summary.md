# Summary

`man NAME` opens a manual page. Inside it, `/word` searches, `n` repeats and `q` quits. Pages live in sections: 1 for commands, 5 for file formats and 8 for administration, so `man 5 passwd` reads the file format. `man -k topic` and `apropos topic` search descriptions, `--help` prints a short summary, `info` opens linked GNU manuals, and `help` covers shell built-ins.

`vim` starts in normal mode. `i` inserts, `Esc` returns, `dd` deletes a line, `u` undoes, `/word` searches, and `:wq` saves and quits while `:q!` quits without saving. `:%s/old/new/g` replaces every match in the file. `nano` has no modes: `Ctrl+O` saves, `Ctrl+W` searches and `Ctrl+X` quits.

Key facts:

- `man 5 passwd` and `man passwd` are different pages.
- `sudo mandb` rebuilds the index behind `man -k`.
- `:q!` is the way out of vim without saving.
- Use `sudoedit` to edit a root-owned file.

<!-- astrona:playground:destroy -->
