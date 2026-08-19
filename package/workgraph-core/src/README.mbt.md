# workgraph-core source usage

This package-local literate document keeps checked source examples close to `workgraph-core`. For installation, features, supported targets, API references, development guidance, and license information, see the [module README](../README.mbt.md).

## Checked examples

### `NodeId`

Create a validated node identifier and render its string value.

```mbt check
///|
test "README NodeId usage" {
  let node_id = NodeId::NodeId("plan")
  inspect(node_id.to_string(), content="plan")
}
```
