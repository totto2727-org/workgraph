# Workgraph Testing

## Test Layout

Each module owns its tests.

| Module                    | Tests                                                               | Targets    |
| ------------------------- | ------------------------------------------------------------------- | ---------- |
| `workgraph-core`          | Graph compilation, runtime, state, resources, events, identifiers   | wasm (`js`, `native`, `wasm`) |
| `workgraph-agent-cli`     | Direct `Cli` node scope, isolation, continuation, mutex, cancellation | wasm (`wasm`, `native`) |
| `workgraph-llm`           | Provider execution and public `mizchi/llm.MockProvider` integration | js (`js`, `native`) |
| `workgraph-visualization` | Deterministic Mermaid rendering                                     | wasm (`js`, `native`, `wasm`) |
| `workgraph-codex-cli`     | Portable option contract; native fake Codex process integration     | wasm (`wasm`, `native`) |
| `workgraph-opencode-cli`  | Portable option contract; native fake OpenCode process integration  | wasm (`wasm`, `native`) |

The deleted cross-module E2E workflow and shared testing package are not part of the current suite. Normal tests require no credentials. A real Codex or OpenCode CLI smoke is optional and runs only when local credentials are deliberately available.

The adapter `src` packages support non-process contract tests on Wasm/WASI and native. CI delegates target-unspecified formatting, checking, building, and testing to the shared MoonBit actions and therefore follows each module's preferred target. The `ci` Nix dev shell extends the default development shell with both provider CLIs. Native-only fake executable and process lifecycle tests stay in the existing `src/test` packages. Real CLI smoke tests also run only on native.

## Focused Commands

```bash
moon test package/workgraph-core/src
moon test package/workgraph-agent-cli/src
moon test package/workgraph-llm/src
moon test package/workgraph-llm/src/test
moon test package/workgraph-visualization/src
moon test package/workgraph-codex-cli/src
moon test package/workgraph-codex-cli/src/test
moon test package/workgraph-opencode-cli/src
moon test package/workgraph-opencode-cli/src/test
```

## Repository Gate

```bash
vp run mbt:fix
vp run mbt:check
vp run mbt:build
vp run mbt:test
```

Agent-cli tests prove node- and run-scoped session acquisition, `Cli.start` versus `Cli.continue_session`, agent-isolated resource keys, sequential multi-agent composition, mutex release after failures and cancellation, and in-process-only continuation use. Codex and OpenCode integration tests use deterministic fake executables to verify argv, environment, JSONL, continuation, failure, and cancellation behavior. Real CLI examples are separate optional manual checks and depend on valid local authentication.
