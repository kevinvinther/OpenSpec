# Design: Remove Telemetry and Feedback Command

## Context

OpenSpec currently ships with PostHog analytics (via `posthog-node`) and a `feedback` command that opens GitHub issues in the public `Fission-AI/OpenSpec` repository. Both features are incompatible with enterprise deployment policies that prohibit outbound data transmission to third-party services and restrict CLI tooling from accessing public repositories on behalf of engineers.

The removal is a hard delete — no opt-out toggle, no configuration flag. The code, dependency, and tests are gone.

## Goals / Non-Goals

**Goals:**
- Remove all telemetry code paths so no data can be transmitted regardless of environment variables
- Remove the `feedback` command and its associated skill template
- Remove the `posthog-node` package from `package.json`
- Remove all associated tests

**Non-Goals:**
- Providing an alternative analytics mechanism
- Providing an alternative feedback path
- Migrating or exporting historical telemetry data

## Decisions

### Hard delete over feature flag

A configuration flag (`OPENSPEC_TELEMETRY=0`) already exists but is insufficient: the code, dependency, and test surface remain in the repo and create ongoing maintenance burden and audit friction for enterprise adopters. A full deletion removes the concern entirely.

### Delete tests alongside code

Tests for deleted code are noise. Keeping them would fail the build; deleting them is the correct move.

## Risks / Trade-offs

- **Community contributors lose the feedback command**: The feedback command was a convenience for open-source contributors. Removing it is acceptable given the enterprise-first direction.
- **No rollback path at the feature level**: Once the dependency is removed and the PR merged, re-adding telemetry requires a new change. This is intentional.
