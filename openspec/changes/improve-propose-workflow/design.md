# Design: Improve Propose Workflow

## Context

The existing `/opsx:propose` skill generates OpenSpec artifacts directly from whatever the developer types. This works for well-specified requests but produces weak proposals when the ask is vague, incomplete, or when the developer doesn't know what's already in the codebase. The result is proposals that reflect the developer's initial framing rather than the actual problem.

The archive skill has no mechanism to link a newly archived change back to older changes it replaces. The archive accumulates over time but readers cannot tell when a decision has been superseded without reading every proposal.

## Goals / Non-Goals

**Goals:**
- Replace the direct-artifact approach in `/opsx:propose` with an interview-first flow that resolves all ambiguity before writing
- Establish a formal stop condition (empty open-questions set) rather than a subjective confidence level
- Add a `## Supersedes` section to every proposal so the archive skill can trace replacement chains
- Add supersession notice injection to `/opsx:archive` so prior proposals are annotated when superseded
- Eliminate the skill/command template content duplication that caused them to drift

**Non-Goals:**
- Changes to any other OPSX skills (apply, sync, verify, onboard)
- Changes to CLI commands or their options
- Automated detection of which changes are superseded — this is always a judgment call by the agent

## Decisions

### Interview stop condition: empty set over confidence

The old approach used a confidence number (e.g. "85% confident"). Confidence is subjective and gameable — an agent can declare high confidence to skip questions. An open-questions set is concrete: either a question remains or it doesn't. The set is seeded from the initial ask and codebase read, grows when answers reveal new complexity, and shrinks as questions are answered. The interview ends only when it is empty and the last answer generated no new questions.

### Codebase read before the first question

Reading the codebase before asking eliminates questions that code already answers. An agent that asks "what framework are you using?" when it could just read `package.json` is wasting the developer's time. Reading first also means questions are grounded in what actually exists, not in generic checklists.

### Shared INSTRUCTIONS constant

The skill template (written to `.github/skills/`) and the command template (written to `.github/prompts/`) had nearly identical instruction blocks maintained separately. Drift was inevitable. A single `INSTRUCTIONS` constant assembled once and embedded in both eliminates the duplication.

### Supersession notices are prepended, not appended

If a change is superseded multiple times, the most recent notice should appear first. Prepending each new notice keeps the chain in reverse-chronological order, which is the most useful reading order when navigating the archive.

### Missing supersession targets log a warning, not an error

The archive should not fail because a listed archived change has been renamed or deleted. A warning is sufficient — the developer can investigate if needed.

## Risks / Trade-offs

- **Longer propose sessions**: The interview adds turns before any artifact is written. This is intentional — the tradeoff is fewer revisions after the fact.
- **Agent discipline required**: The interview quality depends on the agent actually reading code and formulating grounded questions. The skill instructions enforce this but cannot prevent an agent from skimming.
- **Supersedes section is manual**: The agent must identify which prior changes are superseded. If it misses one, the archive chain is incomplete. This is a judgment call that cannot be fully automated.
