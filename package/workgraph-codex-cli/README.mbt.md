# workgraph-codex-cli

`workgraph-codex-cli` implements the `workgraph-core` coding-agent contract through `totto2727/agent-sdk/cli/codex`. Its public `CodexAgentOptions` and `codex_agent` constructor remain the composition root for Codex-native option types from `totto2727/codex-sdk/cli`.

Requests keep the caller-ordered textual context-file list. Responses preserve the provider session ID and completed patch paths reported by the common CLI adapter. The Workgraph session still serializes execution, rejects execution after `close`, and propagates provider errors unchanged.

## Package

```moonbit
import {
  "totto2727/workgraph-codex-cli"
}
```

The module prefers native and supports Wasm/WASI and native from the same production source. Contract tests run on both targets, while fake and real CLI process tests run only on native.

## Example

The example uses the local Codex CLI authentication and runs a read-only prompt in the current workspace.

```bash
moon run --target native package/workgraph-codex-cli/src/examples/basic
```
