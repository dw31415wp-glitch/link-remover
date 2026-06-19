# Feature Specification: Wikitext Replacement Shell

**Feature Branch**: `[001-wikitext-replace-spa]`

**Created**: 2026-06-19

**Status**: Draft

**Input**: User description: "Set up a shell SPA that will have one input to find the wikitext to find and another with the wikitext to replace it with. Also include the page to search and edit. Review WIKIPEDIA_EDIT_REVIEW.md for guidance on how this can be done."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Prepare a Targeted Wikitext Replacement (Priority: P1)

A Wikipedia editor selects which Wikipedia site to use, enters a page to work on, the exact wikitext they want to find, and the replacement wikitext they want to use so they can prepare a precise change without manually searching the full page source.

**Why this priority**: This is the core value of the shell: without the three inputs and a clear preparation flow, there is no usable replacement task.

**Independent Test**: Can be fully tested by selecting either supported Wikipedia site, entering a page name, a find value that exists in that page's wikitext, and a replacement value, then confirming the shell reports the match and prepares the edited text for review.

**Acceptance Scenarios**:

1. **Given** the user has selected a supported Wikipedia site and entered a valid page name and both wikitext fields, **When** they start the search, **Then** the shell searches the selected site, identifies matching wikitext, and shows that a replacement can be prepared.
2. **Given** the find field is empty, **When** the user attempts to search, **Then** the shell prevents the action and explains that the find wikitext is required.
3. **Given** the replacement field is empty, **When** the user attempts to prepare the edit, **Then** the shell treats the action as a deliberate removal only after making that consequence clear.

---

### User Story 2 - Review the Proposed Change Before Wikipedia Handoff (Priority: P2)

A Wikipedia editor reviews what will change before leaving the shell so they can catch accidental matches, stale page text, or malformed replacement wikitext.

**Why this priority**: The reviewed guidance shows the tool should rely on Wikipedia's normal review flow rather than publishing directly; a local preview reduces avoidable mistakes before that handoff.

**Independent Test**: Can be fully tested by preparing a replacement and verifying that the shell presents the original match, replacement, and count of affected occurrences before offering any edit handoff.

**Acceptance Scenarios**:

1. **Given** the page contains one or more matches, **When** the replacement is prepared, **Then** the shell shows the number of replacements and a readable before-and-after preview.
2. **Given** the page contains no matching wikitext, **When** the search completes, **Then** the shell reports that no edit can be prepared and leaves the user's inputs intact.
3. **Given** the page text cannot be retrieved, **When** the search fails, **Then** the shell displays a recoverable error without clearing the user's entered page or wikitext values.

---

### User Story 3 - Open Wikipedia's Edit Review Flow (Priority: P3)

A Wikipedia editor sends the prepared wikitext to Wikipedia's normal edit screen so the final diff, authentication, conflict handling, and save decision stay under Wikipedia's control.

**Why this priority**: The guidance establishes that the tool should hand off to Wikipedia's browser-based editor review flow and must not collect credentials or publish edits itself.

**Independent Test**: Can be fully tested by preparing a valid replacement and confirming that the shell opens Wikipedia's edit review experience with the modified wikitext and an edit summary ready for the user to inspect.

**Acceptance Scenarios**:

1. **Given** the user has reviewed a prepared replacement, **When** they choose to continue to Wikipedia, **Then** Wikipedia opens in a separate review context with the modified wikitext ready for comparison.
2. **Given** the user is not logged in to Wikipedia, **When** they continue to Wikipedia, **Then** the shell does not ask for credentials and leaves authentication or anonymous editing behavior to Wikipedia.
3. **Given** Wikipedia reports an edit conflict or requires additional confirmation, **When** the user reaches Wikipedia's review flow, **Then** the shell has already handed off responsibility and does not claim the edit was saved.

### Edge Cases

- The page title is blank, misspelled, redirected, missing, or contains characters that require careful handling.
- The user switches between supported Wikipedia sites after entering a page and wikitext values.
- The find wikitext appears multiple times and replacing every occurrence could be broader than the user intended.
- The find wikitext spans multiple lines, contains template syntax, links, references, or characters that are meaningful in markup.
- The replacement wikitext is intentionally blank, significantly longer than the original, or contains multiline content.
- The page changes after the shell retrieves wikitext but before the user completes the Wikipedia review flow.
- Public page retrieval is unavailable, rate-limited, or blocked by a network problem.

### Example Input

The shell should support this representative replacement task:

- **Site**: `en`
- **Page**: `Pamela Liversidge` (`https://en.wikipedia.org/wiki/Pamela_Liversidge`)
- **Find wikitext**:

