<!--
Sync Impact Report
Version change: template -> 1.0.0
Modified principles:
- Placeholder Principle 1 -> I. Static React SPA Surface
- Placeholder Principle 2 -> II. Toolforge-Compatible Deployment
- Placeholder Principle 3 -> III. Minimal Dependencies
- Placeholder Principle 4 -> IV. Client-Side Safety and Accessibility
- Placeholder Principle 5 -> V. Lightweight Validation
Added sections:
- Technical Boundaries
- Development Workflow
Removed sections:
- None
Templates requiring updates:
- ✅ .specify/templates/plan-template.md
- ✅ .specify/templates/spec-template.md
- ✅ .specify/templates/tasks-template.md
- ✅ .specify/templates/commands/*.md (no command templates present)
Runtime guidance reviewed:
- ✅ AGENTS.md
Follow-up TODOs:
- None
-->
# Link Remover Constitution

## Core Principles

### I. Static React SPA Surface
The application MUST remain a single-page React interface served from static
files unless a feature specification justifies server-side code. The primary
entry point MUST be `index.html`, and browser-loaded dependencies MUST be
visible in that file or in explicit static assets referenced by it.

Rationale: The current page is a small React SPA using CDN script imports and an
inline Babel script. Keeping the surface static preserves simple deployment and
keeps future feature work easy to audit.

### II. Toolforge-Compatible Deployment
The project MUST stay deployable as a Toolforge-style static or minimal Python
project with no required secrets, OAuth credentials, background workers, or
publishing automation in the repository. Runtime files such as `runtime.txt`,
`requirements.txt`, and GitHub Actions workflows MUST remain lightweight and
must not imply unavailable Toolforge services.

Rationale: Toolforge deployment favors explicit runtime assumptions and avoids
credential-bearing automation in source control.

### III. Minimal Dependencies
New dependencies MUST be added only when they are required by a specified user
story or validation gate. Browser CDN imports MUST use pinned versions. Python
runtime dependencies MUST be recorded in `requirements.txt`; project metadata
MUST remain in `pyproject.toml` when package metadata is needed.

Rationale: The current project has no external Python runtime dependencies and
uses pinned React, ReactDOM, and Babel CDN imports. Minimal dependencies reduce
maintenance and deployment risk.

### IV. Client-Side Safety and Accessibility
Features MUST run without collecting secrets or private credentials in the
client. User-facing changes MUST preserve semantic HTML, keyboard access for
interactive controls, readable text, and clear status or error feedback when a
user action can fail.

Rationale: A static client is easy to inspect but also exposes all shipped code.
Accessible, credential-free behavior keeps the app safe for public hosting.

### V. Lightweight Validation
Every change MUST keep the repository passing its lightweight validation path:
dependency installation, Python syntax checks when Python files exist, package
metadata checks, and any static checks added for browser assets. Tests or lint
tools MUST be introduced only when they validate real project behavior or
protect a repeated maintenance task.

Rationale: This project has no build step and little runtime surface. Validation
must catch regressions without adding ceremony that exceeds the app's size.

## Technical Boundaries

The app is a React SPA loaded from `index.html` with pinned browser script
imports for React 18.2.0, ReactDOM 18.2.0, and Babel standalone 7.23.9. Feature
plans MUST treat this as the default architecture.

Python files are allowed for local setup, Toolforge compatibility, or small
support utilities. Python application services, scheduled jobs, network
scanners, database layers, and credentialed integrations require an explicit
feature specification and constitution check justification before introduction.

The repository MUST NOT include deployment secrets, OAuth credentials,
Wikipedia credentials, or automated publishing workflows.

## Development Workflow

Specifications MUST identify whether a change affects static HTML, browser
React behavior, Python setup files, or CI automation. Implementation plans MUST
document the dependency impact and Toolforge compatibility impact before work
begins.

Tasks MUST be organized so the static page remains usable after each completed
user story. Changes to `index.html`, dependency files, and GitHub Actions MUST
include a validation task that can be run locally or by CI.

## Governance

This constitution supersedes conflicting project guidance. Amendments require a
documented reason, a semantic version update, and a review of the Spec Kit
templates that generate plans, specifications, and tasks.

Versioning policy:
- MAJOR: Removes or redefines a core principle or permits a non-static default
  architecture.
- MINOR: Adds a principle, section, mandatory workflow gate, or new deployment
  constraint.
- PATCH: Clarifies wording without changing obligations.

Compliance review MUST occur during planning and again before implementation is
considered complete. Any violation MUST be listed with a simpler alternative and
the reason the alternative was rejected.

**Version**: 1.0.0 | **Ratified**: 2026-06-19 | **Last Amended**: 2026-06-19
