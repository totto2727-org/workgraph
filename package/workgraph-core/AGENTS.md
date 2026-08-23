# workgraph-core

## Repository structure

```text
src/   Graph definitions, compiler, runtime, state, events, resources, and tests
docs/  Runtime API, architecture, and testing guides
```

## Development commands

### Execution rules

- Run commands from this module root.
- Keep `README.mbt.md` as the module README and `README.md` as its relative symlink.

### Standard tasks

- `moon check` — Type-check this module.
- `moon test` — Run this module's tests.
- `moon build` — Build this module for its supported targets.
- `moon package --list` — Verify the published module archive contents.

## Architecture

### Module boundary

- `src/` owns graph compilation, sequential execution, reducer-only state updates, lifecycle events, identifiers, and invocation-scoped `ResourceStore` values.
- Keep runtime contracts and guarantees synchronized with the guides in `docs/`.

## Development tools

- **MoonBit**: Checks, tests, builds, and packages this module.

_This AGENTS.md was generated from the [share-artifact skill](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/SKILL.md) and [AGENTS template](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/agents/template.md)._
