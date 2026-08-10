# workgraph-visualization

`workgraph-visualization` renders the runtime-independent snapshots produced by `workgraph-core` as Mermaid diagrams.

## Package

```moonbit
import {
  "totto2727/workgraph-visualization"
}
```

The module prefers the Wasm/WASI target and supports JavaScript, native, and Wasm/WASI targets. Wasm GC is excluded because `moonbitlang/async` does not support it.

## Example

```bash
moon run package/workgraph-visualization/src/examples/basic
```
