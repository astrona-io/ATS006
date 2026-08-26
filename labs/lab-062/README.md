# lab-062: rsync Mirroring & Snapshots Lab

Two QEMU VMs for the LFCS course — `data-001` (rsync source) and `data-002` (rsync destination), joined on a private `10.10.60.0/24` network, mirroring and snapshotting `/srv/appdata`.

## Access

`data-001`'s `sshAccess: [data-002]` config wires key-based SSH trust to `data-002` automatically — `ssh data-002` / `rsync -e ssh ... data-002:/backup/appdata/` from `data-001` just work, no password needed.

## Run

```bash
astrona run --git git@github.com:astrona-io/ATS006.git -c labs/lab-062
```
