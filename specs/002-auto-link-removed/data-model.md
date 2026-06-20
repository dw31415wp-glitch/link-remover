# Data Model: Auto Deprecated Archive Replacement

## Entity: Find Wikitext

Represents the exact source text entered or prefilled for the find field.

**Fields**

- `value`: The find text displayed in the form.
- `source`: Whether the value came from user input, sample data, or URL prefill.

**Validation Rules**

- A supported value is exactly one bracketed external-link expression of the form `[URL label]` or `[URL]` after trimming leading and trailing whitespace.
- Unsupported values remain valid as manual find text but do not produce an auto-generated replacement.

## Entity: URL Prefill Parameters

Represents optional values supplied through the shell URL.

**Fields**

- `site`: Optional selected site code.
- `page`: Optional page title with underscores representing spaces.
- `find`: Optional encoded find wikitext.

**Validation Rules**

- `site` is applied only when it matches a supported site option.
- `page` displays underscores as spaces in the form field.
- `find` is decoded before display; malformed encoded values are ignored rather than blocking the page.
- Missing parameters leave defaults unchanged.

## Entity: Parsed External Link

Represents a successful parse of supported bracketed external-link wikitext.

**Fields**

- `archiveUrl`: Original URL text from the external link, including protocol.
- `label`: Optional text after the URL inside the bracketed link.

**Validation Rules**

- `archiveUrl` must be non-empty and parse as an HTTP(S) URL with an archive.today-family host.
- `label`, when present, must not contain `|`, `=`, or template braces because generated output uses positional template parameters.
- The source find value must contain one URL and optional label within a single bracketed expression.

## Entity: Generated Replacement

Represents the replacement text created from a parsed external link.

**Fields**

- `value`: `{{Deprecated archive|archiveUrl|label}}` when a label exists, or `{{Deprecated archive|archiveUrl}}` when no label exists.
- `sourceFindValue`: Find wikitext used to generate this value.

**Validation Rules**

- Generated value must include the original archive URL as parameter 1 and must not include `sourceurl`, `title`, `archivehostpath`, or `protocol`.
- The replacement field may be updated only when empty or still equal to the previous generated value.

## Entity: Replacement Edit State

Represents whether the replacement field can be safely auto-updated.

**Fields**

- `currentValue`: Current replacement text.
- `lastGeneratedValue`: Most recent generated replacement text.
- `isManual`: Whether the current value no longer matches the generated value after user editing.

**State Transitions**

```text
empty
  -> generated
  -> manual

generated
  -> generated
  -> manual

manual
  -> manual
```

- `empty`: Replacement field has no value and may be filled automatically.
- `generated`: Replacement field contains the current generated value and may be updated when find changes.
- `manual`: User has edited replacement text; auto-generation must not overwrite it.
