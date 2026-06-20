# Quickstart: Auto Deprecated Archive Replacement

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
node tests/scripts/generate-deprecated-archive.test.mjs
```

Expected outcome: dependencies install successfully in an isolated environment, Python syntax validation either compiles tracked Python files or reports that none exist, package metadata remains valid, and Deprecated archive replacement fixtures pass.

## Local Browser Run

Serve the repository root with a static file server:

```sh
python -m http.server 8000
```

Then open `http://localhost:8000/`.

Expected outcome: the shell loads without build steps or additional runtime services.

## Scenario 1: Generate Deprecated Archive Replacement

1. Leave the replacement field empty.
2. Paste this into Find wikitext:

```text
[https://archive.today/20130118233601/http://www.burkespeerage.com/FamilyHomepage.aspx?FID=8529 Burke's Peerage and Gentry]
```

3. Use Generate replacement.

Expected replacement:

```text
{{Deprecated archive|https://archive.today/20130118233601/http://www.burkespeerage.com/FamilyHomepage.aspx?FID=8529|Burke's Peerage and Gentry}}
```

## Scenario 2: Generate Bare Deprecated Archive Replacement

1. Leave the replacement field empty.
2. Paste this into Find wikitext:

```text
[https://archive.today/20131217001046/http://archives.dailynews.lk/2003/10/18/fea05.html]
```

3. Use Generate replacement.

Expected replacement:

```text
{{Deprecated archive|https://archive.today/20131217001046/http://archives.dailynews.lk/2003/10/18/fea05.html}}
```

## Scenario 3: Preserve Manual Replacement

1. Enter any supported bracketed external-link find value.
2. Type a custom value in Replace wikitext.
3. Use Generate replacement.

Expected outcome: the custom replacement remains unchanged.

## Scenario 4: Unsupported Find Text

1. Enter plain text, malformed bracketed link text, or multiple external links in Find wikitext.
2. Use Generate replacement.

Expected outcome: no replacement template is generated, and manual replacement remains possible.

## Scenario 5: Apostrophes In Label Text

1. Enter the Burke's Peerage example from Scenario 1.
2. Use Generate replacement.

Expected outcome: the apostrophe in `Burke's Peerage and Gentry` is preserved in positional parameter 2.

## Scenario 6: URL Prefill

Open:

```text
http://localhost:8000/?site=en&page=Pamela_Liversidge&find=%5Bhttps%3A%2F%2Farchive.today%2F20130118233601%2Fhttp%3A%2F%2Fwww.burkespeerage.com%2FFamilyHomepage.aspx%3FFID%3D8529%20Burke's%20Peerage%20and%20Gentry%5D
```

Expected outcome:

- Site is `en`.
- Page displays as `Pamela Liversidge`.
- Find wikitext displays as the decoded bracketed external link.
- Replacement auto-generates to the expected `{{Deprecated archive}}` template.

## Scenario 7: Malformed URL Prefill

Open the shell with missing, unsupported, or malformed `site`, `page`, or `find` parameters.

Expected outcome: supported values are applied, unsupported values are ignored, and the shell remains usable.
