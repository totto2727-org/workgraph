# Workgraph

Workgraph is a standalone MoonBit workspace for asynchronous typed graphs, LLM nodes, coding-agent nodes, native CLI adapters, and Mermaid visualization.

## Modules

| Module | Purpose | Targets |
| --- | --- | --- |
| [`totto2727/workgraph-core`](package/workgraph-core/README.md) | Graph compiler, runtime, state, events, and resources | native, js |
| [`totto2727/workgraph-agent-cli`](package/workgraph-agent-cli/README.md) | Coding-agent contracts and session lifecycle | native |
| [`totto2727/workgraph-llm`](package/workgraph-llm/README.md) | Provider-neutral LLM nodes | native, js |
| [`totto2727/workgraph-visualization`](package/workgraph-visualization/README.md) | Mermaid rendering | native, js |
| [`totto2727/workgraph-codex-cli`](package/workgraph-codex-cli/README.md) | Codex CLI adapter | native |
| [`totto2727/workgraph-opencode-cli`](package/workgraph-opencode-cli/README.md) | OpenCode CLI adapter | native |

The Codex and OpenCode SDK implementations are external registry dependencies and are not part of this repository.

## Development

Run commands from the repository root:

```bash
moon update
moon info
moon check
moon test
```

Publishing is selected only by a push to `main`, and the shared `publish-moonbit` action handles future publication. It declares no deployment gate and has no `workflow_dispatch` trigger. This migration supplies no credentials and performs no registry mutation. See [RELEASING.md](RELEASING.md) for the split-repository dependency contract and six-module publication order.
