---
moonbit:
  import:
    - path: moonbitlang/async@0.20.3
      alias: async
    - path: totto2727/workgraph-core@0.1.3
      alias: core
    - path: totto2727/workgraph-visualization@0.1.3
      alias: renderer
  backend:
    native
---

# workgraph-visualization

`workgraph-visualization` renders callback-free `workgraph-core` compiled graph snapshots as deterministic Mermaid flowcharts.

This document is canonical `README.mbt.md`; maintain `README.md` as the relative symlink `README.md -> README.mbt.md`.

## Usage

```mbt check
///|
test "workgraph-visualization Mermaid usage" {
  let entry = @core.NodeId::NodeId("render")
  let definition = @core.GraphDefinition::GraphDefinition(
    @core.Reducer::Reducer(fn(state : Int, _patch : Unit) { state }),
  )
  definition.add_node(
    @core.Node::Node(
      entry,
      @core.NodeMetadata::NodeMetadata(
        name="Render",
        description=None,
        kind=@core.Function,
        tags=[],
      ),
      async fn(_context, _state) {
        @async.pause()
        @core.NodeOutput::NodeOutput(None, None)
      },
    ),
  )
  definition.set_router(
    entry,
    @core.router([], fn(_state, _completion) { @core.End }),
  )
  definition.set_entry(entry)
  inspect(
    @renderer.to_mermaid(definition.compile()).has_prefix("flowchart TD"),
    content="true",
  )
}
```

## Key features

- Renders compiled graph snapshots without serializing node callbacks
- Includes node identity, metadata, declared routes, entry point, and router labels
- Escapes Mermaid-special metadata deterministically
- Supports JavaScript, native, and Wasm/WASI targets

## Prerequisites

- **MoonBit**: Install a current MoonBit toolchain.

## Setup

1. Add the runtime dependencies and visualization module to a MoonBit project.

```bash
moon add moonbitlang/async@0.20.3
moon add totto2727/workgraph-core
moon add totto2727/workgraph-visualization
```

2. Import `totto2727/workgraph-visualization` alongside `totto2727/workgraph-core`.

```moonbit
import {
  "moonbitlang/async",
  "totto2727/workgraph-core" @core,
  "totto2727/workgraph-visualization" @renderer,
}
```

## API

[Mooncakes API reference](https://mooncakes.io/docs/totto2727/workgraph-visualization)

## Development

For module structure and development commands, see [AGENTS.md](./AGENTS.md).

## License

[MIT](./LICENSE)

_This README was generated from the [share-artifact skill](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/SKILL.md) and [README template](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/readme/template.md)._
