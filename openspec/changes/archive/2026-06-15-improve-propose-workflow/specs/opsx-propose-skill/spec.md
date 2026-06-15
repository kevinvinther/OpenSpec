# opsx-propose-skill Specification

## Purpose

Define the expected behavior of the `/opsx:propose` skill — an interview-first workflow that resolves all ambiguity about a change before writing any OpenSpec artifact.

## Requirements

### Requirement: Codebase Read Before Interview

The skill SHALL read the relevant parts of the codebase and scan archived prior art before asking the developer any questions.

#### Scenario: Codebase read on initial ask

- **WHEN** the developer provides an initial description
- **THEN** the skill reads affected models, schemas, services, tests, and conventions before forming any question
- **AND** scans `openspec/changes/archive/` for prior changes touching the same subsystem
- **AND** does NOT ask questions that code reading already answers

#### Scenario: Mid-interview code read

- **WHEN** a developer's answer points to code the skill has not yet read
- **THEN** the skill reads that code before continuing
- **AND** may open new questions or close existing ones based on what it finds

### Requirement: Open-Questions Interview

The skill SHALL maintain an internal set of open questions and work through them one at a time until the set is empty.

#### Scenario: One question per turn

- **WHEN** open questions remain
- **THEN** the skill asks exactly one question per turn
- **AND** attaches its best guess with reasoning to every question
- **AND** does NOT batch multiple questions together

#### Scenario: Branching on complex answers

- **WHEN** a developer's answer introduces complexity not previously anticipated
- **THEN** the skill opens new questions for the newly surfaced concerns
- **AND** does NOT move on before those questions are answered

#### Scenario: Closing irrelevant branches

- **WHEN** a developer's answer makes other open questions irrelevant
- **THEN** the skill closes those questions without asking them

#### Scenario: Stop condition

- **WHEN** the open-questions set is empty
- **AND** the last answer generated no new questions
- **THEN** the skill proceeds to confirmation
- **AND** does NOT stop before the set is empty

### Requirement: Explicit Confirmation Gate

The skill SHALL present a structured summary of confirmed intent and require an explicit yes before writing any artifact.

#### Scenario: Confirmation summary

- **WHEN** the open-questions set is empty
- **THEN** the skill restates what it understands across relevant dimensions (what, why, who, data, interface, logic, supersedes, out of scope)
- **AND** asks "Anything wrong or missing?"

#### Scenario: Explicit yes required

- **WHEN** the developer responds with an ambiguous confirmation ("sounds good", "whatever you think", silence)
- **THEN** the skill asks a follow-up to obtain an explicit yes or surface corrections
- **AND** does NOT proceed to artifact creation until an explicit yes is given

#### Scenario: Corrections folded in

- **WHEN** the developer provides corrections to the summary
- **THEN** the skill updates the summary and presents it again
- **AND** repeats until an explicit yes is given

### Requirement: Supersedes Section in Proposal

Every `proposal.md` created by the skill SHALL include a `## Supersedes` section.

#### Scenario: Change supersedes prior archived changes

- **WHEN** the skill identifies archived changes that this new change wholly or partly replaces
- **THEN** the `proposal.md` includes a `## Supersedes` section listing each archived change directory name and a one-sentence description of what was replaced

#### Scenario: No prior changes superseded

- **WHEN** no archived changes are superseded
- **THEN** the `proposal.md` includes a `## Supersedes` section containing only "None."

### Requirement: Artifact Creation After Confirmation

The skill SHALL create all required OpenSpec artifacts only after explicit developer confirmation.

#### Scenario: Artifact creation order

- **WHEN** the developer confirms the summary
- **THEN** the skill creates a change with `openspec new change "<name>"`
- **AND** creates artifacts in dependency order using `openspec instructions` for each
- **AND** feeds confirmed intent and codebase findings into each artifact

#### Scenario: No fast path

- **WHEN** the developer provides a detailed initial description
- **THEN** the skill still runs the codebase read and interview phases
- **AND** does NOT skip to artifact creation without explicit confirmation
