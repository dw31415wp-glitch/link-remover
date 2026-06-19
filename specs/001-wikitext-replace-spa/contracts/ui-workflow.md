# UI Contract: Wikitext Replacement Shell

## Primary Controls

The shell exposes one form-like workflow on the first screen.

| Control | Type | Required | Contract |
|---------|------|----------|----------|
| Wikipedia site | Dropdown | Yes | Contains exactly `en` and `test`; defaults to `en`; selection controls both retrieval and handoff destination. |
| Page | Text input | Yes | Accepts a Wikipedia page title or URL-like page reference; preserves the user's value after errors. |
| Find wikitext | Multiline input | Yes | Accepts exact literal wikitext, including links, templates, references, brackets, apostrophes, and multiline text. |
| Replace wikitext | Multiline input | No | Accepts exact literal replacement wikitext; blank value is allowed only with clear removal messaging. |
| Search/preview action | Button | Yes | Validates inputs, retrieves current page source, counts exact matches, and prepares review state. |
| Continue to Wikipedia | Button | Conditional | Available only after a nonzero match result has been reviewed. Opens the selected site's edit review flow. |

## Status States

| State | Required User Feedback |
|-------|------------------------|
| Validation error | Identify which required input is missing or invalid without clearing any user-entered values. |
| Loading | Indicate that page source is being retrieved for the selected site and page. |
| No match | State that the find wikitext was not found and no edit can be prepared. |
| Ready for review | Show replacement count and readable before/after content before handoff is possible. |
| Retrieval error | Explain that page source could not be retrieved and let the user correct inputs or retry. |
| Handoff | Communicate that Wikipedia is responsible for authentication, diff review, conflict handling, and saving. |

## Representative Scenario Contract

The shell must support this representative input set:

| Field | Value |
|-------|-------|
| Site | `en` |
| Page | `Pamela Liversidge` |
| Find wikitext | `[https://archive.today/20130118233601/http://www.burkespeerage.com/FamilyHomepage.aspx?FID=8529 Burke's Peerage and Gentry]` |
| Replace wikitext | `Burke's Peerage and Gentry <sup>[Link Removed]</sup>` |

Expected behavior: retrieval targets English Wikipedia, exact matches are counted literally, preview shows the link text being replaced by the supplied replacement text, and handoff opens English Wikipedia's edit review flow for `Pamela Liversidge`.

## Accessibility Contract

- Every input has a visible label.
- The dropdown, text inputs, textareas, and buttons are keyboard reachable in a logical order.
- Status and error text is visible near the workflow and does not rely on color alone.
- Buttons communicate disabled or unavailable states without layout shifts.
- No credential, token, or secret input is present anywhere in the workflow.
