# Research: Auto Deprecated Archive Replacement

## Decision: Parse only a single complete bracketed external link

**Rationale**: The feature targets find wikitext shaped like `[URL label]` or `[URL]`. Requiring the entire find value to match one bracketed external link avoids surprising conversions when users paste snippets containing multiple links or surrounding prose.

**Alternatives considered**: Parsing the first external link inside larger text was rejected because it could silently generate a replacement for only part of the find value. Supporting multiple links was rejected because the replacement field accepts one replacement value for the exact find text.

## Decision: Preserve the original archive URL as the first positional parameter

**Rationale**: The simplified `{{Deprecated archive}}` template interface expects the original deprecated archive URL, including protocol, as parameter 1. The replacement generator should not derive or render the source URL, archive host/path, or protocol fields.

**Alternatives considered**: Keeping `sourceurl`, `archivehostpath`, `title`, or `protocol` named parameters was rejected because the simplified template interface no longer needs them.

## Decision: Use the external-link label as the optional second positional parameter

**Rationale**: The visible label from the original external link is the display text users expect to preserve. When the original external link has no label, omitting parameter 2 lets the template display the archive URL as plain non-clickable text.

**Alternatives considered**: Deriving a title from the archived source URL was rejected because the requirement says not to derive or render the source URL in replacement text.

## Decision: Do not overwrite manually edited replacement text

**Rationale**: Auto-generation should save effort without destroying user intent. If the replacement field is empty or still contains the previously generated value, it is safe to update; otherwise the user's manual replacement wins.

**Alternatives considered**: Always overwriting during generation was rejected as too destructive. Never updating after the first generation was rejected because users may correct the find field and expect the replacement to follow.

## Decision: Use `site`, `page`, and `find` as URL prefill parameters

**Rationale**: These names map directly to the visible fields and are short enough for generated links. The page parameter uses underscores for spaces to match common wiki title URL conventions; the find parameter is encoded to prevent brackets, spaces, and query-string characters from breaking the shell URL.

**Alternatives considered**: Using longer names such as `findWikitext` was rejected for URL brevity. Using raw find text was rejected because raw brackets, spaces, `?`, and `&` can corrupt links. Using encoded page titles was rejected because the user specifically requested underscores for spaces in the page parameter.

## Decision: Apply auto-generation after valid URL prefill

**Rationale**: A URL that already supplies a supported find value should open the shell with the replacement value ready, as long as doing so does not override user-edited replacement text. Initial page load has no prior manual edit, so auto-generation is safe.

**Alternatives considered**: Requiring another manual generation step after prefill was rejected because it defeats much of the value of a prefilled URL. Starting a page search automatically was rejected because the feature only concerns field population and replacement generation.
