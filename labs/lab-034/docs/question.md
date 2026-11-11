# Question

Solve this question on: `terminal`

Astronaut, mission control wants five small reports. The input files are in `/home/candidate/data`. Create the folder `/home/candidate/report` and write each report into it. Build every report with the shell tools `sort`, `uniq`, `cut`, `tr`, `awk`, `wc` or `diff`, not by typing the answer.

1. `by-hours.txt`: the crew names, one per line, with the most hours first. `crew.csv` has a header line, which must not appear.
2. `visit-counts.txt`: one line per station in `visits.log`, with the number of visits, a space and the station name, with the most visited station first. Extra spaces in front of the number are fine.
3. `engineer-hours.txt`: one line that holds the total hours of all crew whose role is `engineer`. Only the number.
4. `settings.diff`: the unified difference between `settings-old.conf` and `settings-new.conf`, old file first.
5. `roles.txt`: the roles in `crew.csv`, each one once, in capital letters, sorted alphabetically, one per line.

The grader checks the content of each report.
<!-- curriculum-links -->

## Related lessons and assessment

Read [module-04](../../../sections/section-030/module-04/course.md).

The grader checks:

- Checks the five report files against the values that the data files produce.

Use the inspection commands in the solution to check your work. Submit when you have finished; submission ends this environment.
