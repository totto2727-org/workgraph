# workgraph-codex-cli

## Repository structure

```text
src/  Codex adapter implementation, native example, and integration tests
```

## Development commands

### Execution rules

- Run commands from this module root.
- Keep `README.mbt.md` as the module README and `README.md` as its relative symlink.
- Use the native target for process-backed Codex integration tests.

### Standard tasks

- `moon check` — Type-check this module.
- `moon test` — Run this module's tests.
- `moon build` — Build this module for its supported targets.
- `moon package --list` — Verify the published module archive contents.

## Architecture

### Module boundary

- `src/` owns the Codex-native `CodexAgentOptions` and `codex_agent` composition root.
- The shared coding-agent lifecycle remains in `workgraph-agent-cli`; provider options stay in this adapter.

## Development tools

- **MoonBit**: Checks, tests, builds, and packages this module.
- **Codex CLI**: Required only for the credentialed native example and integration tests.

_This AGENTS.md was generated from the [share-artifact skill](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/SKILL.md) and [AGENTS template](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/agents/template.md)._
