# Implementation Plan: Auto Link Removed Replacement

**Branch**: `[current working tree]` | **Date**: 2026-06-19 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/002-auto-link-removed/spec.md`

## Summary

Enhance the existing static replacement shell so users can paste a single bracketed external-link wikitext value into the find field and have the replacement field auto-populated with a `{{Link removed}}` template when the find field loses focus. Add URL prefill support for `site`, `page`, and encoded `find` parameters so external workflows can open the shell with fields already populated. The feature remains entirely in `index.html`, uses no new dependencies, and preserves the existing search, preview, and Wikipedia handoff flow.

## Technical Context

**Language/Version**: HTML with inline React 18.2.0 JSX transformed by Babel standalone 7.23.9; Python 3.11 project metadata remains setup-only.

**Primary Dependencies**: Existing pinned browser CDN imports for React, ReactDOM, and Babel; no new browser or Python dependencies planned.

**Storage**: None. Generated replacement state, URL-prefilled fields, and manual edit state stay in transient browser state.

**Testing**: Lightweight local validation with browser scenarios, static source review, existing Python package metadata checks, and Python syntax checks when tracked Python files exist.

**Target Platform**: Toolforge-compatible static/minimal Python hosting and modern browsers with JavaScript enabled.

**Project Type**: Static React SPA in `index.html`.

**Performance Goals**: Supported find text generates replacement text within 5 seconds of leaving the find field; URL prefill happens on initial page load without requiring a page search.

**Constraints**: No server-side application logic, no new dependencies, no secrets, no credential collection, no direct edit publishing, no changes to Python setup files or CI unless validation reveals a concrete need.

**Scale/Scope**: One bracketed external link at a time; canonical URL prefill parameters are `site`, `page`, and `find`; page values use underscores for spaces in URLs; find values are URL-encoded.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- Static SPA: PASS. The feature updates the existing browser React behavior in `index.html` only.
- Toolforge compatibility: PASS. No secrets, background services, unavailable Toolforge services, or publishing automation are introduced.
- Minimal dependencies: PASS. Existing pinned browser imports remain sufficient.
- Client-side safety/accessibility: PASS. The feature parses user-entered text locally, preserves manual edits, and requires visible non-blocking feedback.
- Lightweight validation: PASS. Validation is limited to existing repository checks and focused browser scenarios.

## Project Structure

### Documentation (this feature)

```text
specs/002-auto-link-removed/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── ui-url-contract.md
└── checklists/
    └── requirements.md
```

### Source Code (repository root)

```text
index.html                 # Existing static React SPA entry point and feature implementation
requirements.txt           # Existing empty Python runtime dependency list
runtime.txt                # Existing Toolforge/Python runtime hint
pyproject.toml             # Existing project metadata
.github/workflows/
└── validate.yml           # Existing lightweight Python/package validation
```

**Structure Decision**: Implement the feature in `index.html` only. Do not introduce a build system, backend, package manager, new tests framework, or new source directory for this focused enhancement.

## Complexity Tracking

No constitution violations. No complexity exceptions are required.

## Phase 0 Research Summary

See [research.md](./research.md) for resolved decisions. Key outcomes:

- Parse only one full bracketed external-link wikitext value.
- Generate `{{Link removed|label|linkhostpath=...|protocol=...}}`.
- Preserve manual replacement edits by tracking whether the existing replacement is empty, generated, or user-edited.
- Use canonical query parameters `site`, `page`, and `find`.
- Keep URL encoding/decoding entirely client-side and dependency-free.

## Phase 1 Design Summary

See [data-model.md](./data-model.md) for transient entities, [contracts/ui-url-contract.md](./contracts/ui-url-contract.md) for form and URL behavior contracts, and [quickstart.md](./quickstart.md) for validation scenarios.

## Post-Design Constitution Check

- Static SPA: PASS. Design artifacts keep all feature behavior in `index.html`.
- Toolforge compatibility: PASS. URL prefill and auto-generation are local browser behavior with no secrets or services.
- Minimal dependencies: PASS. No new browser CDN imports or Python dependencies are required.
- Client-side safety/accessibility: PASS. UI contract requires visible labels, keyboard-compatible blur behavior, and status feedback.
- Lightweight validation: PASS. Quickstart uses existing repository validation plus focused manual browser scenarios.
