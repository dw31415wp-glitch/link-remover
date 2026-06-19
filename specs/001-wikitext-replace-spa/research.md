# Research: Wikitext Replacement Shell

## Decision: Keep the feature in the existing static React SPA

**Rationale**: The constitution requires `index.html` to remain the primary entry point unless server-side code is justified. The feature only needs user inputs, public page retrieval, local replacement preview, and a browser handoff, all of which fit the current static SPA surface.

**Alternatives considered**: A backend service was rejected because it would add hosting, security, and credential implications without user value for this shell. A build system was rejected because the existing pinned CDN imports are sufficient for the feature size.

## Decision: Support only `en` and `test` in the first site selector

**Rationale**: The specification requires exactly those two initial options. Limiting the selector keeps URL construction, validation, and handoff behavior testable while still supporting production English Wikipedia and Test Wikipedia workflows.

**Alternatives considered**: A free-form wiki hostname field was rejected because it increases validation and phishing-risk surface. A larger language list was rejected because it exceeds the requested scope.

## Decision: Retrieve page wikitext through public read-only Wikipedia access

**Rationale**: The reviewed edit guidance describes browser-side read-only page source retrieval and no credential handling. Public retrieval supports previewing current source text while preserving the no-secrets, no-backend design.

**Alternatives considered**: Server-side retrieval was rejected because it introduces unnecessary backend logic. Authenticated edit-token retrieval was rejected because the feature must not collect credentials or publish directly.

## Decision: Use literal exact-match replacement for the shell workflow

**Rationale**: The feature is framed around a "find wikitext" input and a "replace wikitext" input. Exact literal matching is predictable for editors, supports multiline wikitext, and avoids ambiguity from regular expressions or fuzzy matching.

**Alternatives considered**: Regular expressions were rejected as out of scope and easier to misuse. Link-aware parsing was rejected for the shell because the requested sample is a direct wikitext replacement and broader parsing can be added later only if specified.

## Decision: Preview all exact occurrences before handoff

**Rationale**: The spec requires a replacement count and before-and-after review before Wikipedia handoff. For the first shell, the match set is the full set of exact occurrences on the selected page; the user can stop before handoff if the count or preview is not what they intended.

**Alternatives considered**: Per-occurrence selection was rejected for this phase because the spec does not require a match selection UI and the first version should remain compact. Immediate handoff without preview was rejected because it would fail the review user story.

## Decision: Hand off to Wikipedia's normal edit review flow, not direct publishing

**Rationale**: `WIKIPEDIA_EDIT_REVIEW.md` establishes a browser form handoff pattern where Wikipedia handles login state, diff review, conflicts, and final save. This preserves user control and avoids credential or CSRF-token handling by the tool.

**Alternatives considered**: Direct MediaWiki editing was rejected because it would require credentials and edit-token handling. Opening only the article page was rejected because it would not carry the prepared wikitext into the review flow.

## Decision: Keep validation lightweight

**Rationale**: The repository has no build step and already validates Python/package metadata. The feature's primary risks are browser UI behavior, exact replacement correctness, site URL selection, and safe handoff, which are best covered by focused browser scenarios and simple source inspection.

**Alternatives considered**: Adding a JavaScript test framework was rejected for this first shell because it would add dependencies and maintenance overhead disproportionate to the current single-file app.
