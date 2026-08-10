# workgraph-llm

`workgraph-llm` adapts `mizchi/llm` messages, tools, and collected results to `workgraph-core` nodes without selecting a provider or runtime.

## Package

```moonbit
import {
  "totto2727/workgraph-llm"
}
```

The module prefers JavaScript and supports JavaScript and native targets. Wasm targets are excluded because `mizchi/llm` exposes aborting Wasm stubs for required runtime operations.

## Example

```bash
moon run package/workgraph-llm/src/examples/basic
```
