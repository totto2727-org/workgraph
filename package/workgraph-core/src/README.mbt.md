# Workgraph

Workgraph is a MoonBit workspace for building typed graphs with state reducers, lifecycle events, scoped resources, provider-neutral LLM and coding-agent nodes, CLI adapters, and Mermaid visualization.

This document is canonical `README.mbt.md`; the repository-root `README.mbt.md` and `README.md` are relative symlinks to it.

## Usage

Build a graph from a reducer, nodes, declared routes, and an entry node.

```mbt check
///|
test "README NodeId usage" {
  let node_id = NodeId::NodeId("plan")
  inspect(node_id.to_string(), content="plan")
}
```

Run the complete basic graph example from the repository root.

```bash
moon run package/workgraph-core/src/examples/basic
```

## Key features

- Typed graph compilation that validates declared routes, destinations, entry points, and reachability
- Sequential graph execution with reducer-only state updates, lifecycle events, cancellation-aware cleanup, and scoped typed resources
- Optional LLM, coding-agent, provider-adapter, and Mermaid-rendering packages that compose with the core runtime

## Prerequisites

- **MoonBit**: Install a current MoonBit toolchain.

## Setup

1. Add the package to a MoonBit project.

```bash
moon add totto2727/workgraph-core
```

2. Import `totto2727/workgraph-core` from the package that defines the graph.

```moonbit nocheck
import {
  "totto2727/workgraph-core"
}
```

## API

[Mooncakes API reference](https://mooncakes.io/docs/totto2727/workgraph-core)

For graph construction and runtime behavior, see the [Workgraph Runtime Interfaces guide](../docs/interfaces.md) and the [Core Types and Execution Guide](../docs/core-guide.md).

## Development

For repository structure and development commands, see [AGENTS.md](../../../AGENTS.md).

## License

[MIT](../../../LICENSE)

_This README was generated from the [share-artifact skill](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/SKILL.md) and [README template](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/readme/template.md)._
