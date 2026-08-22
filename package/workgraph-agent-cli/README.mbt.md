# workgraph-agent-cli

`workgraph-agent-cli` owns the provider-neutral extension contract for coding-agent adapters: `CodingAgent`, workspace and policy types, opaque continuations, `CodingAgentNodeSpec`, and `coding_agent_node`. For shared installation and graph construction, see the root [Setup](../../README.md#setup) and [Usage](../../README.md#usage).

## Examples

These concrete adapters show how an implementation opens an `agent-sdk` session, builds a prompt from graph state, and decodes the final response into `NodeOutput`:

- [Codex prompt-to-result example](../workgraph-codex-cli/src/examples/basic/main.mbt)
- [OpenCode prompt-to-result example](../workgraph-opencode-cli/src/examples/basic/main.mbt)

## API

[Mooncakes API reference](https://mooncakes.io/docs/totto2727/workgraph-agent-cli)
