---
moonbit:
  import:
    - path: mizchi/llm@0.3.1
      alias: llm
    - path: moonbitlang/async@0.20.3
      alias: async
    - path: totto2727/workgraph-core@0.1.3
      alias: core
    - path: totto2727/workgraph-llm@0.1.3
      alias: workgraph_llm
  backend:
    native
---

# workgraph-llm

`workgraph-llm` adapts `mizchi/llm` messages, tools, streamed events, and collected results into typed `workgraph-core` nodes without selecting a provider or runtime.

## Usage

```mbt check
///|
async test "workgraph-llm node usage" {
  let entry = @core.NodeId::NodeId("llm")
  let provider = @llm.MockProvider::new([
    [
      @llm.MessageStart,
      @llm.TextDelta("Use a typed node"),
      @llm.MessageEnd(finish_reason=@llm.Stop, usage=None),
    ],
  ]).boxed()
  let node = @workgraph_llm.llm_node(
    entry,
    @core.NodeMetadata::NodeMetadata(
      name="LLM",
      description=None,
      kind=@core.Llm,
      tags=[],
    ),
    @workgraph_llm.LlmNodeSpec::LlmNodeSpec(
      provider,
      fn(_context, prompt : String) {
        @workgraph_llm.LlmRequest::LlmRequest([@llm.Message::user(prompt)])
      },
      fn(_state, response) {
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
    "Plan the next step",
  )
  inspect(result.final_state, content="Use a typed node")
  inspect(result.steps, content="1")
}
```

## Key features

- Converts typed state into `mizchi/llm` requests, including tools
- Collects streamed text, tool calls, finish reason, and usage into an LLM response
- Returns standard Workgraph node patches and optional values without choosing a provider
- Supports JavaScript and native targets; Wasm targets are not supported

## Prerequisites

- **MoonBit**: Install a current MoonBit toolchain.

## Setup

1. Add the LLM, async, core, and Workgraph integration modules to a MoonBit project.

```bash
moon add mizchi/llm@0.3.1
moon add moonbitlang/async@0.20.3
moon add totto2727/workgraph-core
moon add totto2727/workgraph-llm
```

2. Import `totto2727/workgraph-llm` alongside `totto2727/workgraph-core`.

```moonbit
import {
  "mizchi/llm",
  "moonbitlang/async",
  "totto2727/workgraph-core" @core,
  "totto2727/workgraph-llm" @workgraph_llm,
}
```

## API

[Mooncakes API reference](https://mooncakes.io/docs/totto2727/workgraph-llm)

## Development

For module structure and development commands, see [AGENTS.md](./AGENTS.md).

## License

[MIT](./LICENSE)

_This README was generated from the [share-artifact skill](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/SKILL.md) and [README template](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/readme/template.md)._
