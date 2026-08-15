# workgraph-codex-cli

`workgraph-codex-cli` implements the Workgraph coding-agent contract through `totto2727/agent-sdk/cli/codex`. Its public `CodexAgentOptions` and `codex_agent` constructor remain the composition root for Codex-native option types from `totto2727/codex-sdk/cli`.

`codex_agent` returns a configured agent-sdk `Cli` through `CodingAgent.open`; the shared node owns session acquisition, prompt serialization, continuation selection, and response decoding. Prompts retain the caller-ordered context-file list. Provider errors and prompt cancellation propagate unchanged, with provider cleanup owned by the cancellable `CliSession.prompt` call. There is no Workgraph session wrapper, logical `close`, or post-close error.

## Package

```moonbit
import {
  "totto2727/workgraph-codex-cli"
}
```

Version `0.2.0` prefers Wasm/WASI and supports Wasm/WASI and native from the same production source; JavaScript is not supported. It resolves `totto2727/agent-sdk@0.2.0` and `totto2727/codex-sdk@0.4.0` from the MoonBit registry. The shared CI check follows the Wasm/WASI preferred target and loads the Codex CLI from the repository's `ci` Nix dev shell. Fake CLI process tests run only on native.

## Example

The `src/examples/basic` example can use local Codex CLI authentication and runs a read-only prompt in the current workspace. It is an optional credentialed smoke, not a required test gate.

```bash
moon run --target native package/workgraph-codex-cli/src/examples/basic
```
