# workgraph-visualization

`workgraph-visualization` renders callback-free `workgraph-core` compiled graph snapshots as deterministic Mermaid flowcharts.

This document is canonical `README.mbt.md`; maintain `README.md` as the relative symlink `README.md -> README.mbt.md`.

## Usage

```moonbit
import {
  "totto2727/workgraph-visualization"
}
```

Use `to_mermaid` to turn a compiled graph snapshot into Mermaid flowchart text.

## Key features

- Renders compiled graph snapshots without serializing node callbacks
- Includes node identity, metadata, declared routes, entry point, and router labels
- Escapes Mermaid-special metadata deterministically
- Supports JavaScript, native, and Wasm/WASI targets

## Prerequisites

- **MoonBit**: Install a current MoonBit toolchain.

## Setup

1. Add the package to a MoonBit project.

```bash
moon add totto2727/workgraph-visualization
```

2. Import `totto2727/workgraph-visualization` alongside `totto2727/workgraph-core`.

```moonbit
import {
  "totto2727/workgraph-visualization"
}
```

## API

[Mooncakes API reference](https://mooncakes.io/docs/totto2727/workgraph-visualization)

## Development

For module structure and development commands, see [AGENTS.md](./AGENTS.md).

## License

[MIT](./LICENSE)

_This README was generated from the [share-artifact skill](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/SKILL.md) and [README template](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/readme/template.md)._
