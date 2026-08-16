# Workgraph

## Repository structure

```text
package/workgraph-core/          Graph compiler, runtime, state, events, and resources
package/workgraph-agent-cli/     Provider-neutral coding-agent node contract
package/workgraph-llm/           Provider-neutral LLM node integration
package/workgraph-visualization/ Mermaid rendering for compiled graph snapshots
package/workgraph-codex-cli/     Codex CLI adapter
package/workgraph-opencode-cli/  OpenCode CLI adapter
package/workgraph-core/docs/     Runtime API, architecture, testing, and migration guides
```

## Development commands

### Execution rules

- Run commands from the repository root.
- Enter `nix develop` before MoonBit commands when using the pinned toolchain.
- Use `nix develop .#ci` when validating Codex or OpenCode CLI integration; the default shell does not add those CLIs.
- Keep dependencies registry-resolved in CI; do not rewrite `moon.work` with local SDK checkouts.
- Treat process-backed fake CLI tests as native-only; credentialed provider examples are optional smoke checks, not required gates.
- Preserve `README.mbt.md` as the canonical root document and `README.md` as its relative symlink.

### Standard tasks

- `moon update` — Resolve the published module dependencies.
- `moon info` — Regenerate package interface metadata after public API changes.
- `moon check` — Type-check all workspace packages for their preferred targets.
- `moon test` — Run the workspace test suites across the supported targets.
- `moon build` — Build all workspace packages for their preferred targets.
- `moon package --list` — List the module packages selected for publication.

## Architecture

### Workspace boundaries

- `workgraph-core` owns graph definitions, compilation, sequential runtime execution, reducers, events, identifiers, and the typed `ResourceStore`.
- `workgraph-agent-cli` owns `CodingAgent`, workspace and policy types, opaque continuations, and the coding-agent node that composes directly with `agent-sdk`.
- `workgraph-llm` adapts `mizchi/llm` messages, tools, providers, and collected results into core nodes without selecting a provider.
- `workgraph-visualization` renders callback-free compiled graph snapshots as Mermaid diagrams.
- `workgraph-codex-cli` and `workgraph-opencode-cli` are separate provider adapters and retain provider-native option types at their composition roots.

### Runtime model

- Graph execution is sequential, state is invocation-local, and reducers are the only state-update path.
- Compilation validates declared routes, destinations, entry points, and reachability before execution.
- Cancellation uses MoonBit task cancellation; cleanup is explicit, cancellation-aware, and timeout-bounded.
- Coding-agent sessions are scoped resources with agent-bound in-process continuations; the runtime does not provide durable checkpoints or application-scoped resources.

### Target policy

- Core and visualization prefer Wasm and support JavaScript, native, and Wasm.
- LLM nodes prefer JavaScript and support JavaScript and native.
- Coding-agent, Codex, and OpenCode modules prefer Wasm and support Wasm and native; JavaScript is not supported.
- Each adapter uses the same production source for its declared targets.

### Documentation

- The [Workgraph Runtime Interfaces guide](./package/workgraph-core/docs/interfaces.md) is the detailed public API source of truth.
- The [Core Types and Execution Guide](./package/workgraph-core/docs/core-guide.md) explains the runtime model and guarantees.
- Keep user-facing setup and usage in `README.mbt.md`; keep commands, architecture, and repository constraints here.

## Development tools

- **MoonBit**: Resolves dependencies, checks, tests, builds, and packages all workspace modules.
- **Nix flakes**: Provide the pinned default MoonBit/Node.js shell and the CI shell with Codex and OpenCode CLIs.
- **GitHub Actions**: Run the shared Nix and MoonBit setup/check actions on pushes to `main` and pull requests.

## Package-specific rules

- Keep public provider-neutral contracts in `workgraph-agent-cli`; provider-specific options belong only in the Codex or OpenCode adapter packages.
- Preserve the published dependency versions and preferred-target declarations in each package's `moon.mod` unless the corresponding module migration is intentional.
- When changing public MoonBit symbols, update the API guide and run `moon info`, `moon check`, and `moon test` before handoff.
- Read [RELEASING.md](./RELEASING.md) for the split-repository dependency contract and publication order before changing release automation.

_This AGENTS.md was generated from the [share-artifact skill](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/SKILL.md) and [AGENTS template](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/agents/template.md)._
