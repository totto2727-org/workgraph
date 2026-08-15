///|
pub struct WorkspaceRef {
  root : @path.Path
  additional_writable_roots : ReadOnlyArray[@path.Path]
} derive(Debug, Eq)

///|
/// Creates a writable workspace description for a coding agent.
pub fn WorkspaceRef::WorkspaceRef(
  root : @path.Path,
  additional_writable_roots : ReadOnlyArray[@path.Path],
) -> WorkspaceRef {
  WorkspaceRef::{ root, additional_writable_roots }
}

///|
pub(all) enum ApprovalPolicy {
  Never
  OnRequest
  OnFailure
  Untrusted
} derive(Debug, Eq)

///|
pub(all) enum NetworkPolicy {
  Disabled
  Enabled
} derive(Debug, Eq)

///|
pub struct CodingAgentOpenContext {
  run_id : @core.RunId
  task_group : @async.TaskGroup[Unit]
  workspace : WorkspaceRef
  approval : ApprovalPolicy
  network : NetworkPolicy
  environment : @immut_hashmap.HashMap[String, String]
  events : @core.EventSink
}

///|
/// Creates the runtime context used to open a coding-agent session.
pub fn CodingAgentOpenContext::CodingAgentOpenContext(
  run_id~ : @core.RunId,
  task_group~ : @async.TaskGroup[Unit],
  workspace~ : WorkspaceRef,
  approval~ : ApprovalPolicy,
  network~ : NetworkPolicy,
  environment~ : @immut_hashmap.HashMap[String, String],
  events~ : @core.EventSink,
) -> CodingAgentOpenContext {
  CodingAgentOpenContext::{
    run_id,
    task_group,
    workspace,
    approval,
    network,
    environment,
    events,
  }
}

///|
pub struct CodingAgent {
  id : CodingAgentId
  open : async (CodingAgentOpenContext) -> @cli.Cli
}

///|
/// Creates a coding-agent adapter.
pub fn CodingAgent::CodingAgent(
  id : CodingAgentId,
  open : async (CodingAgentOpenContext) -> @cli.Cli,
) -> CodingAgent {
  CodingAgent::{ id, open }
}
