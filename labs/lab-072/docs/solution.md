# Solution Walkthrough

You change `nginx.service` with a drop-in override, a small file systemd lays on top of the vendor unit, instead of editing the file the package owns. The grader checks that the vendor file is unchanged, that a drop-in exists, that the effective values are in force, and that `nginx` is running.

## Step 1: Look at the current, unmodified unit

Show the unit as systemd loads it today, and where it comes from:

```sh
systemctl cat nginx
systemctl show nginx -p Restart -p FragmentPath
```

`FragmentPath` shows that the base unit is loaded from the package-owned location, `/usr/lib/systemd/system/nginx.service`. That is the file you will not touch.

## Step 2: Write the drop-in override

Open a drop-in:

```sh
sudo systemctl edit nginx.service
```

Type this into the editor, then save and close it:

```ini
[Service]
Restart=on-failure
RestartSec=5
Environment=APP_ENV=production
```

`systemctl edit` saves it as `/etc/systemd/system/nginx.service.d/override.conf`. `Restart=` and `RestartSec=` hold one value each, so the drop-in's value wins. `Environment=` adds up, so your variable simply joins any the vendor unit sets. No clearing line is needed here. That would only be needed for `ExecStart=`, which collects a list: replacing it takes an empty `ExecStart=` line first. This lab does not change `ExecStart=`.

## Step 3: Reload and restart

Apply it:

```sh
sudo systemctl daemon-reload
sudo systemctl restart nginx
```

`daemon-reload` makes systemd read the new drop-in. `Restart=` and `Environment=` are properties systemd enforces when it launches and watches the process, so a full `restart` is required; `reload` would not apply them.

## Step 4: Check the merged result

Then check the result:

```sh
systemctl cat nginx
systemctl show nginx -p Restart -p RestartUSec -p Environment
systemctl is-active nginx
```

`systemctl cat` shows the vendor fragment followed by your `override.conf` fragment, in that order. `systemctl show` should report `Restart=on-failure`, and the `Environment=` line should contain `APP_ENV=production`. `systemctl is-active` should print `active`.

## Step 5: Confirm the vendor file is untouched

Look at the vendor file itself:

```sh
sudo cat /usr/lib/systemd/system/nginx.service | grep -i restart
```

Your `Restart=on-failure` and `RestartSec=5` lines are not in this file: they live only in the drop-in. The bootstrap recorded a checksum of this file, and the grader checks it is unchanged.

## Step 6: Submit

When every check looks right, send the lab for grading from your own machine:

```sh
astrona submit -c labs/lab-072
```
