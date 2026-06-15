## REMOVED Requirements

### Requirement: Feedback command
**Reason**: The `feedback` command submits issues to a public GitHub repository, which is incompatible with enterprise network policies.
**Migration**: Users can open issues manually at https://github.com/Fission-AI/OpenSpec/issues.

### Requirement: GitHub CLI dependency
**Reason**: The `feedback` command and its `gh` CLI dependency are fully removed.
**Migration**: None.

### Requirement: Issue metadata
**Reason**: The `feedback` command and all issue creation logic are fully removed.
**Migration**: None.

### Requirement: Feedback always works
**Reason**: The `feedback` command is fully removed.
**Migration**: None.

### Requirement: Error handling
**Reason**: The `feedback` command and its error handling are fully removed.
**Migration**: None.

### Requirement: Feedback skill for agents
**Reason**: The feedback skill is fully removed alongside the command.
**Migration**: None.

### Requirement: Shell completions
**Reason**: Shell completions for `feedback` are fully removed.
**Migration**: None.
