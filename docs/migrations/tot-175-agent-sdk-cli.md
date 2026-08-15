# Agent CLI SDK migration

TOT-175 moves the Codex and OpenCode Workgraph adapters from direct provider execution to the provider-neutral `totto2727/agent-sdk/cli` node contract. `CodexAgentOptions`, `OpenCodeAgentOptions`, and both public agent constructors remain composition roots, but the public Workgraph session/request/response/status mirror is removed.

## Dependency boundary

| Workgraph module | Common session | Provider adapter | Provider-native options |
| --- | --- | --- | --- |
| `workgraph-codex-cli` | `agent-sdk/cli` | `agent-sdk/cli/codex` | `codex-sdk/cli` |
| `workgraph-opencode-cli` | `agent-sdk/cli` | `agent-sdk/cli/opencode` | `opencode-sdk/cli` |

The public versions are `totto2727/agent-sdk@0.2.0`, `totto2727/codex-sdk@0.4.0`, and `totto2727/opencode-sdk@0.4.0`; `workgraph-agent-cli`, `workgraph-codex-cli`, and `workgraph-opencode-cli` are version `0.2.0`. CI resolves published dependencies from the MoonBit registry and never rewrites `moon.work` with source checkouts or overlays. The [shared Nix setup and MoonBit actions](https://github.com/totto2727-org/monorepo/tree/main/.github/actions) run without an explicit target so each module's preferred target governs validation, while the `ci` Nix dev shell supplies the Codex and OpenCode executables.

`CodingAgent.open` now returns a configured `Cli`. Each node builds a `Prompt`, selects an optional opaque `CodingAgentContinuation`, calls `Cli.start()` or `Cli.continue_session()` exactly once when acquiring its scoped resource, invokes `CliSession.prompt`, and decodes the resulting direct `FinalResponse` together with a Workgraph-owned continuation token. The node resolves relative context-file paths against the workspace root for both providers and leaves absolute `Path` values unchanged. A node owns a mutex for prompt serialization and a no-op resource finalizer because agent-sdk exposes no idle close operation. Prompt cancellation is cleaned up by the provider and then re-raised. `CodingAgentContinuation` is in-process only, has no public constructor, and is bound to the `CodingAgentId` that produced it; a mismatched owner is rejected before provider open.

The retained Workgraph concepts are workspace and policy context, `CodingAgentId`, `CodingAgent`, `CodingAgentNodeSpec`, resource scopes, and sequential graph composition. The removed mirror types are `SessionId`, `CodingAgentRequest`, `CodingAgentStatus`, `CodingAgentResponse`, and `CodingAgentSession`, including logical close and post-close errors. Agent identity participates in the internal resource key, so sequential nodes using different agents cannot share sessions, state slots, or continuations accidentally. This migration intentionally changes the Workgraph coding-agent public interface; only Server dependency, source, and transport changes are out of scope. The module family prefers Wasm/WASI and supports Wasm/WASI and native; agent-cli and provider adapters no longer support JavaScript. Process-backed fake tests and optional real CLI examples remain native-only.

## References

- [agent-sdk 0.2.0 source](https://github.com/totto2727-org/agent-sdk/tree/9abf45ee53a543149ce19e0542733ec86d055488)
- [codex-sdk 0.4.0 CLI source](https://github.com/totto2727-org/codex-sdk/tree/d0789f997c1cc659833985ac08445939ab8adeed/src/cli)
- [opencode-sdk 0.4.0 CLI source](https://github.com/totto2727-org/opencode-sdk/tree/ab574286a5a9ff7b84118e6e6d5c1b1ad598fb5a/src/cli)
- [MoonBit module configuration](https://docs.moonbitlang.com/en/latest/toolchain/moon/module.html)
- [MoonBit package configuration](https://docs.moonbitlang.com/en/latest/toolchain/moon/package.html)
- [Codex TypeScript SDK](https://github.com/openai/codex/blob/main/sdk/typescript/README.md)
- [OpenCode CLI](https://opencode.ai/docs/cli/)
