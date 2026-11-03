# Solution Walkthrough

Use the text filters on a pipe to build five small reports in `/home/candidate/report`. Work through the steps in order, and check the result after each one.

---

## Step 1: Report 1 and 2: sort, cut and count

`tail -n +2` skips the header line. `sort -t, -k4 -nr` sorts by the fourth comma-separated field, as a number, largest first. `cut -d, -f1` keeps the first field. For the counts, `sort` puts equal lines side by side, `uniq -c` counts them, and a second `sort -rn` puts the largest count first.

```sh
mkdir -p /home/candidate/report
cd /home/candidate/data
tail -n +2 crew.csv | sort -t, -k4 -nr | cut -d, -f1 > /home/candidate/report/by-hours.txt
sort visits.log | uniq -c | sort -rn > /home/candidate/report/visit-counts.txt
cat /home/candidate/report/by-hours.txt
cat /home/candidate/report/visit-counts.txt
```

```text
Ana
Dev
Gus
Ivo
Ben
Eli
Hana
Fay
Cleo
Jo
      6 mars
      4 luna
      3 titan
      2 europa
```

---

## Step 2: Report 3 and 5: awk and tr

`awk -F,` splits each line at commas. The condition `$2 == "engineer"` selects the rows, and the action adds field 4 to a running sum that `END` prints. For the roles, `cut` takes field 2, `tail` skips the header, `sort -u` removes duplicates and `tr a-z A-Z` makes capital letters.

```sh
cd /home/candidate/data
awk -F, '$2 == "engineer" { sum += $4 } END { print sum }' crew.csv > /home/candidate/report/engineer-hours.txt
tail -n +2 crew.csv | cut -d, -f2 | sort -u | tr a-z A-Z > /home/candidate/report/roles.txt
cat /home/candidate/report/engineer-hours.txt /home/candidate/report/roles.txt
```

```text
510
COOK
ENGINEER
MEDIC
PILOT
```

---

## Step 3: Report 4: diff

`diff -u` prints a unified difference. The first file you name is the old one.

```sh
cd /home/candidate/data
diff -u settings-old.conf settings-new.conf > /home/candidate/report/settings.diff
cat /home/candidate/report/settings.diff
```

`diff` exits with `1` when the files differ. That is not an error here. The report shows `-speed=low`, `+speed=high`, `-crew_limit=8`, `+crew_limit=10` and `+alarm=on`, with file names and dates in the two header lines.

---

## Step 4: Submit

Leave the lab machine and send the mission for grading:

```bash
astrona submit -c labs/lab-034
```
