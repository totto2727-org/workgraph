# workgraph-core

`workgraph-core` provides the typed graph definitions, compiler, sequential runtime, reducers, events, identifiers, and scoped `ResourceStore` used by the Workgraph package family.

This document is canonical `README.mbt.md` for the source package; the module-level README is maintained at [../README.md](../README.md).

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

- Validates graph routes, destinations, entry points, and reachability before execution
- Runs typed nodes sequentially and applies state only through reducers
- Exposes lifecycle events and typed, invocation-scoped resources

## Prerequisites

- **MoonBit**: Install a current MoonBit toolchain.

## Setup

1. Add the package to a MoonBit project.

```bash
moon add totto2727/workgraph-core
```

2. Import `totto2727/workgraph-core` from the package that defines the graph.

## API

[Mooncakes API reference](https://mooncakes.io/docs/totto2727/workgraph-core)

For graph construction and runtime behavior, see the [architecture guide](../docs/architecture.md), [Core Types and Execution Guide](../docs/core-guide.md), [Workgraph Runtime Interfaces guide](../docs/interfaces.md), and [testing guide](../docs/testing.md).

## Development

For module structure and development commands, see [AGENTS.md](../AGENTS.md).

## License

[MIT](../LICENSE)

_This README was generated from the [share-artifact skill](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/SKILL.md) and [README template](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/readme/template.md)._
