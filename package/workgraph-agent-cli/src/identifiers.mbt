///|
pub struct CodingAgentId {
  value : String
} derive(Eq, Hash, Debug)

///|
pub suberror IdError {
  EmptyId(kind~ : String)
} derive(Debug)

///|
fn parse_id(value : String, kind : String) -> String raise IdError {
  guard !value.is_empty() else { raise EmptyId(kind~) }
  value
}

///|
pub fn CodingAgentId::CodingAgentId(
  value : String,
) -> CodingAgentId raise IdError {
  CodingAgentId::{ value: parse_id(value, "CodingAgentId") }
}

///|
pub fn CodingAgentId::to_string(self : CodingAgentId) -> String {
  self.value
}
