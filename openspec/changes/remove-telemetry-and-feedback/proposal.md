# Remove Telemetry and Feedback Command

## Supersedes

- **2026-01-09-add-posthog-analytics**: Wholly superseded — the PostHog integration, anonymous ID generation, opt-out mechanism, and first-run notice introduced there are all removed by this change.
- **2026-02-17-add-feedback-command**: Wholly superseded — the `feedback` command and its `gh`-based issue submission introduced there are fully removed by this change.

## Why

OpenSpec is intended for enterprise use where anonymous usage telemetry and outbound issue submission to a public repository are not acceptable. Both features must be removed before the tool can be adopted in restricted environments.

## What Changes

- **BREAKING** Remove the `feedback` command entirely — users can no longer submit GitHub issues via the CLI
- Remove PostHog analytics: the `posthog-node` dependency, the telemetry module (`src/telemetry/`), anonymous ID generation, and the `preAction`/`postAction` command hooks that reported every invocation
- Remove all associated tests for the deleted code

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `telemetry`: Capability is fully removed — no telemetry is collected or transmitted
- `cli-feedback`: Capability is fully removed — the `feedback` command no longer exists

## Impact

- `src/cli/index.ts`: Remove telemetry hooks and feedback command registration
- `src/commands/feedback.ts`: Deleted
- `src/telemetry/config.ts`: Deleted
- `src/telemetry/index.ts`: Deleted
- `package.json`: Remove `posthog-node` dependency
- All associated test files removed
