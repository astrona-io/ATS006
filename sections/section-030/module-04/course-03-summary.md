# Summary

Text filters read lines and write lines, so they chain with pipes. `sort` orders lines, with `-t` and `-k` to pick a column, `-n` for numbers, `-r` to reverse and `-u` to drop repeats. `uniq` merges neighbouring repeats, so sort first, and `uniq -c` counts. `wc -l`, `-w` and `-c` count lines, words and bytes. `cut -d, -f1` keeps columns.

`tr` swaps, squeezes (`-s`) or deletes (`-d`) single characters from stdin. `awk -F,` works on fields, with a condition before `{` and an action inside, and `END` runs after the last line. `diff -u` shows differences, and its exit code is `0` for equal and `1` for different. `tee` writes a stream to a file and passes it on.

Key facts:

- `sort | uniq -c | sort -rn` ranks values.
- `tail -n +2` removes a header row.
- `sort -n` compares numbers, plain `sort` compares text.
- `tr` takes no file name.

<!-- astrona:playground:destroy -->
