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

# workgraph-core

`workgraph-core` owns Workgraph's typed graph definitions, validation, sequential runtime, reducers, lifecycle events, identifiers, and scoped resources. For shared installation and the overall runtime flow, see the root [Setup](../../README.md#setup) and [Usage](../../README.md#usage).

## Migrate resource references to 0.2

`ResourceStore` accepts `AnyRef` from `totto2727/x/any_collection` starting with `workgraph-core` 0.2.0.
If your code creates resource references, add `"totto2727/x@0.9.0"` in `moon.mod` and import `"totto2727/x/any_collection" @any_collection` in `moon.pkg`.
The existing alias and call sites can stay the same, but references constructed with `totto2727/any-collection` are not compatible with the new `ResourceStore`.
Update dependent Workgraph modules together so that they use the same core version.

## Usage

Compile a graph and inspect its callback-free structure before execution:

```mbt check
///|
test "workgraph-core compile usage" {
  let entry = @core.NodeId::NodeId("plan")
  let definition = @core.GraphDefinition::GraphDefinition(
    @core.Reducer::Reducer(fn(state : Int, _patch : Unit) { state }),
  )
  definition.add_node(
    @core.Node::Node(
      entry,
      @core.NodeMetadata::NodeMetadata(
        name="Plan",
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
  let compiled = definition.compile()
  inspect(compiled.entry().to_string(), content="plan")
  inspect(compiled.snapshot().nodes.length(), content="1")
}
```

The [checked core example](src/examples/basic/main.mbt) demonstrates multi-node execution, invocation-scoped resources, JSON state, and step reporting.

## API

- [Mooncakes API reference](https://mooncakes.io/docs/totto2727/workgraph-core)
- [Core Types and Execution Guide](docs/core-guide.md)
- [Workgraph Runtime Interfaces guide](docs/interfaces.md)

_This README was generated from the [share-artifact skill](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/SKILL.md) and [README template](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/readme/template.md)._
