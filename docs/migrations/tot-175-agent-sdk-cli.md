# Agent CLI SDK migration

TOT-175 moves the native Codex and OpenCode Workgraph adapters from direct provider execution to the provider-neutral `totto2727/agent-sdk/cli` session contract. The public Workgraph coding-agent contract, `CodexAgentOptions`, `OpenCodeAgentOptions`, and both public agent constructors are unchanged.

## Dependency boundary

| Workgraph module | Common session | Provider adapter | Provider-native options |
| --- | --- | --- | --- |
| `workgraph-codex-cli` | `agent-sdk/cli` | `agent-sdk/cli/codex` | `codex-sdk/cli` |
| `workgraph-opencode-cli` | `agent-sdk/cli` | `agent-sdk/cli/opencode` | `opencode-sdk/cli` |

The intended public versions are `totto2727/agent-sdk@0.1.0`, `totto2727/codex-sdk@0.2.0`, and `totto2727/opencode-sdk@0.3.0`. Until those versions are published, CI validates with a temporary `moon.work` overlay pinned to agent-sdk commit `c6ce792f813d1be91a9e6e4fef13380d308d7e3d`, Codex SDK commit `ea482e00842baf40f1a6103a21ca58ef0382acfa`, OpenCode SDK commit `c86e8946c1e02b977ea0ae17e305b76aab6d7140`, and agent-core-sdk commit `127a11e9c4b0bf0067e3082a55af0a44e69c5fe0`. The repository `moon.work` remains registry-only.

Codex forwards the caller-ordered context-file paths to the common prompt, whose Codex adapter preserves the existing textual list format. OpenCode resolves relative paths against the workspace before constructing the common prompt. Workgraph maps `CliSession.id`, `FinalResponse.session_id`, and `FinalResponse.changed_files` back to its existing response contract and passes the initial resume identifier to the adapter constructor.

No Server dependency, source, interface, or transport changes are part of this migration. CLI target metadata remains unchanged and is deferred to TOT-163.

## References

- [MoonBit module configuration](https://docs.moonbitlang.com/en/latest/toolchain/moon/module.html)
- [MoonBit package configuration](https://docs.moonbitlang.com/en/latest/toolchain/moon/package.html)
- [Codex TypeScript SDK](https://github.com/openai/codex/blob/main/sdk/typescript/README.md)
- [OpenCode CLI](https://opencode.ai/docs/cli/)
