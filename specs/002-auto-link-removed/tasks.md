# Tasks: Auto Link Removed Replacement

**Input**: Design documents from `/specs/002-auto-link-removed/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/ui-url-contract.md, quickstart.md

**Tests**: No separate automated test scaffold requested. Validation is the lightweight repository check plus browser scenarios from quickstart.md.

**Organization**: Minimum task list grouped by user story so each story can be implemented and validated independently.

## Phase 1: Setup

**Purpose**: Confirm the existing static SPA surface before implementation.

- [X] T001 Confirm `index.html`, `requirements.txt`, `runtime.txt`, `pyproject.toml`, and `.github/workflows/validate.yml` still match the no-new-dependencies plan

---

## Phase 2: Foundational

**Purpose**: Add the shared parsing and generated-replacement state used by all stories.

- [X] T002 Implement shared bracketed external-link parsing, `{{Link removed}}` generation, and generated-vs-manual replacement state helpers in `index.html`

**Checkpoint**: Foundation ready - user story implementation can begin.

---

## Phase 3: User Story 1 - Auto-Fill Replacement From Find Wikitext (Priority: P1) MVP

**Goal**: Generate a `{{Link removed}}` replacement when the find field loses focus with supported bracketed external-link wikitext.

**Independent Test**: Paste the example find wikitext, blur the find field, and confirm the expected replacement template appears without starting a page search.

- [X] T003 [US1] Wire find-field `onBlur` auto-generation, status feedback, protocol handling, and manual-edit preservation in `index.html`

**Checkpoint**: User Story 1 is independently functional.

---

## Phase 4: User Story 2 - Leave Unsupported Find Text Alone (Priority: P2)

**Goal**: Ensure unsupported or malformed find text never overwrites a replacement value.

**Independent Test**: Enter plain text, malformed bracketed text, and multiple links; blur the find field and confirm replacement text remains unchanged.

- [X] T004 [US2] Handle unsupported find values and non-blocking unsupported-status feedback in `index.html`

**Checkpoint**: User Stories 1 and 2 are independently functional.

---

## Phase 5: User Story 3 - Pre-Fill From URL Parameters (Priority: P3)

**Goal**: Pre-fill site, page, and find from URL parameters and auto-generate replacement when the find value is supported.

**Independent Test**: Open the documented prefill URL and confirm site `en`, page `Pamela Liversidge`, decoded find wikitext, and generated replacement are populated.

- [X] T005 [US3] Implement `site`, `page`, and encoded `find` URL prefill behavior with page underscore conversion in `index.html`

**Checkpoint**: All user stories are independently functional.

---

## Phase 6: Polish & Validation

**Purpose**: Run the documented validation path and keep the existing replacement workflow intact.

- [X] T006 Validate quickstart scenarios and repository checks from `specs/002-auto-link-removed/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies.
- **Foundational (Phase 2)**: Depends on Setup completion.
- **User Stories (Phases 3-5)**: Depend on Foundational completion.
- **Polish & Validation (Phase 6)**: Depends on all implemented user stories.

### User Story Dependencies

- **User Story 1 (P1)**: Starts after Foundation and is the MVP.
- **User Story 2 (P2)**: Starts after Foundation; may be done after US1 to verify unsupported values do not disturb generated/manual state.
- **User Story 3 (P3)**: Starts after Foundation; benefits from US1 generation helpers for prefilled find values.

### Parallel Opportunities

- This minimum list intentionally has no parallel story tasks because all implementation touches `index.html`.

---

## Implementation Strategy

### MVP First

1. Complete T001 and T002.
2. Complete T003 for User Story 1.
3. Validate the blur-to-template example before continuing.

### Incremental Delivery

1. Add US1 auto-generation.
2. Add US2 unsupported/manual preservation behavior.
3. Add US3 URL prefill behavior.
4. Run T006 once all desired stories are complete.
