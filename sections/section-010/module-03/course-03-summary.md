# Summary

A script is a text file of commands. Its first line `#!/bin/bash` names the interpreter, and `chmod +x` lets you run it with `./name.sh`.

Arguments arrive as `$1`, `$2`, ..., with `$#` for the count and `"$@"` for all of them. Every command leaves an exit code in `$?`: `0` is success and anything else is failure. A script ends with `exit N` and sends its error text to stderr with `>&2`.

`if [[ TEST ]]; then ... fi` makes a decision. `-d`, `-f`, `-e`, `-z` and `-n` test paths and strings, `-eq`, `-lt` and `-gt` compare numbers, and `==` compares text. `for f in *.txt` loops over a glob, `while read -r line` loops over the lines of a file, and `continue` and `break` steer a loop. A function groups lines under a name and uses its own `$1`.

Key facts:

- Quote every variable: `"$f"`, `"$@"`.
- `wc -l < FILE` prints only the number, `wc -l FILE` prints the name too.
- An unmatched glob stays as the literal text, so test with `[[ -f "$f" ]] || continue`.
- Exit code `2` for wrong usage and `1` for a general failure is a common convention.

<!-- astrona:playground:destroy -->
