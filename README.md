# Workgraph

Workgraph is a standalone MoonBit workspace for asynchronous typed graphs, LLM nodes, coding-agent nodes, same-source wasm/native CLI adapters, and Mermaid visualization.

## Modules

| Module | Purpose | Targets |
| --- | --- | --- |
| [`totto2727/workgraph-core`](package/workgraph-core/README.md) | Graph compiler, runtime, state, events, and resources | wasm (`js`, `native`, `wasm`) |
| [`totto2727/workgraph-agent-cli`](package/workgraph-agent-cli/README.md) | Coding-agent contracts and session lifecycle | wasm (`js`, `native`, `wasm`) |
| [`totto2727/workgraph-llm`](package/workgraph-llm/README.md) | Provider-neutral LLM nodes | js (`js`, `native`) |
| [`totto2727/workgraph-visualization`](package/workgraph-visualization/README.md) | Mermaid rendering | wasm (`js`, `native`, `wasm`) |
| [`totto2727/workgraph-codex-cli`](package/workgraph-codex-cli/README.md) | Codex CLI adapter | native (`wasm`, `native`) |
| [`totto2727/workgraph-opencode-cli`](package/workgraph-opencode-cli/README.md) | OpenCode CLI adapter | native (`wasm`, `native`) |

The provider integrations support Wasm/WASI and native from the same production source while composing `totto2727/agent-sdk/cli` with its Codex or OpenCode adapter. CI uses the shared MoonBit setup and check actions without an explicit target, so each module's preferred target governs validation. The `ci` Nix dev shell extends the default MoonBit and Node.js shell with the Codex and OpenCode CLIs; the default shell remains unchanged. Provider SDK imports are retained only for provider-native option types exposed by each Workgraph composition root. Process-backed fake and real CLI smoke tests run only on native. See the [Agent CLI SDK migration note](docs/migrations/tot-175-agent-sdk-cli.md) for the dependency boundary and publication order.

## Development

Run commands from the repository root:

```bash
moon update
moon info
moon check
moon test
```

Use `nix develop .#ci` when validating provider CLI integration. CI resolves MoonBit dependencies from the registry and does not rewrite `moon.work` with local SDK checkouts.

Publishing is selected only by a push to `main`, and the shared `publish-moonbit` action handles future publication. It declares no deployment gate and has no `workflow_dispatch` trigger. This migration supplies no credentials and performs no registry mutation. See [RELEASING.md](RELEASING.md) for the split-repository dependency contract and six-module publication order.
