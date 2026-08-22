# workgraph-llm

`workgraph-llm` owns the provider-neutral adapter from `mizchi/llm` messages, tools, streamed events, and collected results to typed Workgraph nodes. For shared installation and graph construction, see the root [Setup](../../README.md#setup) and [Usage](../../README.md#usage).

## Example

The [checked LLM example](src/examples/basic/main.mbt) invokes `llm_node` with a deterministic `MockProvider`, reduces the collected response into graph state, and prints the answer, token count, and step count.

## API

[Mooncakes API reference](https://mooncakes.io/docs/totto2727/workgraph-llm)
