---
moonbit:
  import:
    - path: totto2727/workgraph-agent-cli@0.2.0
      alias: coding
    - path: totto2727/workgraph-opencode-cli@0.2.0
      alias: opencode
  backend:
    native
---

# workgraph-opencode-cli

`workgraph-opencode-cli` implements the Workgraph coding-agent contract through `totto2727/agent-sdk/cli/opencode` and exposes `OpenCodeAgentOptions` plus `opencode_agent` as the OpenCode-native composition root.

This document is canonical `README.mbt.md`; maintain `README.md` as the relative symlink `README.md -> README.mbt.md`.

## Usage

```mbt check
///|
test "workgraph-opencode-cli adapter usage" {
  let agent = @opencode.opencode_agent(
    @coding.CodingAgentId::CodingAgentId("opencode"),
    @opencode.OpenCodeAgentOptions::OpenCodeAgentOptions(),
  )
  inspect(agent.id.to_string(), content="opencode")
}
```

## Key features

- Preserves OpenCode-native options at the `opencode_agent` composition root
- Reuses the shared coding-agent node for session acquisition, prompt serialization, and continuation selection
- Propagates provider errors and cancellation while the provider owns prompt cleanup
- Supports Wasm/WASI and native targets; JavaScript is not supported

## Prerequisites

- **MoonBit**: Install a current MoonBit toolchain.
- **OpenCode CLI**: Install and configure the OpenCode CLI before using this adapter.

## Setup

1. Add the provider-neutral contract and OpenCode adapter to a MoonBit project.

```bash
moon add totto2727/workgraph-agent-cli
moon add totto2727/workgraph-opencode-cli
```

2. Import `totto2727/workgraph-opencode-cli` where OpenCode-specific agent options are configured.

```moonbit
import {
  "totto2727/workgraph-agent-cli" @coding,
  "totto2727/workgraph-opencode-cli" @opencode,
}
```

## API

[Mooncakes API reference](https://mooncakes.io/docs/totto2727/workgraph-opencode-cli)

## Development

For module structure and development commands, see [AGENTS.md](./AGENTS.md).

## License

[MIT](./LICENSE)

_This README was generated from the [share-artifact skill](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/SKILL.md) and [README template](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/readme/template.md)._
