# Translate, Awk, Diff And Tee

Astronaut, this part adds four more tools: `tr` swaps characters, `awk` works on fields, `diff` shows what changed, and `tee` keeps a copy of a stream.

## Translate characters

`tr` reads standard input and replaces or deletes single characters. It does not take a file name, so feed it with `<` or a pipe:

<!-- astrona:playground:renew -->

```sh
cd ~/data
echo "mars base" | tr 'a-z' 'A-Z'
echo "a,b,c" | tr ',' ' '
echo "a  b" | tr -s ' '
echo "abc123" | tr -d '0-9'
```

The outputs are `MARS BASE`, `a b c`, `a b` and `abc`. `-s` squeezes repeated characters to one, and `-d` deletes them.

## Awk

`awk` reads a line, splits it into fields `$1`, `$2`, ... and runs an action. `-F,` sets a comma as separator:

```sh
awk -F, 'NR>1 {print $1, $4}' crew.csv
awk -F, 'NR>1 {sum += $4} END {print sum}' crew.csv
awk -F, '$4 > 100 {print $1}' crew.csv
```

The first prints name and hours for every row but the header (`NR` is the line number). The second adds the fourth column and prints the sum when the input ends. The third prints names of crew with more than 100 hours. The part before `{` is a condition and the part inside is the action.

## Diff

`diff` compares two files. `-u` prints the unified format that patches and reviews use:

```sh
diff -u settings-old.conf settings-new.conf
```

Lines that start with `-` exist only in the first file, lines with `+` only in the second, and lines with a space are shared context. `diff` ends with code `0` when the files are the same and `1` when they differ, so a script can test it. `diff -q` only reports whether they differ.

## Tee

`tee` copies its input to a file and to the screen, so a pipeline can be saved and continued:

```sh
sort visits.log | uniq -c | sort -rn | tee /tmp/ranking.txt | head -n 3
cat /tmp/ranking.txt | wc -l
```

The first line prints the top three and also writes the whole ranking to the file. Use `tee -a` to append. With `sudo tee FILE` you can write a root-owned file from a pipe, because `sudo cmd > FILE` opens the file as you.

## Common pitfalls

> [!WARNING]
> - **Giving `tr` a file name.** It reads only stdin. Use `tr ... < FILE`.
> - **Quote the awk program.** Without single quotes the shell eats `$1`.
> - **Swapping the diff arguments.** The order decides which side gets `-` and which gets `+`.
> - **Forgetting that `tee` overwrites.** Add `-a` to keep the old content.

## Your mission: Sort, Count, Cut and Compare Text Lab

You can now rank, cut, translate, sum and compare text. The mission hands you raw crew and visit data and asks for five reports, each made with the filters from this module.

Pause your playground first. Nothing in it is lost:

```sh
astrona stop text-filters-playground
```

Then start the mission:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-034
```

Open a terminal on the mission ship:

```sh
astrona ssh ats-006-lab-034
```

Read the task in [the question](../../../labs/lab-034/docs/question.md) and solve it on your own first. When you think you are done, send it for grading from your own computer:

```sh
astrona submit -c labs/lab-034
```

When the mission is done, remove it and wake your playground up again:

```sh
astrona destroy ats-006-lab-034
astrona start text-filters-playground
```
