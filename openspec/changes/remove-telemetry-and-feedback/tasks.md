## 1. Remove Telemetry Module

- [ ] 1.1 Delete `src/telemetry/config.ts`
- [ ] 1.2 Delete `src/telemetry/index.ts`
- [ ] 1.3 Remove `posthog-node` from `package.json` and update lockfile
- [ ] 1.4 Remove `preAction`/`postAction` telemetry hooks and anonymous ID logic from `src/cli/index.ts`
- [ ] 1.5 Delete `test/telemetry/config.test.ts`
- [ ] 1.6 Delete `test/telemetry/index.test.ts`

## 2. Remove Feedback Command

- [ ] 2.1 Delete `src/commands/feedback.ts`
- [ ] 2.2 Remove feedback command registration from `src/cli/index.ts`
- [ ] 2.3 Delete `test/commands/feedback.test.ts`

## 3. Verify

- [ ] 3.1 Run `pnpm test` — all tests pass, no references to deleted modules
- [ ] 3.2 Run `openspec --help` — no `feedback` command listed
