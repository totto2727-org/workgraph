# workgraph-llm

`workgraph-llm` adapts `mizchi/llm` messages, tools, and collected results to `workgraph-core` nodes without selecting a provider or runtime.

## Package

```moonbit
import {
  "totto2727/workgraph-llm"
}
```

The module supports native and JavaScript targets and prefers native builds.

## Example

```bash
moon run --target native package/workgraph-llm/src/examples/basic
moon run --target js package/workgraph-llm/src/examples/basic
```
