# Question

Solve this question on: `terminal`

Astronaut, you want a few nicknames for orders at your bridge console, and one of them must make deleting safer. Set up the following aliases persistently for your user, in `~/.bashrc`, so every new interactive shell has them:

1. `ll` for `ls -alF` (long listing, all files, type indicators).
2. A safety alias so that typing `rm` always runs `rm -i` (confirm before delete).
3. `myip`, which prints just this machine's primary IPv4 address, with no other output.

Then, without removing or disabling the `rm` safety alias, use the real, non-interactive `rm` exactly once to delete `~/lab-artifact-to-delete.txt`.

The aliases must only live in interactive shells: a non-interactive shell (such as `bash -c 'type rm'`) must still see the real `rm` program.
