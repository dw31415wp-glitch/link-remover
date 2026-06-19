# Wikipedia edit flow review

## Scope

This repository currently contains only a static redirect and a minimal Python static-file server:

- `index.html` redirects immediately to `https://fixarchive.toolforge.org/`.
- `app.py` serves files with Python's `http.server`; it does not implement an application API.

Because the edit code is not present in the checked-out repository, I also inspected the deployed Toolforge page that the repo redirects to on 2026-06-19.

## Summary

The deployed tool does not publish edits through the MediaWiki API. It runs in the user's browser, rewrites article wikitext client-side, and opens Wikipedia's normal web editor flow with a pre-filled edit form. Authentication is not handled by this tool: it neither logs the user in nor stores credentials. Any logged-in state comes from the user's own Wikipedia browser session after the handoff to `en.wikipedia.org`.

## How scanning works

The deployed page is a single HTML/React application. It calls public APIs directly from the browser:

- Wikipedia API reads use `fetch()` against `https://en.wikipedia.org/w/api.php?...&format=json&origin=*`.
- Article wikitext is fetched with `action=query&prop=revisions&rvprop=content&rvslots=main`.
- Search suggestions use `action=opensearch`.
- Category traversal uses `list=categorymembers`.
- Wayback alternatives are checked with `https://archive.org/wayback/available`.
- High-traffic page lists are fetched from the Wikimedia Pageviews REST API.

These requests are read-only and unauthenticated. The code does not set `credentials`, `Authorization`, OAuth headers, bot-password credentials, or MediaWiki login parameters.

## How the edit handoff works

The key deployed helper is `executeMassEdit(title, originalWikitext, selectedLinks)`.

Its behavior:

1. Starts from the wikitext captured during scanning.
2. For each selected verified link, attempts to isolate the surrounding citation template.
3. Replaces the `archive.today` URL with the selected Wayback URL.
4. Updates an existing `archive-date` / `archivedate` parameter, or inserts `archive-date` after `archive-url` / `archiveurl` when possible.
5. Falls back to a global string replacement if citation-block isolation fails.
6. Creates a hidden HTML `<form>` in the browser.
7. Submits that form with `method="POST"` and `target="_blank"` to:

```text
https://en.wikipedia.org/w/index.php?title=<title>&action=submit
```

The submitted fields include:

- `wpTextbox1`: the rewritten wikitext.
- `wpSummary`: an edit summary referencing `[[WP:ATODAY]]`.
- `wpDiff`: `Show changes`, which asks Wikipedia to show the diff rather than immediately publish.
- `wpUltimateParam`: a dummy field described by the code as anti-truncation.
- `wpEditToken`: a dummy `+\` token described by the code as satisfying MediaWiki preview checks.

The UI only calls `executeMassEdit` after the user has clicked a Wayback URL, waited through a five-second verification countdown, and marked the link as verified. There are two entry points:

- "Push Verified Archives to Wikipedia" for all staged links on an article.
- "Fix this link on Wikipedia" for one staged link.

## Authentication findings

The tool does not implement authentication.

There is no OAuth flow, no username/password prompt, no bot password support, no login API request, and no edit-token retrieval via the MediaWiki API. The dummy `wpEditToken` is not a real logged-in CSRF token.

Practical consequence:

- If the user is already logged in to Wikipedia in the browser, the handoff relies on Wikipedia's own web session once the new Wikipedia tab opens.
- If the user is not logged in, Wikipedia will treat the edit as an anonymous edit path or prompt/behave according to Wikipedia's normal editor flow.
- The tool itself cannot publish as a user account and cannot bypass Wikipedia's edit authentication or CSRF controls.

## Server API vs browser

For editing, it uses the browser and Wikipedia's normal web edit endpoint, not a server-side API.

More specifically:

- No backend in this repo performs edit logic.
- No server receives user credentials.
- No server calls MediaWiki `action=edit`.
- The deployed page performs read-only API calls from browser JavaScript.
- The edit handoff is a browser-created HTML form POST to `en.wikipedia.org/w/index.php?action=submit`.

## Risks and limitations

- The edit is based on wikitext fetched earlier during scanning. If the article changed between scan and edit handoff, the generated `wpTextbox1` may be stale. The code detects only the local case where no replacement was made; conflict handling is left to Wikipedia.
- The fallback replacement path performs a broad string replacement over the full article wikitext. That is simpler but less precise than citation-block replacement.
- The `archive-date` insertion fallback checks for `archive-date` across the entire rewritten text, not only the affected citation. In edge cases, this can prevent insertion where another citation already has an archive date.
- Because this is a cross-site form handoff, final authentication and edit-token handling are controlled by Wikipedia after the browser navigates there, not by this tool.

