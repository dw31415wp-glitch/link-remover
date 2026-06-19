# Quickstart: Wikitext Replacement Shell

## Prerequisites

- Python 3.11 available for the existing repository validation commands.
- A modern browser with JavaScript enabled.
- Network access to the selected Wikipedia site for manual end-to-end checks.

## Repository Validation

From the repository root:

```sh
python -m pip install -r requirements.txt
python - <<'PY'
import pathlib
import py_compile
import subprocess
import sys

tracked = subprocess.check_output(
    ["git", "ls-files", "*.py"],
    text=True,
).splitlines()

if not tracked:
    print("No tracked Python files to compile.")
    sys.exit(0)

for filename in tracked:
    py_compile.compile(filename, doraise=True)
    print(f"Compiled {pathlib.Path(filename)}")
PY
python - <<'PY'
import tomllib

with open("pyproject.toml", "rb") as project_file:
    project = tomllib.load(project_file)

assert project["project"]["name"] == "link-remover"
assert project["project"]["dependencies"] == []
PY
```

Expected outcome: dependencies install successfully, Python syntax validation either compiles tracked Python files or reports that none exist, and package metadata remains valid.

## Local Browser Run

For local manual validation, serve the repository root with any simple static file server, then open `index.html` in a browser. One option:

```sh
python -m http.server 8000
```

Then open `http://localhost:8000/`.

Expected outcome: the shell loads as a single-page app without build steps or additional runtime services.

## Scenario 1: Required Input Validation

1. Leave Page empty.
2. Enter any non-empty Find wikitext.
3. Choose Search/Preview.

Expected outcome: the shell blocks retrieval, identifies that Page is required, and preserves all entered values.

Repeat with Page filled and Find wikitext empty.

Expected outcome: the shell blocks retrieval and identifies that Find wikitext is required.

## Scenario 2: Site Selection

1. Confirm the Wikipedia site dropdown defaults to `en`.
2. Switch the dropdown to `test`.
3. Enter a page and find text appropriate for Test Wikipedia.
4. Choose Search/Preview.

Expected outcome: retrieval and any later handoff target Test Wikipedia, not English Wikipedia. Switching the dropdown does not erase page or wikitext inputs.

## Scenario 3: Representative Replacement

1. Select site `en`.
2. Enter page `Pamela Liversidge`.
3. Enter Find wikitext:

```text
[https://archive.today/20130118233601/http://www.burkespeerage.com/FamilyHomepage.aspx?FID=8529 Burke's Peerage and Gentry]
```

4. Enter Replace wikitext:

```text
Burke's Peerage and Gentry <sup>[Link Removed]</sup>
```

5. Choose Search/Preview.

Expected outcome: the shell retrieves English Wikipedia page source, reports the exact match count, and shows a before/after preview. If the page no longer contains the exact sample text, the shell reports no match without clearing inputs.

## Scenario 4: Empty Replacement

1. Enter a retrievable page and a find value expected to exist.
2. Leave Replace wikitext empty.
3. Choose Search/Preview.

Expected outcome: the shell clearly communicates that the replacement would remove the matched wikitext before any handoff is available.

## Scenario 5: Wikipedia Review Handoff

1. Complete a scenario that reaches Ready for review with at least one match.
2. Choose Continue to Wikipedia.

Expected outcome: the selected Wikipedia site's edit review flow opens for the target page with modified wikitext ready for review. The shell does not ask for credentials and does not claim the edit was saved.
