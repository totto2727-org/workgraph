# workgraph-llm

## Repository structure

```text
src/  Provider-neutral LLM node adapter and tests
```

## Development commands

### Execution rules

- Run commands from this module root.
- Keep provider selection in the `mizchi/llm` provider boundary.

### Standard tasks

- `moon check` — Type-check this module.
- `moon test` — Run this module's tests.
- `moon build` — Build this module for its supported targets.
- `moon package --list` — Verify the published module archive contents.

## Architecture

### Module boundary

- `src/` converts typed state, tools, streamed events, and collected results into `workgraph-core` nodes without choosing a provider.
- The deterministic example and tests use `mizchi/llm.MockProvider` where a provider is needed.

## Development tools

- **MoonBit**: Checks, tests, builds, and packages this module.

_This AGENTS.md was generated from the [share-artifact skill](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/SKILL.md) and [AGENTS template](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/agents/template.md)._
