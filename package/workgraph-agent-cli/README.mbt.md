# workgraph-agent-cli

`workgraph-agent-cli` owns the provider-neutral extension contract for coding-agent adapters: `CodingAgent`, workspace and policy types, opaque continuations, `CodingAgentNodeSpec`, and `coding_agent_node`. For shared installation and graph construction, see the root [Setup](../../README.md#setup) and [Usage](../../README.md#usage).

## Usage

Implement this interface when adding a coding-agent provider: open an `agent-sdk` session, map graph state to `Prompt`, and decode `FinalResponse` into `NodeOutput`. These concrete package Usage sections show the complete adapter-owned prompt-to-result flow:

- [Codex adapter Usage](../workgraph-codex-cli/README.md#usage)
- [OpenCode adapter Usage](../workgraph-opencode-cli/README.md#usage)

## API

[Mooncakes API reference](https://mooncakes.io/docs/totto2727/workgraph-agent-cli)

Version `0.2.1` prefers the Wasm/WASI target and supports Wasm/WASI and native. JavaScript is not supported. The module resolves `totto2727/agent-sdk@0.2.1` from the MoonBit registry. Wasm GC is excluded because `moonbitlang/async` does not support it.

_This README was generated from the [share-artifact skill](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/SKILL.md) and [README template](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/readme/template.md)._
