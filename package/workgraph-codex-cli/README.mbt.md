# workgraph-codex-cli

`workgraph-codex-cli` implements the Workgraph coding-agent contract through `totto2727/agent-sdk/cli/codex` and exposes `CodexAgentOptions` plus `codex_agent` as the Codex-native composition root.

This document is canonical `README.mbt.md`; maintain `README.md` as the relative symlink `README.md -> README.mbt.md`.

## Usage

```moonbit
import {
  "totto2727/workgraph-codex-cli"
}
```

Run the optional read-only example with a locally authenticated Codex CLI.

```bash
moon run --target native package/workgraph-codex-cli/src/examples/basic
```

## Key features

- Preserves Codex-native options at the `codex_agent` composition root
- Reuses the shared coding-agent node for session acquisition, prompt serialization, and continuation selection
- Propagates provider errors and cancellation while the provider owns prompt cleanup

## Prerequisites

- **MoonBit**: Install a current MoonBit toolchain.
- **Codex CLI**: Install and authenticate the Codex CLI before running the optional example.

## Setup

1. Add the package to a MoonBit project.

```bash
moon add totto2727/workgraph-codex-cli
```

2. Import `totto2727/workgraph-codex-cli` where Codex-specific agent options are configured.

```moonbit
import {
  "totto2727/workgraph-codex-cli"
}
```

## API

[Mooncakes API reference](https://mooncakes.io/docs/totto2727/workgraph-codex-cli)

## Development

For module structure and development commands, see [AGENTS.md](./AGENTS.md).

## License

[MIT](./LICENSE)

_This README was generated from the [share-artifact skill](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/SKILL.md) and [README template](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/readme/template.md)._
