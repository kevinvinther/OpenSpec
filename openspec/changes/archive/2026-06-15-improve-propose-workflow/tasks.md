## 1. Rewrite Propose Skill Template

- [x] 1.1 Introduce a shared `INSTRUCTIONS` constant in `propose.ts` covering all four phases (Orient, Interview, Confirm, Artifact Creation)
- [x] 1.2 Update `getOpsxProposeSkillTemplate()` to use the shared constant as its `instructions` field
- [x] 1.3 Update `getOpsxProposeCommandTemplate()` to use the shared constant as its `content` field
- [x] 1.4 Update hash for `getOpsxProposeSkillTemplate` in `skill-templates-parity.test.ts`
- [x] 1.5 Update hash for `getOpsxProposeCommandTemplate` in `skill-templates-parity.test.ts`

## 2. Add Supersession Tracking to Archive Skill Template

- [x] 2.1 Add supersession tracking step to `getArchiveChangeSkillTemplate()` in `archive-change.ts`: after moving the change, read `## Supersedes` from the archived proposal, prepend notices to each named target
- [x] 2.2 Add supersession tracking step to `getOpsxArchiveCommandTemplate()` to match
- [x] 2.3 Update hash for `getArchiveChangeSkillTemplate` in `skill-templates-parity.test.ts`
- [x] 2.4 Update hash for `getOpsxArchiveCommandTemplate` in `skill-templates-parity.test.ts`

## 3. Add Guide Documentation

- [x] 3.1 Create `docs/guide.md` covering installation, the OpenSpec spec hierarchy, and the propose workflow end-to-end

## 4. Verify

- [x] 4.1 Run `pnpm test` — all parity hashes pass, no other test regressions
