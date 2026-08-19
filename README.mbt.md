# Workgraph

Workgraph is a standalone MoonBit workspace for building typed graphs with state reducers, lifecycle events, scoped resources, provider-neutral LLM and coding-agent nodes, CLI adapters, and Mermaid visualization.

This document is canonical `README.mbt.md`; maintain `README.md` as the relative symlink `README.md -> README.mbt.md`.

## Usage

Choose the module that provides the capability you need. Most graphs start with `workgraph-core`:

```moonbit
import {
  "totto2727/workgraph-core"
}
```

Add the LLM, visualization, or coding-agent adapter modules only when the graph needs those capabilities.

## Key features

- Typed graph compilation with declared routes, reachability validation, and sequential execution
- Invocation-local state reducers, cancellation-aware cleanup, lifecycle events, and typed resource scopes
- Provider-neutral LLM nodes and direct `agent-sdk` coding-agent nodes
- Codex and OpenCode adapters that retain provider-native options at their composition roots
- Same-source Wasm/native CLI adapters and Mermaid rendering from compiled graph snapshots

## Prerequisites

- **MoonBit**: Install a current MoonBit toolchain.
- **Codex and OpenCode CLIs**: Optional, only when using the corresponding coding-agent adapter.

## Setup

1. Add the core runtime to your MoonBit project.

```bash
moon add totto2727/workgraph-core
```

2. Add only the optional modules your graph uses. For example:

```bash
moon add totto2727/workgraph-llm
moon add totto2727/workgraph-visualization
```

## API

The complete public API contract for the Workgraph modules is maintained in the [Workgraph Runtime Interfaces guide](package/workgraph-core/docs/interfaces.md), which covers graph construction, runtime execution, resources, LLM nodes, coding-agent nodes, and provider adapters. The [Core Types and Execution Guide](package/workgraph-core/docs/core-guide.md) provides the accompanying runtime walkthrough.

## Modules

| Module | Purpose | Supported targets |
| --- | --- | --- |
| [`totto2727/workgraph-core`](package/workgraph-core/README.md) | Graph compiler, runtime, state, events, and resources | JavaScript, native, and Wasm/WASI (preferred) |
| [`totto2727/workgraph-agent-cli`](package/workgraph-agent-cli/README.md) | Provider-neutral coding-agent nodes | Wasm/WASI (preferred) and native |
| [`totto2727/workgraph-llm`](package/workgraph-llm/README.md) | Provider-neutral LLM nodes | JavaScript (preferred) and native |
| [`totto2727/workgraph-visualization`](package/workgraph-visualization/README.md) | Mermaid rendering | JavaScript, native, and Wasm/WASI (preferred) |
| [`totto2727/workgraph-codex-cli`](package/workgraph-codex-cli/README.md) | Codex CLI adapter | Wasm/WASI (preferred) and native |
| [`totto2727/workgraph-opencode-cli`](package/workgraph-opencode-cli/README.md) | OpenCode CLI adapter | Wasm/WASI (preferred) and native |

## Development

For repository structure and development commands, see [AGENTS.md](./AGENTS.md).

## License

[MIT](LICENSE)

_This README was generated from the [share-artifact skill](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/SKILL.md) and [README template](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/readme/template.md)._
