# workgraph-visualization

## Repository structure

```text
src/  Callback-free Mermaid renderer and tests
```

## Development commands

### Execution rules

- Run commands from this module root.
- Keep `README.mbt.md` as the module README and `README.md` as its relative symlink.
- Keep rendering deterministic and based on compiled graph snapshots.

### Standard tasks

- `moon check` — Type-check this module.
- `moon test` — Run this module's tests.
- `moon build` — Build this module for its supported targets.
- `moon package --list` — Verify the published module archive contents.

## Architecture

### Module boundary

- `src/` renders callback-free `workgraph-core` graph snapshots as Mermaid flowcharts.
- Mermaid escaping and output ordering are part of the module's deterministic contract.

## Development tools

- **MoonBit**: Checks, tests, builds, and packages this module.

_This AGENTS.md was generated from the [share-artifact skill](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/SKILL.md) and [AGENTS template](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/agents/template.md)._
