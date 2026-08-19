---
moonbit:
  import:
    - path: totto2727/agent-sdk@0.2.0/cli
      alias: cli
    - path: totto2727/workgraph-agent-cli@0.2.0
      alias: coding
  backend:
    native
---

# workgraph-agent-cli

`workgraph-agent-cli` is the provider-neutral extension interface for authors of Workgraph coding-agent adapters. It defines the `CodingAgent` contract, workspace and policy types, opaque in-process continuations, node specifications, and `coding_agent_node`; applications normally consume it through an adapter such as `workgraph-codex-cli` or `workgraph-opencode-cli`.

## Usage

Implement the extension contract by supplying an `agent-sdk` session factory. The returned `CodingAgent` is then accepted by `CodingAgentNodeSpec` and `coding_agent_node`:

```mbt check
///|
pub fn make_coding_agent(
  id : String,
  open : async (@coding.CodingAgentOpenContext) -> @cli.Cli,
) -> @coding.CodingAgent raise {
  @coding.CodingAgent::CodingAgent(
    @coding.CodingAgentId::CodingAgentId(id),
    open,
  )
}
```

For complete adapter implementations and graph invocations, see the [Codex adapter usage](../workgraph-codex-cli/README.md#usage) and [OpenCode adapter usage](../workgraph-opencode-cli/README.md#usage).

## Key features

- Defines provider-neutral `CodingAgent` contracts and a node that composes directly with `totto2727/agent-sdk/cli`
- Keeps continuations opaque, in-process, and bound to the configured `CodingAgentId`
- Serializes prompts per agent resource and resolves relative context files against the configured workspace
- Supports Wasm/WASI and native targets; JavaScript is not supported

## Prerequisites

- **MoonBit**: Install a current MoonBit toolchain.
- **A coding-agent adapter**: Add `workgraph-codex-cli` or `workgraph-opencode-cli` to run a concrete provider.

## Setup

1. Add the agent SDK and extension interface to an adapter project.

```bash
moon add totto2727/agent-sdk@0.2.0
moon add totto2727/workgraph-agent-cli
```

2. Import `totto2727/workgraph-agent-cli` where the graph's coding-agent node is defined.

```moonbit
import {
  "totto2727/agent-sdk/cli",
  "totto2727/workgraph-agent-cli" @coding,
}
```

## API

[Mooncakes API reference](https://mooncakes.io/docs/totto2727/workgraph-agent-cli)

## Development

For module structure and development commands, see [AGENTS.md](./AGENTS.md).

## License

[MIT](./LICENSE)

_This README was generated from the [share-artifact skill](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/SKILL.md) and [README template](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/readme/template.md)._
