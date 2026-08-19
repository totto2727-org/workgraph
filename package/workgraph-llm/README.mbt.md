---
moonbit:
  import:
    - path: mizchi/llm@0.3.1
      alias: llm
    - path: totto2727/workgraph-llm@0.1.3
      alias: workgraph_llm
  backend:
    native
---

# workgraph-llm

`workgraph-llm` adapts `mizchi/llm` messages, tools, streamed events, and collected results into typed `workgraph-core` nodes without selecting a provider or runtime.

This document is canonical `README.mbt.md`; maintain `README.md` as the relative symlink `README.md -> README.mbt.md`.

## Usage

```mbt check
///|
test "workgraph-llm request usage" {
  let request = @workgraph_llm.LlmRequest::LlmRequest([
    @llm.Message::user("Plan the next step"),
  ])
  inspect(request.messages[0].get_text(), content="Plan the next step")
}
```

## Key features

- Converts typed state into `mizchi/llm` requests, including tools
- Collects streamed text, tool calls, finish reason, and usage into an LLM response
- Returns standard Workgraph node patches and optional values without choosing a provider
- Supports JavaScript and native targets; Wasm targets are not supported

## Prerequisites

- **MoonBit**: Install a current MoonBit toolchain.

## Setup

1. Add the LLM message types and Workgraph integration to a MoonBit project.

```bash
moon add mizchi/llm@0.3.1
moon add totto2727/workgraph-llm
```

2. Import `totto2727/workgraph-llm` alongside `totto2727/workgraph-core`.

```moonbit
import {
  "mizchi/llm",
  "totto2727/workgraph-llm" @workgraph_llm,
}
```

## API

[Mooncakes API reference](https://mooncakes.io/docs/totto2727/workgraph-llm)

## Development

For module structure and development commands, see [AGENTS.md](./AGENTS.md).

## License

[MIT](./LICENSE)

_This README was generated from the [share-artifact skill](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/SKILL.md) and [README template](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/readme/template.md)._
