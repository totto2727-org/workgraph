# Agent CLI SDK migration

TOT-175 moves the Codex and OpenCode Workgraph adapters from direct provider execution to the provider-neutral `totto2727/agent-sdk/cli` session contract. The public Workgraph coding-agent contract, `CodexAgentOptions`, `OpenCodeAgentOptions`, and both public agent constructors are unchanged.

## Dependency boundary

| Workgraph module | Common session | Provider adapter | Provider-native options |
| --- | --- | --- | --- |
| `workgraph-codex-cli` | `agent-sdk/cli` | `agent-sdk/cli/codex` | `codex-sdk/cli` |
| `workgraph-opencode-cli` | `agent-sdk/cli` | `agent-sdk/cli/opencode` | `opencode-sdk/cli` |

The intended public versions are `totto2727/agent-sdk@0.1.0`, `totto2727/codex-sdk@0.2.0`, and `totto2727/opencode-sdk@0.3.0`. CI resolves these dependencies from the MoonBit registry and never rewrites `moon.work` with source checkouts. Until the versions are published in dependency order, registry resolution can fail; that ordering state is recorded rather than hidden behind a CI-only path overlay. The [shared Nix setup and MoonBit actions](https://github.com/totto2727-org/monorepo/tree/main/.github/actions) run from `main` without an explicit target so each module's preferred target governs validation, while the `ci` Nix dev shell supplies the Codex and OpenCode executables.

Codex forwards the caller-ordered context-file paths to the common prompt, whose Codex adapter preserves the existing textual list format. OpenCode resolves relative paths against the workspace before constructing the common prompt. Workgraph maps `CliSession.id`, `FinalResponse.session_id`, and `FinalResponse.changed_files` back to its existing response contract and passes the initial resume identifier to the adapter constructor.

No Server dependency, source, interface, or transport changes are part of this migration. The TOT-163 follow-up keeps the same production source, prefers Wasm/WASI while retaining native support in CLI target metadata, and retains process-backed tests and examples as native-only packages.

## References

- [MoonBit module configuration](https://docs.moonbitlang.com/en/latest/toolchain/moon/module.html)
- [MoonBit package configuration](https://docs.moonbitlang.com/en/latest/toolchain/moon/package.html)
- [Codex TypeScript SDK](https://github.com/openai/codex/blob/main/sdk/typescript/README.md)
- [OpenCode CLI](https://opencode.ai/docs/cli/)
