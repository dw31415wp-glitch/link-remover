# Tasks: Wikitext Replacement Shell

**Input**: Design documents from `specs/001-wikitext-replace-spa/`

**Prerequisites**: [plan.md](./plan.md), [spec.md](./spec.md), [research.md](./research.md), [data-model.md](./data-model.md), [contracts/ui-workflow.md](./contracts/ui-workflow.md), [quickstart.md](./quickstart.md)

**Tests**: No automated test framework is requested for this feature. Validation tasks use the lightweight repository checks and manual browser scenarios from `quickstart.md`.

**Organization**: Tasks are grouped by user story so the MVP and later increments remain independently demonstrable.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Confirm the current static SPA surface and validation baseline before feature work starts.

- [X] T001 Confirm `index.html` still contains pinned React 18.2.0, ReactDOM 18.2.0, and Babel standalone 7.23.9 CDN imports with no new dependency requirement.
- [X] T002 Confirm `requirements.txt`, `pyproject.toml`, and `.github/workflows/validate.yml` remain compatible with the no-new-dependencies plan.
- [X] T003 [P] Review `specs/001-wikitext-replace-spa/contracts/ui-workflow.md` and `specs/001-wikitext-replace-spa/data-model.md` before editing `index.html`.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish shared SPA structure, state, constants, and helpers required by all user stories.

**CRITICAL**: No user story implementation should begin until this phase is complete.

- [X] T004 Replace the placeholder React render in `index.html` with a semantic single-page shell containing a `<main>` region and form sections for the workflow.
- [X] T005 Add responsive CSS in `index.html` for the shell layout, labels, inputs, textareas, action buttons, status messages, preview blocks, and disabled states.
- [X] T006 Define supported site metadata for `en` and `test` in `index.html`, including labels and derived hosts for retrieval and handoff.
- [X] T007 Add shared React state in `index.html` for selected site, page title, find wikitext, replacement wikitext, retrieved page text, match result, status, and message text.
- [X] T008 Add shared helper functions in `index.html` for parsing page titles, deriving selected-site URLs, replacing exact literal wikitext, counting matches, and resetting stale preview state after input changes.

**Checkpoint**: Foundation ready; user story implementation can now begin.

---

## Phase 3: User Story 1 - Prepare a Targeted Wikitext Replacement (Priority: P1) MVP

**Goal**: A user can select `en` or `test`, enter a page, enter find wikitext, enter replacement wikitext, retrieve page source, and prepare a replacement result.

**Independent Test**: Select either supported site, enter a page and exact find/replacement values, start the search, and confirm the shell reports whether a replacement can be prepared without clearing inputs.

### Implementation for User Story 1

- [X] T009 [US1] Add the Wikipedia site dropdown to `index.html` with exactly `en` and `test` options and default state set to `en`.
- [X] T010 [US1] Add labeled Page, Find wikitext, and Replace wikitext controls to `index.html`, using multiline controls for both wikitext fields.
- [X] T011 [US1] Implement required-input validation in `index.html` for selected site, page title, and find wikitext before any page retrieval begins.
- [X] T012 [US1] Implement selected-site public page wikitext retrieval in `index.html` for the normalized page title, with loading and retrieval-error states.
- [X] T013 [US1] Implement exact literal match counting and replacement preparation in `index.html`, including support for multiline find and replacement values.
- [X] T014 [US1] Preserve selected site, page title, find wikitext, and replacement wikitext in `index.html` after validation errors, no-match results, and retrieval failures.
- [X] T015 [US1] Add clear empty-replacement messaging in `index.html` so a blank replacement is presented as intentional removal before review.
- [X] T016 [US1] Manually validate User Story 1 with `specs/001-wikitext-replace-spa/quickstart.md` scenarios 1, 2, and 4.

**Checkpoint**: User Story 1 is fully functional and independently testable as the MVP.

---

## Phase 4: User Story 2 - Review the Proposed Change Before Wikipedia Handoff (Priority: P2)

**Goal**: A user can review the replacement count and before/after content before any Wikipedia handoff is available.

**Independent Test**: Prepare a replacement and verify the shell shows the match count, original matched content, replacement content, no-match state, and recoverable errors without offering handoff too early.

### Implementation for User Story 2

- [X] T017 [US2] Add a review panel in `index.html` that displays replacement count, selected site, normalized page title, find wikitext, and replacement wikitext after a successful match.
- [X] T018 [US2] Add readable before-and-after preview blocks in `index.html` for the matched source text and proposed replacement text.
- [X] T019 [US2] Implement the no-match review state in `index.html` so no handoff action is available when exact find wikitext is absent.
- [X] T020 [US2] Implement recoverable validation, loading, retrieval-error, no-match, and ready-for-review status messages in `index.html` without relying on color alone.
- [X] T021 [US2] Add the representative Pamela Liversidge example as non-intrusive helper text or sample-fill affordance in `index.html`, matching the exact values in `specs/001-wikitext-replace-spa/spec.md`.
- [X] T022 [US2] Manually validate User Story 2 with `specs/001-wikitext-replace-spa/quickstart.md` scenarios 1, 3, and 4.

**Checkpoint**: User Stories 1 and 2 work independently; users can stop safely after preview.

---

## Phase 5: User Story 3 - Open Wikipedia's Edit Review Flow (Priority: P3)

