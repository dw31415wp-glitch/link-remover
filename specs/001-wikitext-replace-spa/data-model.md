# Data Model: Wikitext Replacement Shell

## Entity: Wikipedia Site

Represents the selected wiki target for retrieval and handoff.

**Fields**

- `code`: Required. One of `en` or `test`.
- `label`: Human-readable site name shown in the dropdown.
- `host`: Derived site host used for page retrieval and edit review handoff.

**Validation Rules**

- `code` must be one of the two supported values.
- Default value is `en`.
- The same selected site must be used for page retrieval and edit review handoff.

## Entity: Replacement Request

Represents the user's active replacement task.

**Fields**

- `siteCode`: Required selected Wikipedia site code.
- `pageTitle`: Required page identifier entered by the user.
- `findWikitext`: Required exact wikitext to locate.
- `replaceWikitext`: Optional exact replacement wikitext; blank means intentional removal after user-facing confirmation.
- `status`: Current workflow state.

**Validation Rules**

- `siteCode`, `pageTitle`, and `findWikitext` are required before retrieval.
- `replaceWikitext` may be empty, but the UI must communicate that this removes matched text.
- User-entered values are preserved across validation errors, no-match results, and recoverable retrieval failures.

## Entity: Page Wikitext

Represents the page source retrieved for the selected site and page.

**Fields**

- `siteCode`: Site used for retrieval.
- `pageTitle`: Page requested by the user.
- `content`: Retrieved source text.
- `retrievedAt`: Time the content entered browser state.

**Validation Rules**

- Retrieved content must correspond to the selected site and page title currently being reviewed.
- Retrieval failures must produce recoverable user-facing error state.

## Entity: Match Result

Represents the exact-match search result and proposed replacement preview.

**Fields**

- `count`: Number of exact occurrences found.
- `originalSnippet`: Reviewable representation of matched source text.
- `replacementSnippet`: Reviewable representation of replacement text.
- `updatedContent`: Page wikitext after replacing all exact occurrences.

**Validation Rules**

- `count` must be zero or greater.
- Handoff is available only when `count` is greater than zero and the user has reviewed the proposed change.
- Count must reflect literal exact occurrences of `findWikitext` in `content`.

## Entity: Edit Handoff

Represents the user's decision to continue from local preview into Wikipedia's review flow.

**Fields**

- `siteCode`: Selected site for the edit review destination.
- `pageTitle`: Page to open for review.
- `updatedContent`: Modified wikitext prepared from the reviewed match result.
- `summary`: Edit summary presented to Wikipedia's review flow.

**Validation Rules**

- Handoff must target the same site and page as the reviewed match result.
- Handoff must not include stored credentials, OAuth secrets, bot passwords, or private edit tokens.
- The shell must not mark the edit as saved after handoff.

## State Transitions

```text
idle
  -> validating
  -> loading
  -> no_match
  -> ready_for_review
  -> handed_off

idle
  -> validating
  -> validation_error

loading
  -> retrieval_error

no_match | validation_error | retrieval_error | ready_for_review
  -> validating
```

- `idle`: Initial state with site defaulted to `en`.
- `validating`: User has requested a search and inputs are being checked.
- `loading`: Page wikitext retrieval is in progress.
- `validation_error`: Required site, page, or find wikitext is missing or invalid.
- `retrieval_error`: The selected page source could not be retrieved.
- `no_match`: Retrieval succeeded but the exact find wikitext was not found.
- `ready_for_review`: A replacement count and before/after preview are available.
- `handed_off`: The user opened Wikipedia's edit review flow; final save status is outside the shell.
