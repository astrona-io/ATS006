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

A playground: one Ubuntu 24.04 training ship in the simulator, with the `bash` shell. Everything the examples use is already on it, so you do not need to install anything.

### What is in your playground

Your playground is a virtual machine on your computer. It already has:

- `nginx` installed and running, with its packaged unit file `nginx.service`.
- No override yet.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->

Open a terminal on it:

```sh
astrona ssh unit-override-playground
```

Every command block in the parts runs **inside that virtual machine**, as the user `candidate`, who can use `sudo`.

## How this module is laid out

1. [Write a Drop-In Override](./course-01-write-a-drop-in-override.md): why the vendor file is off limits, where `systemctl edit` writes, and how drop-ins merge, including the `ExecStart=` trap.
2. [Apply, Prove and Revert an Override](./course-02-apply-prove-and-revert-an-override.md): `daemon-reload` and `restart`, `systemctl cat` and `systemctl show`, and `systemctl revert`.
   - Mission: [systemd Unit Override Lab](../../../labs/lab-072/docs/question.md)
3. [Wrap-Up: Mission Debrief](./course-03-wrap-up.md)

## Why this matters

Changing a packaged service safely is a daily administration job, and the exam asks for it. A hand-edit to the vendor file quietly disappears at the next package upgrade. A drop-in applied the wrong way can add a second start command instead of replacing the first, and the service half-works with no clear error. Knowing exactly how the note sits on top of the card keeps your change in place.

<!-- curriculum-practice -->
## Practice and assessment

- [systemd Unit Override Lab](../../../labs/lab-072/docs/question.md): Change a packaged service's restart policy and environment with a drop-in override; Prove the merged configuration with systemctl show while the vendor unit file stays unchanged.
- [Service Configuration Capstone Lab](../../../labs/lab-070/docs/question.md): Wrap a script as a systemd service that runs as its own non-root user; Change the restart delay with a drop-in override, not by editing the unit file; Issue a key and a self-signed certificate with a SAN and prove they match.
