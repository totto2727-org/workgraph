# Workgraph

Workgraph is a standalone MoonBit workspace for building typed graphs with state reducers, lifecycle events, scoped resources, provider-neutral LLM and coding-agent nodes, CLI adapters, and Mermaid visualization.

This document is canonical `README.mbt.md`; maintain `README.md` as the relative symlink `README.md -> README.mbt.md`.

## Usage

Run one of the included examples from the repository root after installing the MoonBit toolchain:

```bash
moon run package/workgraph-core/src/examples/basic
moon run package/workgraph-llm/src/examples/basic
moon run package/workgraph-visualization/src/examples/basic
```

The Codex and OpenCode adapters have optional native examples that use the corresponding locally authenticated CLI:

```bash
moon run --target native package/workgraph-codex-cli/src/examples/basic
moon run --target native package/workgraph-opencode-cli/src/examples/basic
```

## Key features

- Typed graph compilation with declared routes, reachability validation, and sequential execution
- Invocation-local state reducers, cancellation-aware cleanup, lifecycle events, and typed resource scopes
- Provider-neutral LLM nodes and direct `agent-sdk` coding-agent nodes
- Codex and OpenCode adapters that retain provider-native options at their composition roots
- Same-source Wasm/native CLI adapters and Mermaid rendering from compiled graph snapshots

## Modules

| Module | Purpose | Preferred target |
| --- | --- | --- |
| [`totto2727/workgraph-core`](package/workgraph-core/README.md) | Graph compiler, runtime, state, events, and resources | Wasm |
| [`totto2727/workgraph-agent-cli`](package/workgraph-agent-cli/README.md) | Provider-neutral coding-agent nodes | Wasm |
| [`totto2727/workgraph-llm`](package/workgraph-llm/README.md) | Provider-neutral LLM nodes | JavaScript |
| [`totto2727/workgraph-visualization`](package/workgraph-visualization/README.md) | Mermaid rendering | Wasm |
| [`totto2727/workgraph-codex-cli`](package/workgraph-codex-cli/README.md) | Codex CLI adapter | Wasm |
| [`totto2727/workgraph-opencode-cli`](package/workgraph-opencode-cli/README.md) | OpenCode CLI adapter | Wasm |

## Prerequisites

- **MoonBit**: Install a current MoonBit toolchain.
- **Nix**: Optional, for the pinned development shell and reproducible CLI integration environment.
- **Codex and OpenCode CLIs**: Optional, only for the corresponding credentialed adapter examples.

## Setup

1. Clone the repository.

```bash
git clone https://github.com/totto2727-org/workgraph.git
cd workgraph
```

2. Enter the pinned shell when using Nix.

```bash
nix develop
```

3. Resolve the workspace dependencies.

```bash
moon update
```

## API

The complete public API contract for the Workgraph modules is maintained in the [Workgraph Runtime Interfaces guide](package/workgraph-core/docs/interfaces.md), which covers graph construction, runtime execution, resources, LLM nodes, coding-agent nodes, and provider adapters. The [Core Types and Execution Guide](package/workgraph-core/docs/core-guide.md) provides the accompanying runtime walkthrough.

## Development

For repository structure and development commands, see [AGENTS.md](./AGENTS.md).

## License

[MIT](LICENSE)

_This README was generated from the [share-artifact skill](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/SKILL.md) and [README template](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/readme/template.md)._
