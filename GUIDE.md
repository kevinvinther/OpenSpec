# Guide

This is a fork of [OpenSpec](https://github.com/Fission-AI/OpenSpec). Telemetry and the public feedback command have been removed. Two features have been added: hierarchical spec structures and an interview-first proposal workflow.

---

## Installation

Clone and install globally from source:

```bash
git clone git@github.com:kevinvinther/OpenSpec.git
cd OpenSpec
npm install
npm run build
npm install -g .
```

Verify:

```bash
openspec --version
```

---

## Initialising a project

```bash
cd your-project
openspec init
```

Follow the prompts to select your AI tool (Claude Code, Cursor, Windsurf, etc.). This creates the `openspec/` directory and installs the skill files for your chosen tool.

---

## Core workflow

```
/opsx:propose  →  /opsx:apply  →  /opsx:sync  →  /opsx:archive
```

| Command         | What it does                                                  |
| --------------- | ------------------------------------------------------------- |
| `/opsx:propose` | Interviews you, reads the codebase, then writes the artifacts |
| `/opsx:apply`   | Implements the tasks from `tasks.md`                          |
| `/opsx:sync`    | Merges delta specs back into the main `specs/`                |
| `/opsx:archive` | Archives the completed change                                 |

---

## Artifact Handoff

If you wish to continue the work of a refined artifact, use the script in `scripts/new-change-from-artifact.sh`.

**Usage**:
In the root level of the repository folder in which you want to create the OpenSpec change:

1. Create a folder containing the artifact: `descriptive-name/propose.md`, `descriptive-name/tasks.md`, etc.

```
❯ tree descriptive-name
descriptive-name
├── design.md
├── proposal.md
├── specs
│   └── descriptive-spec
│   └── spec.md
└── tasks.md

3 directories, 4 files
```

1. Run the script with the folder as argument: `$ScriptLocation/new-change-from-artifact.sh descriptive-name`

```
❯ ~/Projects/OpenSpec/scripts/new-change-from-artifact.sh descriptive-name
==> Creating change 'descriptive-name'...
Created change 'descriptive-name' at openspec/changes/descriptive-name/
Schema: spec-driven
==> Copying files from /Users/user/Projects/project-name/descriptive-name...

==> Status...
Change: descriptive-name
Schema: spec-driven
Planning home: repo
Change root: /Users/user/Projects/project-name/openspec/changes/descriptive-name
Progress: 3/4 artifacts complete

[x] proposal
[x] design
[ ] specs
[x] tasks

==> Validating...
Change 'descriptive-name' has issues
✗ [ERROR] file: Change must have at least one delta. No deltas found. Ensure your change has a specs/ directory with capability folders (e.g. specs/http-server/spec.md) containing .md files that use delta headers (## ADDED/MODIFIED/REMOVED/RENAMED Requirements) and that each requirement includes at least one "#### Scenario:" block. Tip: run "openspec change show <change-id> --json --deltas-only" to inspect parsed deltas.
Next steps:

- Ensure change has deltas in specs/: use headers ## ADDED/MODIFIED/REMOVED/RENAMED Requirements
- Each requirement MUST include at least one #### Scenario: block
- Debug parsed deltas: openspec change show <id> --json --deltas-only
```

1. Profit!

As you can see, this will also validate the spec.

---

## Hierarchical specs

Specs can be organised in nested directories to reflect your domain structure. OpenSpec auto-detects whether a project is using flat or hierarchical layout.

**Flat** (default for small projects):

```
openspec/specs/
  auth/spec.md
  payments/spec.md
  notifications/spec.md
```

**Hierarchical** (for larger codebases):

```
openspec/specs/
  platform/
    auth/spec.md
    payments/spec.md
  frontend/
    components/spec.md
  _global/
    security/spec.md
    monitoring/spec.md
```

Delta specs inside a change mirror the same structure:

```
openspec/changes/add-payment-retry/
  specs/
    platform/
      payments/spec.md   ← mirrors openspec/specs/platform/payments/
```

### Configuration

Control the behaviour in `openspec/config.yaml` (or via `openspec config`):

```yaml
specStructure:
  structure: auto # auto | flat | hierarchical
  maxDepth: 4 # maximum nesting depth (default: 4)
  allowMixed: true # allow mixing flat and hierarchical
  validatePaths: true # enforce naming conventions
```

`auto` (the default) detects the structure from what already exists in `specs/`. Set it explicitly if you want to enforce one style.

### Naming conventions

- Use lowercase kebab-case for directory names: `payment-processing/`, not `PaymentProcessing/`
- Prefix cross-cutting concerns with `_`: `_global/`, `_shared/`
- Keep names meaningful to the domain, not the technology (`auth/` not `jwt/`)

For migration from flat to hierarchical, see [`migration-flat-to-hierarchical.md`](migration-flat-to-hierarchical.md).

---

## The propose workflow

`/opsx:propose` is the main entry point for new changes. It does not generate artifacts immediately — it interviews you first.

### What to expect

1. **You give it anything** — a ticket title, a one-liner, a rough idea. There is no minimum.

2. **It reads the codebase** before asking you anything. Questions the code can answer will not be asked.

3. **It interviews you** — one question at a time, each with its best guess attached. Answer the guess if it is right, correct it if it is wrong.

4. **Answers branch the interview.** A simple answer closes questions; a complex one opens new ones. The interview is not a fixed list — it follows the conversation.

5. **It confirms** what it understood with a structured summary before writing a single file. You can correct anything at this point.

6. **Only then does it write the artifacts** — fed by everything established in the interview and the codebase read.

### Example

```
You: add an expiry date to subscriptions

AI: [reads src/models/subscription.ts, src/api/subscriptions/, openspec/changes/archive/]

HYPOTHESIS: You want to add a field to the Subscription model that records
when the subscription expires, so the system can enforce access limits.

Q: Is expiry something the system enforces automatically (e.g. blocks access
   when expired), or is it informational only (just stored and displayed)?
GUESS: enforced — otherwise there's no reason to add it now.
```

### Tips

- The shorter your initial input, the more questions you will get. That is by design.
- If an answer opens a large new area ("oh, it also needs to send a reminder email"), expect a new wave of questions about that area.
- The confirm step is real — read the summary and push back on anything that is not right. It is much cheaper to correct here than after the artifacts are written.

---

## Keeping skills up to date

After pulling new changes from this repository:

```bash
npm run build
npm install -g .
openspec update
```

`openspec update` regenerates the skill files in your project from the latest templates.
