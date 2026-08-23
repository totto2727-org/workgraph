---
moonbit:
  import:
    - path: moonbitlang/async@0.21.0
      alias: async
    - path: totto2727/workgraph-core@0.1.4
      alias: core
    - path: totto2727/workgraph-visualization@0.1.4
      alias: renderer
  backend:
    native
---

# workgraph-visualization

`workgraph-visualization` owns deterministic Mermaid rendering for callback-free `workgraph-core` compiled graph snapshots. For shared installation and graph construction, see the root [Setup](../../README.md#setup) and [Usage](../../README.md#usage).

## Usage

Render a compiled graph and observe a Mermaid flowchart:

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

The [checked visualization example](src/examples/basic/main.mbt) renders a routed multi-step workflow with labeled branches.

## API

[Mooncakes API reference](https://mooncakes.io/docs/totto2727/workgraph-visualization)

_This README was generated from the [share-artifact skill](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/SKILL.md) and [README template](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/readme/template.md)._
