# workgraph-opencode-cli

`workgraph-opencode-cli` owns the OpenCode-native `OpenCodeAgentOptions` and `opencode_agent` composition root for the provider-neutral Workgraph coding-agent contract. For shared installation and graph construction, see the root [Setup](../../README.md#setup) and [Usage](../../README.md#usage).

## Example

The [OpenCode prompt-to-result example](src/examples/basic/main.mbt) composes `opencode_agent` into a one-node graph, invokes it with a sentinel prompt, and prints the final response reduced into graph state. Running it requires an installed and configured OpenCode CLI; the expected response is `WORKGRAPH_OPENCODE_OK`.

## API

[Mooncakes API reference](https://mooncakes.io/docs/totto2727/workgraph-opencode-cli)
