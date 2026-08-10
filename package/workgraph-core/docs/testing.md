# Workgraph Testing

## Test Layout

Each module owns its tests.

| Module                    | Tests                                                               | Targets    |
| ------------------------- | ------------------------------------------------------------------- | ---------- |
| `workgraph-core`          | Graph compilation, runtime, state, resources, events, identifiers   | wasm (`js`, `native`, `wasm`) |
| `workgraph-agent-cli`     | Coding-agent session scope, lifecycle, errors, cancellation         | wasm (`js`, `native`, `wasm`) |
| `workgraph-llm`           | Provider execution and public `mizchi/llm.MockProvider` integration | js (`js`, `native`) |
| `workgraph-visualization` | Deterministic Mermaid rendering                                     | wasm (`js`, `native`, `wasm`) |
| `workgraph-codex-cli`     | Portable option contract; native fake Codex process integration     | wasm, native |
| `workgraph-opencode-cli`  | Portable option contract; native fake OpenCode process integration  | wasm, native |

The deleted cross-module E2E workflow and shared testing package are not part of the current suite. Remote provider calls remain manual because normal tests require no credentials.

The adapter `src` packages run non-process contract tests on Wasm/WASI and native. Native-only fake executable and process lifecycle tests stay in the existing `src/test` packages. Real CLI smoke tests also run only on native.

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

Codex and OpenCode integration tests use deterministic fake executables to verify argv, environment, JSONL, continuation, failure, and cancellation behavior. Real CLI examples are separate manual checks and depend on valid local authentication.
