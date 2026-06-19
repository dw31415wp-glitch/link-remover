# Running Simple RFC Stats on Toolforge

These notes are based on Wikitech's Toolforge jobs documentation:

- https://wikitech.wikimedia.org/wiki/Help:Toolforge/Running_jobs
- https://wikitech.wikimedia.org/wiki/Help:Toolforge/Envvars

The recommended Toolforge setup is a scheduled job that runs `python main.py --once` every 5 minutes. The bot remembers completed requests by replying on the request page with a hidden results marker and skips request sections that already have that reply.

## 1. Log in and become the tool

```bash
ssh <your-shell-user>@login.toolforge.org
become <tool-name>
```

## 2. Clone the repository

For a read-only deployment clone, use HTTPS so the Toolforge account does not
need a GitLab SSH key:

```bash
git clone https://github.com/dw31415wp-glitch/link-remover
cd link-remover
```

If you need to push from Toolforge, use the SSH URL instead, but first create an
SSH key for the tool account and add its public key to your Wikimedia GitLab
account or as a deploy key for the project. Without that setup, GitLab will
return `Permission denied (publickey)` for `git@gitlab.wikimedia.org:...`.

## 4. Create the webservice

```bash
./toolforge_recreate_job.sh
```

## 5. Manage the job

Emergency shutoff:

Edit `User:DwAlphaBot/Shutoff` and put `STOP` on its own line. The bot checks
that page at startup and before each wiki save. Remove `STOP` to allow future
runs again.

List jobs:

```bash
toolforge jobs list
```

Show details:

```bash
toolforge jobs show simple-rfc-stats
```

Force a run now:

```bash
toolforge jobs restart simple-rfc-stats
```

Delete the job:

```bash
toolforge jobs delete simple-rfc-stats
```

## Notes

- `DRY_RUN` is currently `False` in `config.py`, so scheduled runs publish result sections and request replies. Set it to `True` only for local testing without wiki edits.
- Job stdout/stderr are handled by Toolforge job logging.
- If you change envvars, restart the job so new runs pick up the updated value.