```text
[https://archive.today/20130118233601/http://www.burkespeerage.com/FamilyHomepage.aspx?FID=8529 Burke's Peerage and Gentry]
```

- **Replace wikitext**:

```text
Burke's Peerage and Gentry <sup>[Link Removed]</sup>
```

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The shell MUST provide a Wikipedia site dropdown with exactly two initial options: `en` and `test`.
- **FR-002**: The shell MUST default the Wikipedia site dropdown to `en`.
- **FR-003**: The shell MUST provide a page input where the user can identify the Wikipedia page to search and edit on the selected site.
- **FR-004**: The shell MUST provide a wikitext find input where the user can enter the exact source text to locate.
- **FR-005**: The shell MUST provide a replacement wikitext input where the user can enter the exact source text that should replace each selected match.
- **FR-006**: The shell MUST validate that a supported site, page, and find wikitext are present before attempting to retrieve or search page content.
- **FR-007**: The shell MUST retrieve the current page wikitext for the named page on the selected site using public, read-only access.
- **FR-008**: The shell MUST report whether the find wikitext was found and how many occurrences were identified.
- **FR-009**: The shell MUST preserve the selected site and user-entered page, find, and replacement values after validation errors, no-match results, and recoverable retrieval failures.
- **FR-010**: The shell MUST show a before-and-after review of the proposed replacement before offering any handoff to Wikipedia.
- **FR-011**: The shell MUST make it clear when an empty replacement would remove the found wikitext.
- **FR-012**: The shell MUST allow the user to decide whether to continue to Wikipedia after reviewing the proposed change.
- **FR-013**: The shell MUST hand off prepared edits to Wikipedia's normal edit review flow for the selected site rather than claiming to save or publish the edit itself.
- **FR-014**: The shell MUST NOT request, collect, store, or transmit Wikipedia credentials, edit tokens, OAuth secrets, bot passwords, or other private authentication material.
- **FR-015**: The shell MUST communicate that final authentication, diff review, conflict handling, and saving occur on Wikipedia after handoff.
- **FR-016**: The shell MUST provide clear status and error feedback for loading, validation, no-match, prepared-review, and handoff states.

### Platform and Scope Constraints *(mandatory)*

- **PSC-001**: This feature changes browser React behavior in `index.html`; it does not require Python setup file or CI automation changes.
- **PSC-002**: The feature MUST preserve the static React SPA architecture and avoid server-side application logic.
- **PSC-003**: The feature SHOULD avoid new dependencies; any new browser import or Python dependency requires planning justification before implementation.
- **PSC-004**: The feature MUST NOT require deployment secrets, OAuth credentials, Wikipedia credentials, or publishing automation.

### Key Entities *(include if feature involves data)*

- **Wikipedia Site**: The selected wiki target for the replacement workflow, limited initially to `en` and `test`.
- **Replacement Request**: The user's intended edit task, consisting of the selected site, page identifier, find wikitext, replacement wikitext, and current status.
- **Page Wikitext**: The source text retrieved for the target Wikipedia page on the selected site at the time the user searches.
- **Match Result**: A record of whether the find wikitext appears in the page source, including the number of occurrences and reviewable before-and-after content.
- **Edit Handoff**: The prepared transfer of modified page wikitext to Wikipedia's edit review flow, including the page context and edit summary.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A user can select a supported Wikipedia site, enter a page, find wikitext, replacement wikitext, and reach a reviewable proposed change in under 2 minutes for a page that can be retrieved normally.
- **SC-002**: 100% of replacement attempts use the selected Wikipedia site for both page retrieval and the edit review handoff.
- **SC-003**: 100% of attempted searches with a missing page or missing find value are blocked with a clear message before any page retrieval begins.
- **SC-004**: For test pages containing one, two, or five exact occurrences of the find wikitext, the shell reports the correct replacement count every time.
- **SC-005**: 90% of users in a basic usability check can identify whether the shell saved the edit itself or handed them off to Wikipedia for final review.
- **SC-006**: The shell never asks test users for Wikipedia credentials or private authentication material during the replacement workflow.

## Assumptions

- The first version supports English Wikipedia (`en`) and Test Wikipedia (`test`) as explicit selectable sites.
- The shell prepares exact text replacements; advanced pattern matching, regular expressions, and batch editing across multiple pages are out of scope.
- The user is responsible for final inspection and saving in Wikipedia's editor after the shell opens the review flow.
- If the target page changes between retrieval and final save, Wikipedia's own review or conflict handling is the authority.
- The initial interface can remain a compact shell rather than a full editing suite, as long as the primary workflow is complete and accessible.
