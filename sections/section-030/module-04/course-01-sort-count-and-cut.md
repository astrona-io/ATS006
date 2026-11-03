# Sort, Count And Cut

Astronaut, this part covers the four filters that shape almost every report: `sort`, `uniq`, `wc` and `cut`.

## Sort

`sort` puts lines in order. By default it compares them as text, from the first character:

<!-- astrona:playground:renew -->

```sh
cd ~/data
sort visits.log | head -n 5
```

### Sort by a column and as numbers

For a table, name the separator with `-t` and the column with `-k`. Add `-n` to compare numbers and `-r` to reverse. The header line would sort in with the data, so remove it with `tail -n +2`:

```sh
tail -n +2 crew.csv | sort -t, -k4 -n -r | head -n 3
```

This prints the three crew members with the most hours. Without `-n`, the value `9` sorts after `10`, because the text `9` is greater than the text `1`.

`sort -u` sorts and drops duplicate lines in one step.

## Uniq and wc

`uniq` removes **neighbouring** repeats, so the input must be sorted first. With `-c` it prefixes each line with a count:

```sh
sort visits.log | uniq -c | sort -rn
```

The busiest station comes first. The pattern `sort | uniq -c | sort -rn` is the standard way to rank values.

`wc` counts: `wc -l` lines, `wc -w` words and `wc -c` bytes. Use `wc -l < FILE` to get only the number:

```sh
wc -l < visits.log
```

The output is `15`.

## Cut

`cut` keeps selected columns. `-d` sets the separator and `-f` picks fields:

```sh
cut -d, -f1,4 crew.csv | head -n 4
```

This prints the name and the hours columns. `cut -c1-3` keeps characters by position instead. `cut` has no way to reorder columns and cannot handle a separator of several spaces. Use `awk` for those.

## Common pitfalls

> [!WARNING]
> - **`uniq` without `sort`.** It only merges lines that sit next to each other.
> - **Sorting numbers as text.** Add `-n`.
> - **The header row.** Remove it with `tail -n +2` before sorting a table.
> - **Wrong separator.** `cut` splits on a tab unless you give `-d,`.
