# Improve Propose Workflow

## Supersedes

None.

## Why

The `/opsx:propose` skill created artifacts directly from a raw developer description. Agents made assumptions about intent, data shape, and existing patterns instead of discovering ground truth from the codebase and the developer. The resulting proposals reflected what the developer typed, not what the codebase actually needed. An interview-first approach closes this gap: every ambiguity is resolved before a single artifact is written.

Additionally, when a new change supersedes prior archived decisions, there was no record in the old proposal connecting the two. Readers navigating the archive had no way to follow the chain forward.

## What Changes

- **BREAKING** `/opsx:propose` now runs four structured phases before writing any artifact:
  - *Phase 1 — Orient*: reads the codebase and archived prior art, identifies which archived changes this new change may supersede, builds an internal open-questions set
  - *Phase 2 — Interview*: works through the set one question at a time with a guess attached, reads more code mid-interview when an answer points to unread areas, branches when answers open new questions, closes branches when answers make questions irrelevant
  - *Phase 3 — Confirm*: restates a structured summary and requires an explicit yes before proceeding
  - *Phase 4 — Artifact Creation*: same artifact generation as before, fed by confirmed intent and codebase context; `proposal.md` now always includes a `## Supersedes` section
- Stop condition changed from confidence level to **empty open-questions set**
- Skill and command templates now share a single INSTRUCTIONS constant to eliminate drift
- `/opsx:archive` gains a supersession tracking step: reads the `## Supersedes` section of the newly archived `proposal.md`, and prepends a superseded-by blockquote notice to each named archived change's `proposal.md`. Missing targets log a warning but do not fail the archive.
- `docs/guide.md` added — a user-facing guide covering installation, the spec hierarchy, and the propose workflow

## Capabilities

### New Capabilities

- `opsx-propose-skill`: The interview-first propose skill — phases, stop condition, question format, confirmation gate, and the required `## Supersedes` section in every proposal

### Modified Capabilities

- `opsx-archive-skill`: Adds supersession tracking as a new step after the change is moved to the archive directory

## Impact

- `src/core/templates/workflows/propose.ts`: Full rewrite of skill and command template content; shared INSTRUCTIONS constant introduced
- `src/core/templates/workflows/archive-change.ts`: New supersession tracking step added to the archive skill template
- `test/core/templates/skill-templates-parity.test.ts`: Hash values updated to match new template content
- `docs/guide.md`: New file
