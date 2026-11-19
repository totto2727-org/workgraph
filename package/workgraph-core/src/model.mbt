///|
#derive(Debug)
pub(all) enum Route {
  To(NodeId)
  End
  Fail(String)
}

///|
pub extend Route with @debug.Debug::{to_repr}

///|
#derive(Debug, Eq)
pub(all) enum NodeKind {
  Function
  Llm
  CodingAgent
  Custom(String)
}

///|
pub extend NodeKind with @debug.Debug::{to_repr}

///|
pub extend NodeKind with Eq::{equal, not_equal}

///|
#derive(Debug)
pub struct NodeMetadata {
  name : String
  description : String?
  kind : NodeKind
  tags : ReadOnlyArray[String]
}

///|
pub extend NodeMetadata with @debug.Debug::{to_repr}

///|
/// Creates metadata describing a graph node.
pub fn NodeMetadata::NodeMetadata(
  name~ : String,
  description~ : String?,
  kind~ : NodeKind,
  tags~ : ReadOnlyArray[String],
) -> NodeMetadata {
  NodeMetadata::{ name, description, kind, tags, }
}

///|
#derive(Debug)
pub struct NodeOutput[P] {
  patch : P?
  value : Json?
}

///|
pub extend NodeOutput with @debug.Debug::{to_repr}

///|
/// Creates the output produced by a graph node.
pub fn[P] NodeOutput::NodeOutput(patch : P?, value : Json?) -> NodeOutput[P] {
  NodeOutput::{ patch, value, }
}

///|
#derive(Debug)
pub struct NodeCompletion {
  node_id : NodeId
  value : Json?
}

///|
pub extend NodeCompletion with @debug.Debug::{to_repr}

///|
/// Creates the completion value passed to a router.
pub fn NodeCompletion::NodeCompletion(
  node_id : NodeId,
  value : Json?,
) -> NodeCompletion {
  NodeCompletion::{ node_id, value, }
}

///|
#derive(Debug)
pub enum GraphEvent {
  RunStarted(RunId)
  RunCompleted(run_id~ : RunId, steps~ : Int32)
  RunFailed(run_id~ : RunId, cause~ : Error)
  RunCancelled(RunId)
  NodeStarted(run_id~ : RunId, node_id~ : NodeId, step~ : Int32)
  NodeCompleted(
    run_id~ : RunId,
    node_id~ : NodeId,
    step~ : Int32,
    completion~ : NodeCompletion,
  )
  NodeFailed(run_id~ : RunId, node_id~ : NodeId, step~ : Int32, cause~ : Error)
  StateUpdated(run_id~ : RunId, node_id~ : NodeId, step~ : Int32)
  RouteSelected(run_id~ : RunId, from~ : NodeId, route~ : Route)
  ResourceOpening(run_id~ : RunId, key~ : ResourceKey)
  ResourceOpened(run_id~ : RunId, key~ : ResourceKey)
  ResourceClosed(run_id~ : RunId, key~ : ResourceKey)
}

///|
pub extend GraphEvent with @debug.Debug::{to_repr}

///|
/// Creates the event emitted when a run starts.
pub fn run_started_event(run_id : RunId) -> GraphEvent {
  RunStarted(run_id)
}

///|
/// Creates the event emitted when a run completes.
pub fn run_completed_event(run_id : RunId, steps : Int32) -> GraphEvent {
  RunCompleted(run_id~, steps~)
}

///|
/// Creates the event emitted before a runtime resource is opened.
pub fn resource_opening_event(run_id : RunId, key : ResourceKey) -> GraphEvent {
  ResourceOpening(run_id~, key~)
}

///|
/// Creates the event emitted after a runtime resource is opened.
pub fn resource_opened_event(run_id : RunId, key : ResourceKey) -> GraphEvent {
  ResourceOpened(run_id~, key~)
}

///|
/// Creates the event emitted after a runtime resource is closed.
pub fn resource_closed_event(run_id : RunId, key : ResourceKey) -> GraphEvent {
  ResourceClosed(run_id~, key~)
}

