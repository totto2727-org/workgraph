# workgraph-agent-cli

`workgraph-agent-cli` provides Workgraph's provider-neutral coding-agent concepts, including workspace and policy types, agent identity, opaque in-process continuations, node specifications, and `coding_agent_node`.

This document is canonical `README.mbt.md`; maintain `README.md` as the relative symlink `README.md -> README.mbt.md`.

## Usage

```moonbit
import {
  "totto2727/workgraph-agent-cli"
}
```

Use the concrete Codex or OpenCode adapter examples to run a configured coding-agent node.

```bash
moon run --target native package/workgraph-codex-cli/src/examples/basic
```

## Key features

- Defines provider-neutral `CodingAgent` contracts and a node that composes directly with `totto2727/agent-sdk/cli`
- Keeps continuations opaque, in-process, and bound to the configured `CodingAgentId`
- Serializes prompts per agent resource and resolves relative context files against the configured workspace

## Prerequisites

- **MoonBit**: Install a current MoonBit toolchain.
- **A coding-agent adapter**: Add `workgraph-codex-cli` or `workgraph-opencode-cli` to run a concrete provider.

## Setup

1. Add the package to a MoonBit project.

```bash
moon add totto2727/workgraph-agent-cli
```

2. Import `totto2727/workgraph-agent-cli` where the graph's coding-agent node is defined.

```moonbit
import {
  "totto2727/workgraph-agent-cli"
}
```

## API

[Mooncakes API reference](https://mooncakes.io/docs/totto2727/workgraph-agent-cli)

## Development

For repository structure and development commands, see [AGENTS.md](../../AGENTS.md).

## License

[MIT](../../LICENSE)

_This README was generated from the [share-artifact skill](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/SKILL.md) and [README template](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/readme/template.md)._
