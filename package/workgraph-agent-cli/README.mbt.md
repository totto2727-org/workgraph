# workgraph-agent-cli

`workgraph-agent-cli` provides the Workgraph-owned coding-agent concepts: `WorkspaceRef`, approval and network policies, `CodingAgentOpenContext`, `CodingAgentId`, `CodingAgent`, `CodingAgentNodeSpec`, and `coding_agent_node`. The core package remains provider-neutral and exposes only node patches and optional values.

The breaking API delegates execution directly to `totto2727/agent-sdk/cli`: `CodingAgent.open` returns a configured `Cli`; a node creates a `Prompt`, selects an optional opaque `Continuation`, and decodes a `FinalResponse`. Workgraph no longer exposes mirror `SessionId`, `CodingAgentRequest`, `CodingAgentStatus`, `CodingAgentResponse`, or `CodingAgentSession` types.

Each node acquires one `CliSession` per agent identity and caller resource scope, starting a session when no continuation is selected or resuming one when a continuation is supplied. A node-owned mutex serializes `prompt` calls. Resource finalization is intentionally a no-op because `CliSession` has no idle close operation; cancellation cleanup is owned by the provider call and cancellation is re-raised after that cleanup. `Continuation` is an opaque, in-process handle, not a serializable or durable checkpoint.

Graph execution is sequential. Multiple agents remain isolated even when callers reuse a visible resource key: Workgraph includes the agent ID in its internal key, so sessions, state slots, and continuations never cross agent boundaries.

The package intentionally has no standalone example. Use the runnable `workgraph-codex-cli` and `workgraph-opencode-cli` examples to see this node with concrete coding-agent implementations.

## Package

```moonbit
import {
  "totto2727/workgraph-agent-cli"
}
```

Version `0.2.0` prefers the Wasm/WASI target and supports Wasm/WASI and native. JavaScript is not supported. The module resolves `totto2727/agent-sdk@0.2.0` from the MoonBit registry. Wasm GC is excluded because `moonbitlang/async` does not support it.
