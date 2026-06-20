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
toolforge build start https://github.com/dw31415wp-glitch/link-remover
toolforge build show
toolforge webservice buildservice start --mount=none
```