///|
pub struct EventSink {
  emit : (GraphEvent) -> Unit raise
}

///|
pub fn EventSink::EventSink(emit : (GraphEvent) -> Unit raise) -> EventSink {
  EventSink::{ emit, }
}

///|
pub fn EventSink::discard() -> EventSink {
  EventSink(fn(_) { () })
}

///|
pub fn EventSink::try_emit(self : EventSink, event : GraphEvent) -> Unit {
  (self.emit)(event) catch {
    _ => ()
  }
}

///|
pub struct NodeContext {
  run_id : RunId
  node_id : NodeId
  step : Int32
  deadline_ms : Int64?
  task_group : @async.TaskGroup[Unit]
  events : EventSink
  resources : ResourceStore
}

///|
pub fn NodeContext::NodeContext(
  run_id : RunId,
  node_id : NodeId,
  step : Int32,
  task_group : @async.TaskGroup[Unit],
  events~ : EventSink = EventSink::discard(),
  resources~ : ResourceStore = ResourceStore(),
  deadline_ms? : Int64,
) -> NodeContext {
  NodeContext::{
    run_id,
    node_id,
    step,
    deadline_ms,
    task_group,
    events,
    resources,
  }
}

///|
pub struct Node[S, P] {
  id : NodeId
  metadata : NodeMetadata
  execute : async (NodeContext, S) -> NodeOutput[P]
}

///|
pub fn[S, P] Node::Node(
  id : NodeId,
  metadata : NodeMetadata,
  execute : async (NodeContext, S) -> NodeOutput[P],
) -> Node[S, P] {
  Node::{ id, metadata, execute, }
}

///|
/// Contains optional display metadata for one statically declared route.
#derive(Debug)
pub struct DeclaredRouteMetadata {
  label : String?
}

///|
pub extend DeclaredRouteMetadata with @debug.Debug::{to_repr}

///|
/// Creates display metadata for a statically declared route.
pub fn DeclaredRouteMetadata::DeclaredRouteMetadata(
  label? : String,
) -> DeclaredRouteMetadata {
  DeclaredRouteMetadata::{ label, }
}

///|
/// Declares one possible runtime destination and its optional metadata.
#derive(Debug)
pub struct DeclaredRoute {
  target : NodeId
  metadata : DeclaredRouteMetadata
}

///|
pub extend DeclaredRoute with @debug.Debug::{to_repr}

///|
/// Declares a possible runtime destination.
pub fn DeclaredRoute::DeclaredRoute(
  target : NodeId,
  metadata~ : DeclaredRouteMetadata = DeclaredRouteMetadata::DeclaredRouteMetadata(),
) -> DeclaredRoute {
  DeclaredRoute::{ target, metadata, }
}

///|
/// Contains optional display metadata for a router.
#derive(Debug)
pub struct RouterMetadata {
  description : String?
}

///|
pub extend RouterMetadata with @debug.Debug::{to_repr}

///|
/// Creates display metadata for a router.
pub fn RouterMetadata::RouterMetadata(description? : String) -> RouterMetadata {
  RouterMetadata::{ description, }
}

///|
pub struct Router[S] {
  metadata : RouterMetadata
  declared_routes : ReadOnlyArray[DeclaredRoute]
  evaluate : (S, NodeCompletion) -> Route raise
}

///|
pub fn[S] router(
  declared_routes : ReadOnlyArray[DeclaredRoute],
  evaluate : (S, NodeCompletion) -> Route raise,
  metadata~ : RouterMetadata = RouterMetadata::RouterMetadata(),
) -> Router[S] {
  Router::{ metadata, declared_routes, evaluate, }
}

///|
pub struct Reducer[S, P] {
  apply : (S, P) -> S raise
}

///|
/// Creates a state reducer from its transition function.
pub fn[S, P] Reducer::Reducer(apply : (S, P) -> S raise) -> Reducer[S, P] {
  Reducer::{ apply, }
}
