# Workgraph Package Split Record

## Outcome

The former monolithic graph module is split into six independently targeted MoonBit modules. Runtime-independent code no longer inherits native-only CLI dependencies.

## Package Boundaries

```text
package/
├── workgraph-core/
│   └── src/examples/basic/
├── workgraph-agent-cli/
├── workgraph-llm/
│   ├── src/examples/basic/
│   └── src/test/
├── workgraph-visualization/
│   └── src/examples/basic/
├── workgraph-codex-cli/
│   ├── src/examples/basic/
│   └── src/test/
└── workgraph-opencode-cli/
    ├── src/examples/basic/
    └── src/test/
```

Core owns identifiers, graph construction and compilation, runtime state reduction, events, coding-agent contracts, and the in-memory resource store. It does not import LLM or CLI SDKs.

`workgraph-agent-cli`, `workgraph-llm`, and `workgraph-visualization` each import core. Codex and OpenCode import core and agent CLI plus only their corresponding CLI SDK.

## Target Policy

- `workgraph-core`, `workgraph-agent-cli`, and `workgraph-visualization` prefer Wasm/WASI and support JavaScript, native, and Wasm/WASI. `workgraph-llm` prefers JavaScript and supports JavaScript and native because `mizchi/llm` uses aborting Wasm stubs for runtime operations.
- `workgraph-codex-cli` and `workgraph-opencode-cli` prefer Wasm/WASI and support Wasm/WASI and native from the same production source. Process integration tests and real CLI examples remain native-only.

## Test Ownership

Portable contract tests remain beside their implementation files. LLM provider and native process-backed Codex/OpenCode integration tests live under the owning module's `src/test` package. The former shared testing helpers and cross-module E2E workflow were removed because they existed only for the deleted aggregate workflow suite.

## Examples

- Core provides the basic graph and in-memory resource example.
- LLM provides a credential-free `mizchi/llm.MockProvider` graph example.
- Visualization provides the Mermaid example.
- Codex and OpenCode each provide a real CLI-backed coding-agent graph example.
- Coding has no standalone example because both CLI modules exercise it.

## Verification

```bash
vp run mbt:check
vp run mbt:build
vp run mbt:test
moon run package/workgraph-llm/src/examples/basic
moon run --target native package/workgraph-codex-cli/src/examples/basic
moon run --target native package/workgraph-opencode-cli/src/examples/basic
```
