# Question

Solve this question on: `terminal`

There is an existing environment variable for your user: `VARIABLE1=random-string`, defined (and exported) in `~/.bashrc`.

Create a new script at `/opt/course/4/script.sh` which:

1. Defines a new variable `VARIABLE2` with content `v2`, available **only inside the script itself**.
2. Outputs the content of `VARIABLE2`.
3. Defines a new variable `VARIABLE3` with content `${VARIABLE1}-extended`, available **inside the script itself and in all child processes it spawns**.
4. Outputs the content of `VARIABLE3`.

Do not alter `~/.bashrc` — everything must be done inside the script itself.
