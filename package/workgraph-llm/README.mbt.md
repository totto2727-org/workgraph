---
moonbit:
  import:
    - path: totto2727/llm@0.3.3
      alias: llm
    - path: moonbitlang/async@0.22.9
      alias: async
    - path: totto2727/workgraph-core@0.1.4
      alias: core
    - path: totto2727/workgraph-llm@0.1.4
      alias: workgraph_llm
  backend:
    native
---

# workgraph-llm

`workgraph-llm` adapts messages, tools, streamed events, and collected results from `totto2727/llm` to typed Workgraph nodes without selecting a provider. For shared installation and graph construction, see the root [Setup](../../README.md#setup) and [Usage](../../README.md#usage).

The node awaits the provider on JavaScript, native, and Wasm1, and cancellation propagates to the provider before response decoding.
Use a Wasm1 host with MoonBit's async socket support for HTTP providers.
Browser HTTP providers require a CORS-compatible endpoint, and local subprocess providers cannot run in a browser.

## Usage

Run an LLM node with a deterministic provider and observe its response in graph state:

```mbt check
///|
async test "workgraph-llm response usage" {
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

The [checked LLM example](src/examples/basic/main.mbt) also reports collected token usage.

## API

[Mooncakes API reference](https://mooncakes.io/docs/totto2727/workgraph-llm)

_This README was generated from the [share-artifact skill](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/SKILL.md) and [README template](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/readme/template.md)._
