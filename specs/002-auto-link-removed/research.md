# Research: Auto Link Removed Replacement

## Decision: Parse only a single complete bracketed external link

**Rationale**: The feature targets find wikitext shaped like `[URL label]`. Requiring the entire find value to match that shape avoids surprising conversions when users paste snippets containing multiple links or surrounding prose.

**Alternatives considered**: Parsing the first external link inside larger text was rejected because it could silently generate a replacement for only part of the find value. Supporting multiple links was rejected because the replacement field accepts one replacement value for the exact find text.

## Decision: Preserve the URL protocol as a template parameter

**Rationale**: The `Link removed` template supports `protocol` as tracking data, defaulting to `https`. Generated replacements should include the parsed protocol so `http` links are not normalized incorrectly and `https` examples are explicit.

**Alternatives considered**: Omitting `protocol=https` was rejected because the specification asks to fill parameters and success criteria require a protocol parameter. Always using `https` was rejected because `http` source links need accurate tracking.

## Decision: Store host/path without protocol in `linkhostpath`

**Rationale**: The tracking parameter is intended to capture the removed link host/path while `protocol` tracks the protocol separately. This keeps template data normalized and mirrors the user's requested parameter shape.

**Alternatives considered**: Storing the full URL in `linkhostpath` was rejected because it duplicates protocol information. Storing only the host was rejected because the path, query, and fragment are important maintenance context.

## Decision: Do not overwrite manually edited replacement text

**Rationale**: Auto-generation should save effort without destroying user intent. If the replacement field is empty or still contains the previously generated value, it is safe to update; otherwise the user's manual replacement wins.

**Alternatives considered**: Always overwriting on blur was rejected as too destructive. Never updating after the first generation was rejected because users may correct the find field and expect the replacement to follow.

## Decision: Use `site`, `page`, and `find` as URL prefill parameters

**Rationale**: These names map directly to the visible fields and are short enough for generated links. The page parameter uses underscores for spaces to match common wiki title URL conventions; the find parameter is encoded to prevent brackets, spaces, and query-string characters from breaking the shell URL.

**Alternatives considered**: Using longer names such as `findWikitext` was rejected for URL brevity. Using raw find text was rejected because raw brackets, spaces, `?`, and `&` can corrupt links. Using encoded page titles was rejected because the user specifically requested underscores for spaces in the page parameter.

## Decision: Apply auto-generation after valid URL prefill

**Rationale**: A URL that already supplies a supported find value should open the shell with the replacement value ready, as long as doing so does not override user-edited replacement text. Initial page load has no prior manual edit, so auto-generation is safe.

**Alternatives considered**: Requiring the user to blur the field after prefill was rejected because it defeats much of the value of a prefilled URL. Starting a page search automatically was rejected because the feature only concerns field population and replacement generation.
