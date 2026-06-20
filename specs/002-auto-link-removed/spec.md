# Feature Specification: Auto Deprecated Archive Replacement

**Feature Branch**: `[002-auto-link-removed]`

**Created**: 2026-06-19

**Status**: Draft

**Input**: User description: "Update the archive.today replacement text generation to use the simplified `{{Deprecated archive}}` template interface. Generate `{{Deprecated archive|ARCHIVE_URL|TITLE}}`, omit named parameters, and generate `{{Deprecated archive|ARCHIVE_URL}}` when the link has no display label."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Auto-Fill Replacement From Find Wikitext (Priority: P1)

A Wikipedia editor pastes a bracketed archive.today external-link wikitext value into the find field, generates a replacement, and sees the replacement field populated with a `{{Deprecated archive}}` template containing the original archive URL and optional display label.

**Why this priority**: This removes the repetitive and error-prone step of manually converting external-link wikitext into the tracking template before preparing a replacement.

**Independent Test**: Can be fully tested by entering a supported bracketed external link in the find field, generating a replacement, and confirming that the replacement field contains the expected `{{Deprecated archive}}` template.

**Acceptance Scenarios**:

1. **Given** the replacement field is empty and the find field contains `[https://archive.today/20130118233601/http://www.burkespeerage.com/FamilyHomepage.aspx?FID=8529 Burke's Peerage and Gentry]`, **When** the user generates a replacement, **Then** the replacement field is filled with `{{Deprecated archive|https://archive.today/20130118233601/http://www.burkespeerage.com/FamilyHomepage.aspx?FID=8529|Burke's Peerage and Gentry}}`.
2. **Given** the replacement field is empty and the find field contains `[https://archive.today/20131217001046/http://archives.dailynews.lk/2003/10/18/fea05.html]`, **When** the user generates a replacement, **Then** the replacement field is filled with `{{Deprecated archive|https://archive.today/20131217001046/http://archives.dailynews.lk/2003/10/18/fea05.html}}`.
3. **Given** the replacement field contains a value generated from the previous find wikitext, **When** the user changes the find field to another supported bracketed external link and generates a replacement, **Then** the replacement field updates to match the new archive URL and optional label.
4. **Given** the replacement field contains user-edited text that was not auto-generated, **When** the user generates a replacement, **Then** the system does not overwrite the user's replacement text.

---

### User Story 2 - Leave Unsupported Find Text Alone (Priority: P2)

A Wikipedia editor enters find text that is not a single supported bracketed external link and leaves the field without losing a manually prepared replacement.

**Why this priority**: The existing shell supports exact text replacement beyond external links, so auto-generation must be helpful without blocking or damaging other workflows.

**Independent Test**: Can be fully tested by entering non-link wikitext or malformed bracketed link text, leaving the find field, and confirming that the replacement field is not overwritten.

**Acceptance Scenarios**:

1. **Given** the find field contains plain text that is not bracketed external-link wikitext, **When** the user generates a replacement, **Then** no replacement template is generated.
2. **Given** the find field contains a malformed bracketed link, **When** the user generates a replacement, **Then** no replacement template is generated and the user can continue editing manually.
3. **Given** the replacement field already contains a manually entered value, **When** the user generates a replacement from unsupported find text, **Then** the manual replacement remains unchanged.

---

### User Story 3 - Pre-Fill From URL Parameters (Priority: P3)

A Wikipedia editor opens the shell from a prepared URL containing the target site, page, and find wikitext so the form is ready to review or auto-generate replacement text immediately.

**Why this priority**: Shareable and bookmarkable URLs reduce repetitive setup when another tool or workflow already knows the page and find wikitext.

**Independent Test**: Can be fully tested by opening the shell with URL parameters for site, page, and encoded find wikitext, then confirming the corresponding fields are populated correctly.

**Acceptance Scenarios**:

1. **Given** the shell URL contains `site=en`, `page=Pamela_Liversidge`, and an encoded `find` value, **When** the page loads, **Then** the site, page, and find fields are populated with `en`, `Pamela Liversidge`, and the decoded find wikitext.
2. **Given** the page field is represented in a URL parameter with underscores, **When** the page loads, **Then** underscores in the page parameter are shown as spaces in the page field.
3. **Given** the find wikitext contains brackets, spaces, apostrophes, query strings, or other characters that can affect links, **When** it is passed in the URL, **Then** it is encoded in the URL and decoded back into the find field without changing the wikitext.

### Edge Cases

- The bracketed link label contains apostrophes, punctuation, parentheses, brackets, or multiple spaces.
- The bracketed external link has no display label.
- The URL uses `http` instead of `https`; the generated template should preserve the original archive URL exactly as parameter 1.
- The URL uses `https`; the generated template should preserve the original archive URL exactly as parameter 1.
- The URL includes a query string, fragment, encoded characters, or a nested original URL after an archive prefix.
- The find field contains leading or trailing whitespace around the bracketed external link.
- The find field contains multiple links or additional surrounding text.
- The replacement field was auto-generated, then manually edited by the user.
- URL parameters are missing, duplicated, unsupported, or partially malformed.
- The page URL parameter contains spaces instead of underscores.
- The encoded find URL parameter contains characters such as `[`, `]`, `?`, `&`, `=`, `%`, apostrophes, or spaces.

