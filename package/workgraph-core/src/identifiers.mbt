///|
#derive(Eq, Hash)
pub struct NodeId {
  value : String
}

///|
pub extend NodeId with Eq::{equal, not_equal}

///|
pub extend NodeId with Hash::{hash, hash_combine}

///|
pub extend NodeId with @debug.Debug::{to_repr}

///|
#derive(Eq, Hash)
pub struct RunId {
  value : String
}

///|
pub extend RunId with Eq::{equal, not_equal}

///|
pub extend RunId with Hash::{hash, hash_combine}

///|
pub extend RunId with @debug.Debug::{to_repr}

///|
#derive(Eq, Hash)
pub struct ResourceKey {
  value : String
}

///|
pub extend ResourceKey with Eq::{equal, not_equal}

///|
pub extend ResourceKey with Hash::{hash, hash_combine}

///|
pub extend ResourceKey with @debug.Debug::{to_repr}

///|
#derive(Debug)
pub suberror IdError {
  EmptyId(kind~ : String)
}

///|
pub extend IdError with @debug.Debug::{to_repr}

///|
fn parse_id(value : String, kind : String) -> String raise IdError {
  guard !value.is_empty() else { raise EmptyId(kind~) }
  value
}

///|
pub fn NodeId::NodeId(value : String) -> NodeId raise IdError {
  NodeId::{ value: parse_id(value, "NodeId"), }
}

///|
pub fn NodeId::to_string(self : NodeId) -> String {
  self.value
}

///|
pub fn RunId::RunId(value : String) -> RunId raise IdError {
  RunId::{ value: parse_id(value, "RunId"), }
}

///|
pub fn RunId::to_string(self : RunId) -> String {
  self.value
}

///|
pub fn ResourceKey::ResourceKey(value : String) -> ResourceKey raise IdError {
  ResourceKey::{ value: parse_id(value, "ResourceKey"), }
}

///|
pub fn ResourceKey::to_string(self : ResourceKey) -> String {
  self.value
}

///|
pub impl Debug for NodeId with fn to_repr(self) {
  @debug.Repr::ctor("NodeId", [(None, @debug.Repr::string(self.value))])
}

///|
pub impl Debug for RunId with fn to_repr(self) {
  @debug.Repr::ctor("RunId", [(None, @debug.Repr::string(self.value))])
}

///|
pub impl Debug for ResourceKey with fn to_repr(self) {
  @debug.Repr::ctor("ResourceKey", [(None, @debug.Repr::string(self.value))])
}
