---
moonbit:
  import:
    - path: moonbitlang/async@0.20.3
      alias: async
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

`workgraph-codex-cli` owns the Codex-native `CodexAgentOptions` and `codex_agent` composition root for the provider-neutral Workgraph coding-agent contract. For shared installation and graph construction, see the root [Setup](../../README.md#setup) and [Usage](../../README.md#usage).

## Usage

Send a read-only task through a Codex-backed graph node and return its final response from graph state:

```mbt check
///|
pub async fn run_codex_graph() -> String raise {
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
  let result = @core.GraphRuntime::GraphRuntime(definition.compile()).invoke(
    "Reply with WORKGRAPH_CODEX_OK only. Do not modify files or use tools.",
  )
  result.final_state
}
```

With an installed and authenticated Codex CLI, the expected result is `WORKGRAPH_CODEX_OK`. The literate function is type-checked without executing credentials; the [runnable Codex example](src/examples/basic/main.mbt) executes the same prompt-to-result flow.

## API

[Mooncakes API reference](https://mooncakes.io/docs/totto2727/workgraph-codex-cli)

_This README was generated from the [share-artifact skill](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/SKILL.md) and [README template](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/readme/template.md)._
