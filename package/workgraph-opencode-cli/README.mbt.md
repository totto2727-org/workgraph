# workgraph-opencode-cli

`workgraph-opencode-cli` implements the `workgraph-core` coding-agent contract through `totto2727/agent-sdk/cli/opencode`. Its public `OpenCodeAgentOptions` and `opencode_agent` constructor remain the composition root for OpenCode-native option types from `totto2727/opencode-sdk/cli`.

Relative context-file paths are resolved against the Workgraph workspace before they enter the common prompt. Responses preserve the provider session ID, while the Workgraph session still serializes execution, rejects execution after `close`, and propagates provider errors unchanged.

## Package

```moonbit
import {
  "totto2727/workgraph-opencode-cli"
}
```

The module prefers Wasm/WASI and also supports native from the same production source. The shared CI check follows the Wasm/WASI preferred target and loads the OpenCode CLI from the repository's `ci` Nix dev shell. Fake and real CLI process tests run only on the supported native target.

## Example

The example uses the local OpenCode CLI configuration and runs a read-only prompt in the current workspace.

```bash
moon run --target native package/workgraph-opencode-cli/src/examples/basic
```
