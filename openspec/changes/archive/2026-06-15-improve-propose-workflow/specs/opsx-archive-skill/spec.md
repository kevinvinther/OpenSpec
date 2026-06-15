## ADDED Requirements

### Requirement: Supersession Notice Injection

After archiving a change, the skill SHALL read the `## Supersedes` section of the newly archived `proposal.md` and prepend a superseded-by notice to each named prior archived change's `proposal.md`.

#### Scenario: Superseded changes found

- **WHEN** the archived `proposal.md` contains a `## Supersedes` section with one or more entries
- **THEN** for each entry the skill locates the named archived change's `proposal.md`
- **AND** prepends the following notice at the very top of that file, above any existing content:

  ```
  > ⚠️ **Superseded by [`<new-change-name>`](<relative-link>)** (archived <YYYY-MM-DD>)
  >
  > <description from the Supersedes entry>

  ---
  ```

- **AND** if that archived change was previously superseded, the new notice appears above the existing notices

#### Scenario: Supersedes section is absent or None

- **WHEN** the archived `proposal.md` has no `## Supersedes` section, or the section contains only "None."
- **THEN** the skill skips supersession notice injection entirely

#### Scenario: Named archived change not found

- **WHEN** a change listed in `## Supersedes` cannot be located in the archive directory
- **THEN** the skill logs a warning identifying the missing entry
- **AND** continues with the remaining entries
- **AND** does NOT fail the archive operation
