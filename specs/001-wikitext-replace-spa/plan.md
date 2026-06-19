# Implementation Plan: Wikitext Replacement Shell

**Branch**: `[current working tree]` | **Date**: 2026-06-19 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/001-wikitext-replace-spa/spec.md`

## Summary

Build the current `index.html` placeholder into a static React SPA that lets a Wikipedia editor choose `en` or `test`, enter a page title, enter exact find wikitext, enter replacement wikitext, retrieve the selected page's current source through public read-only Wikipedia access, preview the exact replacement result, and hand off the modified wikitext to the selected Wikipedia site's normal edit review flow. The feature stays entirely browser-side, keeps the existing pinned React/ReactDOM/Babel CDN imports, and does not collect credentials or publish edits directly.

## Technical Context

**Language/Version**: HTML with inline React 18.2.0 JSX transformed by Babel standalone 7.23.9; Python 3.11 project metadata remains setup-only.

**Primary Dependencies**: Existing pinned browser CDN imports for React, ReactDOM, and Babel; no new browser or Python dependencies planned.

**Storage**: None. User inputs, fetched wikitext, preview state, and handoff state are transient browser state only.

**Testing**: Lightweight local validation with browser manual scenarios, static source review, existing Python package metadata checks, and Python syntax checks when tracked Python files exist.

**Target Platform**: Toolforge-compatible static/minimal Python hosting and modern desktop/mobile browsers with JavaScript enabled.

**Project Type**: Static React SPA in `index.html` with existing Toolforge-style metadata files.

**Performance Goals**: For normally retrievable pages, users can reach a reviewable proposed change in under 2 minutes; exact-match counting remains responsive for typical article wikitext.

**Constraints**: No server-side application logic, no deployment secrets, no Wikipedia credentials, no OAuth or bot-password handling, no automated publishing, no new dependencies unless later justified.

**Scale/Scope**: One page per replacement workflow, two selectable Wikipedia sites (`en` and `test`), exact literal wikitext replacement only, no regular expressions, batch editing, or multi-page workflows.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- Static SPA: PASS. The plan keeps `index.html` as the primary entry point and implements the workflow in browser React only.
- Toolforge compatibility: PASS. The plan uses static browser behavior, public read-only retrieval, and Wikipedia's normal browser edit review flow without repository secrets or unavailable services.
- Minimal dependencies: PASS. No new dependencies are planned; existing browser imports are already pinned.
- Client-side safety/accessibility: PASS. The workflow avoids credential collection and requires semantic form controls, keyboard access, and clear loading/error/review status.
- Lightweight validation: PASS. Validation uses the existing Python checks plus focused browser/manual scenarios for the changed static page.

## Project Structure

### Documentation (this feature)

```text
specs/001-wikitext-replace-spa/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── ui-workflow.md
└── checklists/
    └── requirements.md
```

### Source Code (repository root)

```text
index.html                 # Static React SPA entry point and feature implementation
requirements.txt           # Existing empty Python runtime dependency list
runtime.txt                # Existing Toolforge/Python runtime hint
pyproject.toml             # Existing project metadata
.github/workflows/
└── validate.yml           # Existing lightweight Python/package validation
```

**Structure Decision**: Implement the feature inside the existing static SPA surface in `index.html`. Keep support files unchanged unless validation reveals a real need. Do not introduce `src/`, backend, build tooling, or a test framework for this first shell feature.

## Complexity Tracking

No constitution violations. No complexity exceptions are required.

## Phase 0 Research Summary

See [research.md](./research.md) for resolved decisions. Key outcomes:

- Use one browser-only React surface in `index.html`.
- Use selected-site public read-only Wikipedia page source retrieval.
- Treat replacement as literal exact text replacement with preview and count.
- Hand off to Wikipedia's normal edit review flow for the selected site.
- Keep validation lightweight and proportional to the static page.

## Phase 1 Design Summary

See [data-model.md](./data-model.md) for transient entities and state transitions, [contracts/ui-workflow.md](./contracts/ui-workflow.md) for UI behavior contracts, and [quickstart.md](./quickstart.md) for validation scenarios.

## Post-Design Constitution Check

- Static SPA: PASS. Design artifacts keep all feature behavior in `index.html`.
- Toolforge compatibility: PASS. No secrets, server processes, storage layers, background workers, or publishing automation are introduced.
- Minimal dependencies: PASS. Contracts and quickstart assume existing pinned browser imports only.
- Client-side safety/accessibility: PASS. UI contract requires labels, keyboard-accessible controls, status messages, and no credential prompts.
- Lightweight validation: PASS. Quickstart uses existing repository checks and focused browser scenarios instead of adding ceremony.
