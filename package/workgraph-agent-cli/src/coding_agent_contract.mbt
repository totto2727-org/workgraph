///|
#derive(Debug, Eq)
pub struct WorkspaceRef {
  root : @path.Path
  additional_writable_roots : ReadOnlyArray[@path.Path]
}

///|
pub extend WorkspaceRef with Debug::{to_repr}

///|
pub extend WorkspaceRef with Eq::{equal, not_equal}

///|
/// Creates a writable workspace description for a coding agent.
pub fn WorkspaceRef::WorkspaceRef(
  root : @path.Path,
  additional_writable_roots : ReadOnlyArray[@path.Path],
) -> WorkspaceRef {
  WorkspaceRef::{ root, additional_writable_roots, }
}

///|
#derive(Debug, Eq)
pub(all) enum ApprovalPolicy {
  Never
  OnRequest
  OnFailure
  Untrusted
}

///|
pub extend ApprovalPolicy with Debug::{to_repr}

///|
pub extend ApprovalPolicy with Eq::{equal, not_equal}

///|
#derive(Debug, Eq)
pub(all) enum NetworkPolicy {
  Disabled
  Enabled
}

///|
pub extend NetworkPolicy with Debug::{to_repr}

///|
pub extend NetworkPolicy with Eq::{equal, not_equal}

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
  CodingAgent::{ id, open, }
}

///|
/// In-process continuation bound to the coding agent that produced it.
///
/// Only a coding-agent node can create this value from a successful response.
pub struct CodingAgentContinuation {
  priv owner : CodingAgentId
  priv raw : @cli.Continuation
}

///|
fn CodingAgentContinuation::CodingAgentContinuation(
  owner : CodingAgentId,
  raw : @cli.Continuation,
) -> CodingAgentContinuation {
  CodingAgentContinuation::{ owner, raw, }
}

///|
/// Raised when a continuation is supplied to a different coding agent.
#derive(Debug)
pub suberror CodingAgentContinuationError {
  AgentMismatch(expected~ : CodingAgentId, actual~ : CodingAgentId)
}

///|
pub extend CodingAgentContinuationError with Debug::{to_repr}
