---
moonbit:
  import:
    - path: moonbitlang/core/immut/hashmap
      alias: immut_hashmap
    - path: moonbitlang/x@0.4.47/path
      alias: path
    - path: totto2727/agent-sdk@0.2.0/cli
      alias: cli
    - path: totto2727/workgraph-agent-cli@0.2.0
      alias: coding
    - path: totto2727/workgraph-codex-cli@0.2.0
      alias: codex
    - path: totto2727/workgraph-core@0.1.3
      alias: core
  backend:
    native
---

# workgraph-codex-cli

`workgraph-codex-cli` implements the Workgraph coding-agent contract through `totto2727/agent-sdk/cli/codex` and exposes `CodexAgentOptions` plus `codex_agent` as the Codex-native composition root.

## Usage

Compose the Codex adapter into a typed graph without starting a provider process. Compiling the graph confirms that the adapter-backed node is the coding-agent entry point:

```mbt check
///|
test "Codex adapter graph composition" {
  let entry = @core.NodeId::NodeId("codex")
  let agent = @codex.codex_agent(
    @coding.CodingAgentId::CodingAgentId("codex-cli"),
    @codex.CodexAgentOptions::CodexAgentOptions(),
  )
  let node = @coding.coding_agent_node(
    entry,
    @core.NodeMetadata::NodeMetadata(
      name="Codex",
      description=None,
      kind=@core.CodingAgent,
      tags=[],
    ),
    @coding.CodingAgentNodeSpec::CodingAgentNodeSpec(
      agent~,
      resource_key=@core.ResourceKey::ResourceKey("codex-session"),
      resource_scope=@core.Run,
      open_context=fn(context, _state) {
        @coding.CodingAgentOpenContext::CodingAgentOpenContext(
          run_id=context.run_id,
          task_group=context.task_group,
          workspace=@coding.WorkspaceRef::WorkspaceRef(@path.Path("."), []),
          approval=@coding.Never,
          network=@coding.Disabled,
          environment=@immut_hashmap.new(),
          events=context.events,
        )
      },
      build_prompt=fn(_context, state : String) { @cli.Prompt::Prompt(state) },
      select_continuation=fn(_context, _state) { None },
      decode_response=fn(_state, response, _continuation) {
        @core.NodeOutput::NodeOutput(Some(response.text), None)
      },
    ),
  )
  let definition = @core.GraphDefinition::GraphDefinition(
    @core.Reducer::Reducer(fn(_state : String, patch : String) { patch }),
  )
  definition.add_node(node)
  definition.set_router(
    entry,
    @core.router([], fn(_state, _completion) { @core.End }),
  )
  definition.set_entry(entry)
  let snapshot = definition.compile().snapshot()
  inspect(snapshot.nodes[0].metadata.kind == @core.CodingAgent, content="true")
  inspect(snapshot.entry.to_string(), content="codex")
}
```

The [complete runnable example](src/examples/basic/main.mbt) invokes the compiled graph with an authenticated Codex CLI and prints the returned response from graph state.

## Key features

- Preserves Codex-native options at the `codex_agent` composition root
- Reuses the shared coding-agent node for session acquisition, prompt serialization, and continuation selection
- Propagates provider errors and cancellation while the provider owns prompt cleanup
- Supports Wasm/WASI and native targets; JavaScript is not supported

## Prerequisites

- **MoonBit**: Install a current MoonBit toolchain.
- **Codex CLI**: Install and authenticate the Codex CLI before using this adapter.

## Setup

1. Add the graph, agent SDK, provider-neutral contract, and Codex adapter to a MoonBit project.

```bash
moon add moonbitlang/x@0.4.47
moon add totto2727/agent-sdk@0.2.0
moon add totto2727/workgraph-core
moon add totto2727/workgraph-agent-cli
moon add totto2727/workgraph-codex-cli
```

2. Import `totto2727/workgraph-codex-cli` where Codex-specific agent options are configured.

```moonbit
import {
  "moonbitlang/core/immut/hashmap" @immut_hashmap,
  "moonbitlang/x/path",
  "totto2727/agent-sdk/cli",
  "totto2727/workgraph-agent-cli" @coding,
  "totto2727/workgraph-codex-cli" @codex,
  "totto2727/workgraph-core" @core,
}
```

## API

[Mooncakes API reference](https://mooncakes.io/docs/totto2727/workgraph-codex-cli)

## Development

For module structure and development commands, see [AGENTS.md](./AGENTS.md).

## License

[MIT](./LICENSE)

_This README was generated from the [share-artifact skill](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/SKILL.md) and [README template](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/readme/template.md)._
