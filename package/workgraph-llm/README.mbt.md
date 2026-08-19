# workgraph-llm

`workgraph-llm` adapts `mizchi/llm` messages, tools, streamed events, and collected results into typed `workgraph-core` nodes without selecting a provider or runtime.

This document is canonical `README.mbt.md`; maintain `README.md` as the relative symlink `README.md -> README.mbt.md`.

## Usage

```moonbit
import {
  "totto2727/workgraph-llm"
}
```

Use `LlmNodeSpec` to adapt application state into a provider request and decode the collected result into a graph patch.

## Key features

- Converts typed state into `mizchi/llm` requests, including tools
- Collects streamed text, tool calls, finish reason, and usage into an LLM response
- Returns standard Workgraph node patches and optional values without choosing a provider
- Supports JavaScript and native targets; Wasm targets are not supported

## Prerequisites

- **MoonBit**: Install a current MoonBit toolchain.

## Setup

1. Add the package to a MoonBit project.

```bash
moon add totto2727/workgraph-llm
```

2. Import `totto2727/workgraph-llm` alongside `totto2727/workgraph-core`.

```moonbit
import {
  "totto2727/workgraph-llm"
}
```

## API

[Mooncakes API reference](https://mooncakes.io/docs/totto2727/workgraph-llm)

## Development

For module structure and development commands, see [AGENTS.md](./AGENTS.md).

## License

[MIT](./LICENSE)

_This README was generated from the [share-artifact skill](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/SKILL.md) and [README template](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/readme/template.md)._
