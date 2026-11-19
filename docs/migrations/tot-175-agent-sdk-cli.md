# Agent CLI SDK migration

TOT-175 moves the Codex and OpenCode Workgraph adapters from direct provider execution to the provider-neutral `totto2727/agent-sdk/cli` node contract. `CodexAgentOptions`, `OpenCodeAgentOptions`, and both public agent constructors remain composition roots, but the public Workgraph session/request/response/status mirror is removed.

## Dependency boundary

| Workgraph module | Common session | Provider adapter | Provider-native options |
| --- | --- | --- | --- |
| `workgraph-codex-cli` | `agent-sdk/cli` | `agent-sdk/cli/codex` | `codex-sdk/cli` |
| `workgraph-opencode-cli` | `agent-sdk/cli` | `agent-sdk/cli/opencode` | `opencode-sdk/cli` |

The public versions are `totto2727/agent-sdk@0.2.1`, `totto2727/codex-sdk@0.4.1`, and `totto2727/opencode-sdk@0.4.1`; `workgraph-agent-cli`, `workgraph-codex-cli`, and `workgraph-opencode-cli` are version `0.2.1`. CI resolves published dependencies from the MoonBit registry and never rewrites `moon.work` with source checkouts or overlays. The [shared MoonBit actions](https://github.com/totto2727-org/monorepo/tree/main/.github/actions) install stable MoonBit and validate each module's preferred target without an explicit target override. The `ci` Nix shell supplies the Codex and OpenCode executables to CI.

`CodingAgent.open` now returns a configured `Cli`. Each node builds a `Prompt`, selects an optional opaque `CodingAgentContinuation`, calls `Cli.start()` or `Cli.continue_session()` exactly once when acquiring its scoped resource, invokes `CliSession.prompt`, and decodes the resulting direct `FinalResponse` together with a Workgraph-owned continuation token. The node resolves relative context-file paths against the workspace root for both providers and leaves absolute `Path` values unchanged. A node owns a mutex for prompt serialization and a no-op resource finalizer because agent-sdk exposes no idle close operation. Prompt cancellation is cleaned up by the provider and then re-raised. `CodingAgentContinuation` is in-process only, has no public constructor, and is bound to the `CodingAgentId` that produced it; a mismatched owner is rejected before provider open.

The retained Workgraph concepts are workspace and policy context, `CodingAgentId`, `CodingAgent`, `CodingAgentNodeSpec`, resource scopes, and sequential graph composition. The removed mirror types are `SessionId`, `CodingAgentRequest`, `CodingAgentStatus`, `CodingAgentResponse`, and `CodingAgentSession`, including logical close and post-close errors. Agent identity participates in the internal resource key, so sequential nodes using different agents cannot share sessions, state slots, or continuations accidentally. This migration intentionally changes the Workgraph coding-agent public interface; only Server dependency, source, and transport changes are out of scope. The module family prefers Wasm/WASI and supports Wasm/WASI and native; agent-cli and provider adapters no longer support JavaScript. Process-backed fake tests and optional real CLI examples remain native-only.

## Stable MoonBit release blocker

The `workgraph-llm` module previously depended on [`mizchi/llm@0.3.2`](https://mooncakes.io/docs/mizchi/llm), the latest Mooncakes release checked for this migration.
With the November 2026 MoonBit compiler, `moon check --deny-warn` reports error 4015 at `mizchi/llm/src/tools/tool.mbt:48`: `String` has no method `to_json`.
The error originates in the registry dependency, not the Workgraph adapter.
The current compatibility update switches `workgraph-llm` to [`totto2727/llm@0.3.3`](https://github.com/totto2727-org/llm), a fork that supports the November 2026 compiler.
Wait for the exact Mooncakes release before running registry-based CI and merging this update.
Do not substitute a local checkout or skip the LLM checks in CI.

## References

- [agent-sdk 0.2.0 source](https://github.com/totto2727-org/agent-sdk/tree/9abf45ee53a543149ce19e0542733ec86d055488)
- [codex-sdk 0.4.0 CLI source](https://github.com/totto2727-org/codex-sdk/tree/d0789f997c1cc659833985ac08445939ab8adeed/src/cli)
- [opencode-sdk 0.4.0 CLI source](https://github.com/totto2727-org/opencode-sdk/tree/ab574286a5a9ff7b84118e6e6d5c1b1ad598fb5a/src/cli)
- [MoonBit module configuration](https://docs.moonbitlang.com/en/latest/toolchain/moon/module.html)
- [MoonBit package configuration](https://docs.moonbitlang.com/en/latest/toolchain/moon/package.html)
- [Codex TypeScript SDK](https://github.com/openai/codex/blob/main/sdk/typescript/README.md)
- [OpenCode CLI](https://opencode.ai/docs/cli/)
