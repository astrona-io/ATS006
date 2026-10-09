# Question

Solve this question on: `terminal`

Astronaut, your user's briefing pack already holds one exported variable: `VARIABLE1=random-string`, set with `export` in `~/.bashrc`. Mission control wants a script that keeps one value on its own console and hands another one on to every crew member it starts.

Create a new script at `/opt/course/4/script.sh`, and make it executable. The script must:

1. Define a new variable `VARIABLE2` with the content `v2`, available **only inside the script itself**. Do not export it.
2. Output the content of `VARIABLE2`.
3. Define a new variable `VARIABLE3` with the content `${VARIABLE1}-extended`, available **inside the script itself and in all child processes it starts**. Export it on the line that defines it, with `export VARIABLE3=...`.
4. Output the content of `VARIABLE3`.

The script must print exactly these two values, one per line, and nothing else. Do not change `~/.bashrc`: everything happens inside the script.
