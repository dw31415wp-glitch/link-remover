# Quickstart: Auto Link Removed Replacement

## Prerequisites

- Python 3.11 available for repository validation commands.
- A modern browser with JavaScript enabled.

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

Expected outcome: dependencies install successfully in an isolated environment, Python syntax validation either compiles tracked Python files or reports that none exist, and package metadata remains valid.

## Local Browser Run

Serve the repository root with a static file server:

```sh
python -m http.server 8000
```

Then open `http://localhost:8000/`.

Expected outcome: the shell loads without build steps or additional runtime services.

## Scenario 1: Auto-Generate Replacement On Blur

1. Leave the replacement field empty.
2. Paste this into Find wikitext:

```text
[https://archive.example.com/20130118233601/http://www.burkespeerage.com/FamilyHomepage.aspx?FID=8529 Burke's Peerage and Gentry]
```

3. Move focus away from the find field.

Expected replacement:

```text
{{Link removed|Burke's Peerage and Gentry|linkhostpath=archive.example.com/20130118233601/http://www.burkespeerage.com/FamilyHomepage.aspx?FID=8529|protocol=https}}
```

## Scenario 2: Preserve Manual Replacement

1. Enter any supported bracketed external-link find value.
2. Type a custom value in Replace wikitext.
3. Move focus away from Find wikitext.

Expected outcome: the custom replacement remains unchanged.

## Scenario 3: Unsupported Find Text

1. Enter plain text, malformed bracketed link text, or multiple external links in Find wikitext.
2. Move focus away from Find wikitext.

Expected outcome: no replacement template is generated, and manual replacement remains possible.

## Scenario 4: HTTP Protocol

1. Enter a find value beginning with `http://`.
2. Move focus away from Find wikitext.

Expected outcome: the generated template includes `protocol=http`.

## Scenario 5: URL Prefill

Open:

```text
http://localhost:8000/?site=en&page=Pamela_Liversidge&find=%5Bhttps%3A%2F%2Farchive.example.com%2F20130118233601%2Fhttp%3A%2F%2Fwww.burkespeerage.com%2FFamilyHomepage.aspx%3FFID%3D8529%20Burke's%20Peerage%20and%20Gentry%5D
```

Expected outcome:

- Site is `en`.
- Page displays as `Pamela Liversidge`.
- Find wikitext displays as the decoded bracketed external link.
- Replacement auto-generates to the expected `{{Link removed}}` template.

## Scenario 6: Malformed URL Prefill

Open the shell with missing, unsupported, or malformed `site`, `page`, or `find` parameters.

Expected outcome: supported values are applied, unsupported values are ignored, and the shell remains usable.