**Goal**: A user can send reviewed modified wikitext to the selected Wikipedia site's normal edit review flow without the shell collecting credentials or claiming to save edits.

**Independent Test**: Prepare a valid replacement, choose Continue to Wikipedia, and confirm the selected site's edit review flow opens for the target page while the shell explains that Wikipedia handles authentication, diff review, conflicts, and saving.

### Implementation for User Story 3

- [X] T023 [US3] Add a Continue to Wikipedia action in `index.html` that is disabled or hidden until a nonzero match result is ready for review.
- [X] T024 [US3] Implement selected-site edit review handoff in `index.html` by submitting the reviewed updated wikitext to the selected Wikipedia host for the normalized page title.
- [X] T025 [US3] Include a concise edit summary in the `index.html` handoff that describes the wikitext replacement without claiming automated publishing.
- [X] T026 [US3] Add handoff status text in `index.html` explaining that Wikipedia handles login state, diff review, edit conflicts, and final saving.
- [X] T027 [US3] Verify `index.html` contains no username, password, OAuth, bot-password, private edit-token, or secret input controls.
- [X] T028 [US3] Manually validate User Story 3 with `specs/001-wikitext-replace-spa/quickstart.md` scenario 5 for both `en` and `test` when suitable pages are available.

**Checkpoint**: All user stories are independently functional and the shell never represents handoff as a saved edit.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Validate accessibility, static deployment fit, and documentation consistency across the completed feature.

- [X] T029 Review keyboard navigation, visible labels, disabled states, and status message placement in `index.html` against `specs/001-wikitext-replace-spa/contracts/ui-workflow.md`.
- [X] T030 Review `index.html` for unnecessary dependencies, server assumptions, credential handling, and any behavior that conflicts with `.specify/memory/constitution.md`.
- [X] T031 [P] Update `specs/001-wikitext-replace-spa/quickstart.md` if final control names or local validation steps differ from the implemented `index.html`.
- [ ] T032 Run the Python dependency install validation from `specs/001-wikitext-replace-spa/quickstart.md` in an isolated virtual environment if the system Python blocks direct pip installs.
- [ ] T033 Run the Python syntax and package metadata validation commands from `specs/001-wikitext-replace-spa/quickstart.md`.
- [ ] T034 Run all manual browser scenarios in `specs/001-wikitext-replace-spa/quickstart.md` from a local static server and record any deviations before completion.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; can start immediately.
- **Foundational (Phase 2)**: Depends on Setup completion and blocks all user stories.
- **User Story 1 (Phase 3)**: Depends on Foundational and is the MVP.
- **User Story 2 (Phase 4)**: Depends on Foundational; practically builds on the prepared match result from US1 but remains independently demonstrable through review states.
- **User Story 3 (Phase 5)**: Depends on Foundational and a ready-for-review match result; should be implemented after US2 so handoff is gated by review.
- **Polish (Phase 6)**: Depends on all desired user stories being complete.

### User Story Dependencies

- **US1 Prepare a Targeted Wikitext Replacement**: First story and suggested MVP.
- **US2 Review the Proposed Change Before Wikipedia Handoff**: Should follow US1 so preview uses real prepared replacement data.
- **US3 Open Wikipedia's Edit Review Flow**: Should follow US2 so handoff is only available after review.

### Parallel Opportunities

- T003 can run in parallel with T001 and T002 because it only reads design docs.
- After T004-T008 complete, documentation/source-review tasks that do not edit `index.html` can proceed alongside implementation review.
- Most implementation tasks intentionally touch `index.html`; keep them sequential to avoid same-file conflicts.
- T031 can run in parallel with T029 and T030 after final control names are known.

---

## Parallel Example: User Story Work

```text
Task: "Implement User Story 1 tasks T009-T015 sequentially in index.html"
Task: "Review specs/001-wikitext-replace-spa/contracts/ui-workflow.md against the in-progress controls"
Task: "Prepare quickstart.md updates if implemented control names differ from the planned wording"
```

Because this feature is a compact single-file SPA, parallelizing edits inside `index.html` is not recommended.

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 setup checks.
2. Complete Phase 2 foundational SPA structure, state, site metadata, and helper functions.
3. Complete Phase 3 tasks T009-T016.
4. Stop and validate US1 independently with quickstart scenarios 1, 2, and 4.
5. Demo the MVP before adding review and handoff behavior.

### Incremental Delivery

1. Deliver US1 so users can prepare exact replacements.
2. Add US2 so users can review counts, before/after content, and recoverable states.
3. Add US3 so reviewed replacements can open Wikipedia's normal edit review flow.
4. Complete polish tasks to verify accessibility, safety, and lightweight validation.

### Validation Gates

- No task should add new browser or Python dependencies without revisiting `specs/001-wikitext-replace-spa/plan.md`.
- No handoff task should introduce credential collection or direct publishing.
- Each story checkpoint should be manually validated before moving to the next priority story.

## Notes

- `[P]` means the task can run in parallel because it does not edit the same file as the surrounding implementation tasks.
- `[US1]`, `[US2]`, and `[US3]` map tasks to the prioritized user stories in `specs/001-wikitext-replace-spa/spec.md`.
- All implementation tasks use `index.html` because the plan keeps this feature in the existing static React SPA.