### Example Conversion

- **Find wikitext**:

```text
[https://archive.today/20130118233601/http://www.burkespeerage.com/FamilyHomepage.aspx?FID=8529 Burke's Peerage and Gentry]
```

- **Generated replacement wikitext**:

```text
{{Deprecated archive|https://archive.today/20130118233601/http://www.burkespeerage.com/FamilyHomepage.aspx?FID=8529|Burke's Peerage and Gentry}}
```

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST attempt replacement generation when the user uses Generate replacement.
- **FR-002**: The system MUST recognize a supported find value as one bracketed external-link wikitext expression containing an HTTP(S) archive.today-family URL and optional label.
- **FR-003**: The system MUST generate replacement wikitext using the `{{Deprecated archive}}` template.
- **FR-004**: The generated template MUST fill the first template parameter with the original archive URL, including protocol.
- **FR-005**: The generated template MUST fill the second positional template parameter with the external-link label when a label exists.
- **FR-006**: The generated template MUST omit the second positional template parameter when the original external link has no label.
- **FR-007**: The system MUST preserve apostrophes, punctuation, and ordinary spacing in the generated label value.
- **FR-008**: The system MUST NOT overwrite a replacement value that the user has manually edited.
- **FR-009**: The system MAY update the replacement value when that value is empty or still matches the system's previously generated value for the prior find text.
- **FR-010**: The system MUST leave the replacement field unchanged when the find text is unsupported, malformed, contains multiple external-link expressions, or contains extra surrounding content.
- **FR-011**: The system MUST provide user-visible feedback when auto-generation succeeds or when the find value cannot be auto-generated, without blocking manual replacement.
- **FR-012**: Existing search, preview, replacement, and Wikipedia handoff behavior MUST continue to use the final replacement field value chosen by the user.
- **FR-013**: The system MUST accept optional URL parameters for site, page, and find wikitext.
- **FR-014**: The system MUST pre-fill the site field from the URL parameter only when the supplied value is one of the supported site options.
- **FR-015**: The system MUST pre-fill the page field from the URL parameter and display underscores as spaces in the form field.
- **FR-016**: The system MUST encode find wikitext when representing it in the URL so brackets, spaces, query strings, and other link-sensitive characters do not break the shell URL.
- **FR-017**: The system MUST decode the encoded find URL parameter back to the original find wikitext before displaying it in the find field.
- **FR-018**: The system MUST leave existing default field values unchanged for missing, unsupported, or malformed URL parameters.
- **FR-019**: The system SHOULD apply replacement auto-generation after pre-filling a supported find value from URL parameters when doing so would not overwrite a manually edited replacement.

### Platform and Scope Constraints *(mandatory)*

- **PSC-001**: This feature changes browser React behavior in `index.html`; it does not require Python setup file or CI automation changes.
- **PSC-002**: This feature MUST preserve the static React SPA architecture and avoid server-side application logic.
- **PSC-003**: This feature MUST NOT introduce new browser CDN imports or Python dependencies.
- **PSC-004**: This feature MUST NOT require deployment secrets, OAuth credentials, Wikipedia credentials, or publishing automation.

### Key Entities *(include if feature involves data)*

- **Find Wikitext**: The exact source text entered by the user, which may contain a bracketed external-link expression.
- **URL Prefill Parameters**: Optional URL values representing site, page, and encoded find wikitext.
- **Parsed External Link**: A recognized link consisting of the original archive URL and optional label.
- **Generated Replacement**: The `{{Deprecated archive}}` template text created from the parsed external link.
- **Replacement Edit State**: Whether the replacement field is empty, auto-generated, or manually edited by the user.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of supported bracketed external-link examples in validation generate the expected `{{Deprecated archive}}` replacement.
- **SC-002**: 100% of generated replacements include the original archive URL and omit `sourceurl`, `title`, `archivehostpath`, and `protocol`.
- **SC-003**: 100% of unsupported or malformed find values leave the replacement field unchanged.
- **SC-004**: 100% of manually edited replacement values are preserved when replacement generation runs.
- **SC-005**: Users can paste the example find wikitext and receive the generated replacement in under 5 seconds without starting a page search.
- **SC-006**: 100% of valid prefill URLs in validation populate the expected site, page, and find fields on page load.
- **SC-007**: 100% of generated or documented prefill URLs encode the find wikitext so the shell URL contains no raw spaces or raw square brackets in the find parameter.
- **SC-008**: 100% of page values passed with underscores display with spaces in the page field.

## Assumptions

- The feature builds on the existing single-page replacement shell and does not change the final edit handoff behavior.
- The supported auto-generation scope is a single bracketed external link of the form `[URL label]` or `[URL]`.
- `Deprecated archive` is the canonical template name for generated replacement text.
- The generated replacement intentionally uses template syntax rather than rendered HTML.
- URL prefill parameters use `site`, `page`, and `find` as the canonical parameter names.
- Page parameter values use underscores for spaces in URLs and display as spaces in the form.
- Find wikitext values are URL-encoded before being placed in a shell URL.
- If parsing is ambiguous, the system should prefer leaving the replacement field untouched and letting the user edit manually.
