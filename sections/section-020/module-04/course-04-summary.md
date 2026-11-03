# Summary

Everyday file work comes down to five orders, two kinds of link and two commands for ownership. Each one has a single option that separates a faithful result from a quiet fault.

`mkdir -p` builds a whole path and stays quiet when it exists. `touch` creates an empty file or moves the time stamp of an existing one. `cp` makes a new file, so it gets a new time and a mode shaped by the `umask`. `cp -p` keeps the mode and the times, `cp -a` is the usual choice for a tree, and a folder needs `-r`. `mv` renames inside one folder and moves between folders, and it replaces an existing name without a question unless you use `-i`. `rm` has no undo, and `rm -r` removes a folder and everything in it.

A file name is a label, and an inode is the manifest card behind it. A hard link is a second label on the same inode. It survives removal of the first name, it cannot point at a folder, and it cannot cross a filesystem. A symbolic link is a small file that holds a path. It can point at a folder and across filesystems, and it dangles when the target goes away. `ln TARGET NAME` makes a hard link, and `ln -s TARGET NAME` makes a symbolic link with a target that is read from the folder of the link.

`ls -l` and `stat -c '%U:%G %n'` show the owner and the group. `chown owner:group` changes both, `chown :group` and `chgrp group` change only the group, and `-R` goes through a whole tree. Only `root` may give a file to another owner.

Key facts:

- `stat -c 'inode=%i links=%h name=%n' FILE` shows the inode number and the link count.
- `readlink LINK` prints the stored path of a symbolic link.
- `cp: -r not specified; omitting directory` means a folder needs `-r`.
- `ls -i` shows the same inode number for every hard link of one file.

<!-- astrona:playground:destroy -->
