# Overriding a systemd Unit - Playground

- **Slug:** unit-override-playground
- **Author:** Paris Nakita Kejser
- **Type:** Astrona playground - clean environment, no task, no grading

A single sandbox environment that spins up, runs OS preparation, and stays
running so you can explore the module's topic on a clean machine. Nothing to
submit.

## Run it

```sh
astrona run -c .
astrona destroy unit-override-playground
```

`astrona destroy` takes the environment name (`metadata.name` = `unit-override-playground`), not
the configuration path. `astrona submit` and `astrona test` do not apply: there
is no grading.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition (runtime and bootstrap only) |
| `bootstrap/prepare.sh` | OS preparation run once at startup |
| `docs/overview.md` | What the environment contains and ideas to try |
