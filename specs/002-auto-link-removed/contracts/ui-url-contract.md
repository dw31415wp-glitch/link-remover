# UI and URL Contract: Auto Deprecated Archive Replacement

## Generate Replacement Contract

When replacement generation runs:

1. Trim leading and trailing whitespace for parsing only.
2. If the find value is exactly one bracketed external link with an HTTP(S) deprecated archive URL, generate a `{{Deprecated archive}}` replacement.
3. If the replacement field is empty or still equal to the last generated value, place the generated value in the replacement field.
4. If the replacement field was manually edited, leave it unchanged.
5. Show non-blocking status feedback for successful generation or unsupported find text.

## Supported Find Shape

```text
[URL label]
[URL]
```

Example:

```text
[https://archive.today/20130118233601/http://www.burkespeerage.com/FamilyHomepage.aspx?FID=8529 Burke's Peerage and Gentry]
```

Expected generated replacement:

```text
{{Deprecated archive|https://archive.today/20130118233601/http://www.burkespeerage.com/FamilyHomepage.aspx?FID=8529|Burke's Peerage and Gentry}}
```

## Unsupported Find Values

No auto-generated replacement should be produced for:

- Plain text with no bracketed external link.
- Malformed bracketed links.
- Multiple bracketed external links.
- A bracketed external link plus additional surrounding content.
- A URL that is missing a protocol, cannot produce a non-empty host, or is not an archive.today-family host.
- Label text containing `|`, `=`, or template braces, because those cannot be emitted confidently with positional parameters.

## URL Prefill Contract

The shell accepts these optional URL parameters:

| Parameter | Meaning | Rule |
|-----------|---------|------|
| `site` | Wikipedia site selector value | Apply only when the value is supported. |
| `page` | Page title | Convert underscores to spaces before displaying. |
| `find` | Find wikitext | Decode before displaying; must be encoded when generated in a URL. |

Example prefill URL shape:

```text
/?site=en&page=Pamela_Liversidge&find=%5Bhttps%3A%2F%2Farchive.today%2F20130118233601%2Fhttp%3A%2F%2Fwww.burkespeerage.com%2FFamilyHomepage.aspx%3FFID%3D8529%20Burke's%20Peerage%20and%20Gentry%5D
```

Expected field values:

| Field | Value |
|-------|-------|
| Site | `en` |
| Page | `Pamela Liversidge` |
| Find wikitext | `[https://archive.today/20130118233601/http://www.burkespeerage.com/FamilyHomepage.aspx?FID=8529 Burke's Peerage and Gentry]` |

## Accessibility Contract

- Generation must be available by keyboard.
- Status feedback must be visible and not rely on color alone.
- Auto-generation must not start a page search or submit any data.
- Manual replacement edits must remain possible after auto-generation.
