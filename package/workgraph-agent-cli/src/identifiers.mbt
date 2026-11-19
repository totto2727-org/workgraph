///|
#derive(Eq, Hash, Debug)
pub struct CodingAgentId {
  value : String
}

///|
pub extend CodingAgentId with Eq::{equal, not_equal}

///|
pub extend CodingAgentId with Hash::{hash, hash_combine}

///|
pub extend CodingAgentId with Debug::{to_repr}

///|
#derive(Debug)
pub suberror IdError {
  EmptyId(kind~ : String)
}

///|
pub extend IdError with Debug::{to_repr}

///|
fn parse_id(value : String, kind : String) -> String raise IdError {
  guard !value.is_empty() else { raise EmptyId(kind~) }
  value
}

///|
pub fn CodingAgentId::CodingAgentId(
  value : String,
) -> CodingAgentId raise IdError {
  CodingAgentId::{ value: parse_id(value, "CodingAgentId"), }
}

///|
pub fn CodingAgentId::to_string(self : CodingAgentId) -> String {
  self.value
}
