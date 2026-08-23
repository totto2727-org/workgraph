# workgraph-codex-cli

`workgraph-codex-cli` owns the Codex-native `CodexAgentOptions` and `codex_agent` composition root for the provider-neutral Workgraph coding-agent contract. For shared installation and graph construction, see the root [Setup](../../README.md#setup) and [Usage](../../README.md#usage).

## Example

The [Codex prompt-to-result example](src/examples/basic/main.mbt) composes `codex_agent` into a one-node graph, invokes it with a read-only sentinel prompt, and prints the final response reduced into graph state. Running it requires an installed and authenticated Codex CLI; the expected response is `WORKGRAPH_CODEX_OK`.

## API

[Mooncakes API reference](https://mooncakes.io/docs/totto2727/workgraph-codex-cli)
