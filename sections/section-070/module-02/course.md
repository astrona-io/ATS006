# Overriding a Vendor systemd Unit with systemctl edit

Module 1 covered writing a unit file from a blank page. This module covers the far more common situation in day-to-day administration: the unit file already exists, shipped and owned by a package, and you need to change how it behaves.

Say a package installs `cups.service` and you need it to restart automatically if the print daemon crashes — something the stock unit doesn't do. The tempting move is to open `/usr/lib/systemd/system/cups.service` in an editor and add the line. Don't. That file is tracked by the package manager. The next time that package is upgraded, the package's own copy of the unit either silently overwrites your hand-edit, or the package manager raises a "modified config file" conflict that an unattended upgrade will typically resolve by keeping the *package's* version anyway. Either way, your change doesn't survive. Think of the vendor unit file the way you'd think of a rental apartment's walls: you don't get to repaint them, because the landlord (the package manager) redecorates on their own schedule and won't remember what you did.

systemd's answer is a **drop-in override**: a small, separate file that layers additional directives on top of the vendor unit without ever touching it.

## `systemctl edit`: Where the Override Actually Lives

```bash
sudo systemctl edit cups.service
```

This opens your `$EDITOR` on a file that gets created if it doesn't already exist — conventionally at `/etc/systemd/system/cups.service.d/override.conf`. Note carefully what that path is *not*: it isn't a copy of the vendor unit, and it isn't under `/usr/lib/systemd/system/` at all. It's a fragment that systemd will layer on top of whatever it loads from the package location.

Adding this to the drop-in:

```ini
[Service]
Restart=on-failure
RestartSec=5
```

...is enough. You never touch `/usr/lib/systemd/system/cups.service`. The next package upgrade can freely replace that file, and your override survives untouched in `/etc/systemd/system/`, since package managers only own files they installed there — not files an admin created separately under `/etc`.

There is a second, different tool for a different job: `systemctl edit --full cups.service`. This opens a complete, standalone local copy of the entire unit, saved to `/etc/systemd/system/cups.service`, which *fully shadows* — entirely replaces, not layers on top of — the vendor version. Reach for `--full` only when you genuinely need to rewrite most of the unit; for a one- or two-directive tweak, a plain drop-in is almost always the better tool, because it stays a small diff instead of a whole file you now have to keep manually in sync with future vendor changes.

## How Merging Actually Works

For most directives, a drop-in value simply gets appended after the vendor unit's own directives, and for a single-value setting, the *last* value loaded wins — your drop-in's value overrides the vendor's, cleanly. `Restart=` and `RestartSec=` both behave this way; setting them in the override is sufficient on its own.

`Environment=` is a special case worth knowing by name: it's explicitly additive. Multiple `Environment=` lines — whether from the same file or layered across the vendor unit and one or more drop-ins — all contribute variables rather than the last one winning. Add `Environment=APP_ENV=production` to a drop-in and it simply joins whatever the vendor unit already set, with no clearing needed.

### The `ExecStart=` Gotcha

Not every directive behaves like `Restart=`. `ExecStart=` (and a handful of other list-like, multi-value directives) is documented to **append** to an internal list rather than replace a prior value outright. Naively adding a second `ExecStart=` in a drop-in doesn't swap out the vendor's command — it tries to accumulate both, with systemd's actual runtime behavior for the resulting list depending on the directive. The unit will often still start, using whichever command systemd picks under those multi-value semantics — just not the one you meant, and with no obvious error to point you at why.

The documented fix is a bare, empty directive first:

```ini
[Service]
ExecStart=
ExecStart=/usr/sbin/cupsd -f -c /etc/cups/custom-cupsd.conf
```

An `ExecStart=` with nothing after the `=` is special-cased by systemd to mean "discard every `ExecStart=` value accumulated so far, including the vendor unit's" — only once that reset happens does the following line become the sole, actual start command. This single quirk — the empty line that clears the list — trips up nearly everyone exactly once. It's worth memorizing precisely because it's non-obvious and because the failure mode (it half-works, using the wrong command) doesn't look like an error at first glance.

## Reload, Restart, and Confirm

A drop-in file being saved to disk doesn't do anything on its own — systemd needs to notice it exists, and the running process needs to actually be relaunched under the new configuration:

```bash
sudo systemctl daemon-reload
sudo systemctl restart cups
```

Note `restart`, not `reload`. `reload` (where a unit supports it) typically sends a signal asking the *application itself* to re-read its own config — it does nothing about `Restart=` or `Environment=`, which are properties systemd itself enforces about how the process is supervised and launched in the first place. Only a full restart re-launches the process under the merged configuration.

To see exactly what's now in effect — the vendor unit's content plus every drop-in fragment, in load order, precisely as systemd itself sees it — use:

```bash
systemctl cat cups
```

This is the authoritative check. Don't try to mentally combine two files in your head; `systemctl cat` shows you systemd's actual merged result, fragment by fragment, with a comment line above each one naming its source file. Cross-check the live, running configuration with:

```bash
systemctl show cups -p Restart -p RestartUSec -p Environment
```

`systemctl show` reports the properties systemd is actually enforcing right now, which is a useful second confirmation independent of the static file view `cat` gives you.

## Undoing It Cleanly

```bash
sudo systemctl revert cups
```

`revert` removes any local drop-in directory (`/etc/systemd/system/cups.service.d/`) and any full local replacement unit (the `--full` case) for the named service, restoring exactly the vendor-shipped configuration — no manual `rm` required, and no risk of deleting the wrong file by hand. Follow it with the same `daemon-reload` and `restart` pattern to make the reversion take effect at runtime, not just on disk.

## Self-Check and Verification

To prove you understand safe vendor-unit overrides:

1. Pick any package-installed service on a test machine (anything already running is fine) and run `systemctl cat <unit>` to see its current, unmodified configuration.
2. Note the `FragmentPath` via `systemctl show <unit> -p FragmentPath` — confirm it points under `/usr/lib/systemd/system/` or `/lib/systemd/system/`, the package-owned location you will not touch.
3. Run `sudo systemctl edit <unit>` and add a directive the vendor unit doesn't already set (e.g., `Restart=on-failure`).
4. Run `sudo systemctl daemon-reload` and `sudo systemctl restart <unit>`, then confirm the change with `systemctl show <unit> -p Restart`.
5. Run `systemctl cat <unit>` again and confirm it now shows two fragments: the original vendor file, followed by your `override.conf`.
6. Run `sudo systemctl revert <unit>`, reload, and restart again — confirm `systemctl cat <unit>` shows only the original vendor fragment, with no override listed underneath.
