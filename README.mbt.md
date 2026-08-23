---
moonbit:
  import:
    - path: moonbitlang/async@0.21.0
      alias: async
    - path: totto2727/workgraph-core@0.1.4
      alias: core
  backend:
    native
---

# Workgraph

Workgraph is a standalone MoonBit workspace for building typed graphs with state reducers, lifecycle events, scoped resources, provider-neutral LLM and coding-agent nodes, CLI adapters, and Mermaid visualization.

## Usage

Run a typed graph node and observe its reduced final state:

```mbt check
///|
async test "Workgraph runtime usage" {
  let entry = @core.NodeId::NodeId("increment")
  let definition = @core.GraphDefinition::GraphDefinition(
    @core.Reducer::Reducer(fn(state : Int, patch : Int) { state + patch }),
  )
  definition.add_node(
    @core.Node::Node(
      entry,
      @core.NodeMetadata::NodeMetadata(
        name="Increment",
        description=None,
        kind=@core.Function,
        tags=[],
      ),
      async fn(_context, _state) {
        @async.pause()
        @core.NodeOutput::NodeOutput(Some(2), None)
      },
    ),
  )
  definition.set_router(
    entry,
    @core.router([], fn(_state, _completion) { @core.End }),
  )
  definition.set_entry(entry)
  let result = @core.GraphRuntime::GraphRuntime(definition.compile()).invoke(40)
  inspect(result.final_state, content="42")
  inspect(result.steps, content="1")
}
```

See the package-specific Usage sections for [core compilation](package/workgraph-core/README.md#usage), [coding-agent adapters](package/workgraph-agent-cli/README.md#usage), [LLM nodes](package/workgraph-llm/README.md#usage), [Mermaid visualization](package/workgraph-visualization/README.md#usage), [Codex](package/workgraph-codex-cli/README.md#usage), and [OpenCode](package/workgraph-opencode-cli/README.md#usage).

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

1. Add the async runtime and core module to your MoonBit project.

```bash
moon add moonbitlang/async@0.21.0
moon add totto2727/workgraph-core
```

2. Add only the optional modules your graph uses. For example:

```bash
moon add totto2727/workgraph-llm
moon add totto2727/workgraph-visualization
moon add totto2727/workgraph-agent-cli
moon add totto2727/workgraph-codex-cli
moon add totto2727/workgraph-opencode-cli
```

3. Import the core module with an alias in the consumer package's `moon.pkg`.

```moonbit
import {
  "moonbitlang/async",
  "totto2727/workgraph-core" @core,
}
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
