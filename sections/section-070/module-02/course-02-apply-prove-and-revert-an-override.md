# Apply, Prove and Revert an Override

Astronaut, a sticky note saved on disk does nothing on its own. The duty officer (systemd) must notice it, and the running crew member, the process, must be started again under the new orders. This part makes a drop-in override take effect, proves the merged result, and then removes it cleanly.

The commands below need a drop-in override saved with `sudo systemctl edit` on a package-installed service. The examples use `cups`, the print service, with a drop-in that sets `Restart=on-failure` and `RestartSec=5`. On your own machine, use the service you chose instead.

## Reload, then restart

Two commands make a drop-in take effect, and the second one must be `restart`, not `reload`. This section shows both and explains why.

### Make systemd read the drop-in and relaunch the service

Run:

```sh
sudo systemctl daemon-reload
sudo systemctl restart cups
```

`daemon-reload` makes systemd notice the new drop-in file. `restart` stops the process and starts it again under the merged configuration.

### Why `restart` and not `reload`

`reload` (where a unit supports it) usually sends a signal that asks the *application itself* to read its own configuration again. It does nothing about `Restart=` or `Environment=`.

Those are properties that systemd itself enforces: how the process is watched and how it is launched. Only a full restart launches the process again under the merged configuration.

## Prove the merged result

Do not try to combine two files in your head. systemd will show you exactly what it is using, in two different ways.

### `systemctl cat`: the files, in order

Show the vendor unit and every drop-in, in the order systemd loads them:

```sh
systemctl cat cups
```

This is the check to trust. `systemctl cat` prints each fragment with a comment line above it that names its source file. After your change it shows two fragments: the vendor file first, then your `override.conf`.

### `systemctl show`: the values in force right now

Cross-check the live, running configuration:

```sh
systemctl show cups -p Restart -p RestartUSec -p Environment
```

`systemctl show` reports the properties systemd is enforcing right now. It is a useful second proof, separate from the file view that `systemctl cat` gives. Look for `Restart=on-failure`.

## Undo it cleanly

When you want the vendor's behaviour back, one command removes your local changes. You never need to delete files by hand.

### Revert, reload and restart

Remove every local override for the service:

```sh
sudo systemctl revert cups
```

`systemctl revert` removes any local drop-in folder (`/etc/systemd/system/cups.service.d/`) and any full local replacement unit (the `--full` case) for the named service. That restores exactly the vendor-shipped configuration, with no risk of deleting the wrong file by hand.

Follow it with the same pair as before, so the change takes effect on the running service and not only on disk:

```sh
sudo systemctl daemon-reload
sudo systemctl restart cups
```

Run `systemctl cat cups` again. It should now show only the original vendor fragment, with no override underneath.

## Common pitfalls

> [!WARNING]
> - **Saving the drop-in and stopping there.** Run `daemon-reload` and then `restart`.
> - **Using `reload` instead of `restart`.** `reload` asks the application to reread its own files; it does not apply `Restart=` or `Environment=`.
> - **Combining files in your head.** Use `systemctl cat` for the merged files and `systemctl show` for the live values.
> - **Deleting override files by hand.** `systemctl revert` removes exactly the local changes and nothing else.
> - **Reverting without restarting.** The running process keeps the old settings until you reload and restart.

## Your mission: systemd Unit Override Lab

You can now change a packaged service with a drop-in, apply it, and prove the merged result. The mission asks you to give a packaged `nginx.service` a restart policy and an extra environment variable, without touching its vendor unit file.

Start the mission:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-072
```

Open a terminal on the lab machine:

```sh
astrona ssh ats-006-lab-072
```

Read the task in the [question](../../../labs/lab-072/docs/question.md) and solve it on your own first. When you think you are done, send it for grading:

```sh
astrona submit -c labs/lab-072
```

When the mission is done, remove it:

```sh
astrona destroy ats-006-lab-072
```
