# workgraph-core source usage

This package-local literate document keeps checked source examples close to `workgraph-core`. For installation, features, supported targets, API references, development guidance, and license information, see the [module README](../README.mbt.md).

## Checked examples

### One-node graph

Compile and invoke a node, then observe the reduced state and executed step count.

```mbt check
///|
async test "README graph runtime usage" {
  let entry = NodeId::NodeId("increment")
  let definition = GraphDefinition::GraphDefinition(
    Reducer::Reducer(fn(state : Int, patch : Int) { state + patch }),
  )
  definition.add_node(
    Node::Node(
      entry,
      NodeMetadata::NodeMetadata(
        name="Increment",
        description=None,
        kind=Function,
        tags=[],
      ),
      async fn(_context, _state) {
        @async.pause()
        NodeOutput::NodeOutput(Some(2), None)
      },
    ),
  )
  definition.set_router(entry, router([], fn(_state, _completion) { End }))
  definition.set_entry(entry)
  let result = GraphRuntime::GraphRuntime(definition.compile()).invoke(40)
  inspect(result.final_state, content="42")
  inspect(result.steps, content="1")
}
```
