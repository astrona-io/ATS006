# Question

Solve this question on: `terminal`

Astronaut, mission control wants a standard procedure that counts the lines of every text file in a folder. Write it as a script and save it as `/home/candidate/scripts/count-lines.sh`. Make it executable.

1. When the script gets **no argument**, it prints `usage: count-lines.sh <directory>` on **stderr** and exits with code `2`.
2. When the argument is **not a directory**, it prints `not a directory: <argument>` on **stderr** and exits with code `1`.
3. Otherwise it loops over every file in that directory whose name ends in `.txt`, in the order the shell lists them. For each one it prints `<file name>: <N> lines` on **stdout**, where `<file name>` is the name without the folder and `<N>` is the number of lines. Then it prints a last line `total: <N> lines` with the sum, and exits with code `0`.
4. File names can hold spaces. A folder with no `.txt` file prints only `total: 0 lines`.

The folder `/home/candidate/inbox` holds files to try it on. The grader runs your script on that folder and on other folders it builds itself.
