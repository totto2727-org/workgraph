---
moonbit:
  import:
    - path: totto2727/workgraph-agent-cli@0.2.0
      alias: coding
    - path: totto2727/workgraph-codex-cli@0.2.0
      alias: codex
  backend:
    native
---

# workgraph-codex-cli

`workgraph-codex-cli` implements the Workgraph coding-agent contract through `totto2727/agent-sdk/cli/codex` and exposes `CodexAgentOptions` plus `codex_agent` as the Codex-native composition root.

This document is canonical `README.mbt.md`; maintain `README.md` as the relative symlink `README.md -> README.mbt.md`.

## Usage

```mbt check
///|
test "workgraph-codex-cli adapter usage" {
  let agent = @codex.codex_agent(
    @coding.CodingAgentId::CodingAgentId("codex"),
    @codex.CodexAgentOptions::CodexAgentOptions(),
  )
  inspect(agent.id.to_string(), content="codex")
}
```

## Key features

- Preserves Codex-native options at the `codex_agent` composition root
- Reuses the shared coding-agent node for session acquisition, prompt serialization, and continuation selection
- Propagates provider errors and cancellation while the provider owns prompt cleanup
- Supports Wasm/WASI and native targets; JavaScript is not supported

## Prerequisites

- **MoonBit**: Install a current MoonBit toolchain.
- **Codex CLI**: Install and authenticate the Codex CLI before using this adapter.

## Setup

1. Add the provider-neutral contract and Codex adapter to a MoonBit project.

```bash
moon add totto2727/workgraph-agent-cli
moon add totto2727/workgraph-codex-cli
```

2. Import `totto2727/workgraph-codex-cli` where Codex-specific agent options are configured.

```moonbit
import {
  "totto2727/workgraph-agent-cli" @coding,
  "totto2727/workgraph-codex-cli" @codex,
}
```

## API

[Mooncakes API reference](https://mooncakes.io/docs/totto2727/workgraph-codex-cli)

## Development

For module structure and development commands, see [AGENTS.md](./AGENTS.md).

## License

[MIT](./LICENSE)

_This README was generated from the [share-artifact skill](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/SKILL.md) and [README template](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/readme/template.md)._
