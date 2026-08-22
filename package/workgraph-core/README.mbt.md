# workgraph-core

`workgraph-core` owns Workgraph's typed graph definitions, validation, sequential runtime, reducers, lifecycle events, identifiers, and scoped resources. For shared installation and the minimal graph invocation, see the root [Setup](https://github.com/totto2727-org/workgraph#setup) and [Usage](https://github.com/totto2727-org/workgraph#usage).

## Example

The [checked core example](src/examples/basic/main.mbt) compiles a two-node graph, invokes it with an invocation-scoped resource, and prints the reduced state, JSON snapshot, and step count.

## API

- [Mooncakes API reference](https://mooncakes.io/docs/totto2727/workgraph-core)
- [Core Types and Execution Guide](docs/core-guide.md)
- [Workgraph Runtime Interfaces guide](docs/interfaces.md)
