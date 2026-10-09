# Question

Solve this question on: `terminal`

Astronaut, a supply archive has docked at this training ship. It is vacuum-packed with `bzip2`, and mission control needs it repacked with `gzip`, as tightly as possible, with proof that no crate went missing.

There is an archive `/imports/import001.tar.bz2` on the machine. Create a new gzip-compressed archive with its raw contents:

1. Store the new archive at `/imports/import001.tar.gz`.
2. Use the best possible gzip compression (level 9).
3. To make sure both archives contain the same files, write a sorted list of the contents of each archive into `/imports/import001.tar.bz2_list` and `/imports/import001.tar.gz_list`.
4. Do not modify or delete the original archive `/imports/import001.tar.bz2`.
