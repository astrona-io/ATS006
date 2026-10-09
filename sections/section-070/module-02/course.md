# Overriding a Vendor systemd Unit with systemctl edit

Astronaut, most stations on your ship came with their duty card already written. A package installed the service, and the package owns its unit file. Your job is often not to write a duty card, but to change how an existing one behaves, without scribbling on a card that the package will reprint at the next upgrade.

systemd's answer is the **drop-in override**: a sticky note on the duty card that changes one line. The duty officer (systemd) reads the vendor's card and then your note on top. In this module you write that note with `systemctl edit`, make it take effect, prove the merged result, and take it off again.

## Learning objectives

After this module you can:

- Explain why you never edit a vendor unit file under `/usr/lib/systemd/system/`.
- Create a drop-in override with `systemctl edit`, and say where the file lands.
- Choose between a drop-in and `systemctl edit --full`.
- Predict how a drop-in merges for single-value lines (`Restart=`), for `Environment=`, and for `ExecStart=`.
- Clear a vendor `ExecStart=` with an empty `ExecStart=` line before you set a new one.
- Apply an override with `daemon-reload` and `restart`, not `reload`.
- Prove the merged result with `systemctl cat` and `systemctl show`.
- Undo every local change with `systemctl revert`.

## Before you start

Every mission starts with a pre-flight check, astronaut. Make sure you have the knowledge this module expects and a machine to practise on.

### What you should already know

- **What a unit file is.** A unit file is the plain text duty card systemd reads for one service, with sections such as `[Unit]`, `[Service]` and `[Install]`.
- **What `sudo systemctl daemon-reload` does.** It makes systemd read every unit file from disk again. systemd caches unit files, so it ignores changes until you run it.
- **How to use a terminal editor**, for example `nano` or `vim`. `systemctl edit` opens one for you.

### What you need

A terminal on an Ubuntu 24.04 machine with bash, systemd and `sudo`, and at least one service that a package installed and that is already running. A running lab machine works too: start one with `astrona run` and open a terminal on it with `astrona ssh`. Use a test machine, not one that runs anything important.

## How this module is laid out

1. [Write a Drop-In Override](./course-01-write-a-drop-in-override.md): why the vendor file is off limits, where `systemctl edit` writes, and how drop-ins merge, including the `ExecStart=` trap.
2. [Apply, Prove and Revert an Override](./course-02-apply-prove-and-revert-an-override.md): `daemon-reload` and `restart`, `systemctl cat` and `systemctl show`, and `systemctl revert`.
   - Mission: [systemd Unit Override Lab](../../../labs/lab-072/docs/question.md)
3. [Wrap-Up: Mission Debrief](./course-03-wrap-up.md)

## Why this matters

Changing a packaged service safely is a daily administration job, and the exam asks for it. A hand-edit to the vendor file quietly disappears at the next package upgrade. A drop-in applied the wrong way can add a second start command instead of replacing the first, and the service half-works with no clear error. Knowing exactly how the note sits on top of the card keeps your change in place.
