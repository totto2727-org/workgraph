///|
#derive(Debug)
pub suberror RunConfigurationError {
  MaxStepsMustBePositive(Int32)
  NodeTimeoutMustBePositive(Int32)
  CleanupTimeoutMustBePositive(Int32)
}

///|
#derive(Debug)
pub struct RunOptions {
  max_steps : Int32
  node_timeout_ms : Int32?
  cleanup_timeout_ms : Int32
}

///|
pub fn RunOptions::RunOptions(
  max_steps~ : Int32 = 100,
  node_timeout_ms? : Int32,
  cleanup_timeout_ms~ : Int32 = 5000,
) -> RunOptions raise RunConfigurationError {
  guard max_steps > 0 else { raise MaxStepsMustBePositive(max_steps) }
  match node_timeout_ms {
    Some(timeout_ms) if timeout_ms <= 0 =>
      raise NodeTimeoutMustBePositive(timeout_ms)
    _ => ()
  }
  guard cleanup_timeout_ms > 0 else {
    raise CleanupTimeoutMustBePositive(cleanup_timeout_ms)
  }
  RunOptions::{ max_steps, node_timeout_ms, cleanup_timeout_ms, }
}

///|
#derive(Debug)
pub struct RunResult[S] {
  run_id : RunId
  final_state : S
  steps : Int32
}

///|
pub struct GraphRuntime[S, P] {
  graph : CompiledGraph[S, P]
  events : EventSink
  ids : @random.Rand
}

///|
pub fn[S, P] GraphRuntime::GraphRuntime(
  graph : CompiledGraph[S, P],
  events~ : EventSink = EventSink::discard(),
) -> GraphRuntime[S, P] {
  GraphRuntime::{ graph, events, ids: @random.Rand(), }
}

///|
pub fn[S, P] GraphRuntime::fresh_run_id(self : GraphRuntime[S, P]) -> RunId {
  let value = "run-\{self.ids.int64().to_string()}"
  RunId::RunId(value) catch {
    _ => abort("generated run ID must be nonempty")
  }
}
