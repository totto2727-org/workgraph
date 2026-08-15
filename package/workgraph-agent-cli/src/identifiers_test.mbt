///|
test "CodingAgentId CodingAgentId - non-empty string round trips" {
  inspect(
    CodingAgentId::CodingAgentId("agent-alpha").to_string(),
    content="agent-alpha",
  )
}

///|
test "CodingAgentId CodingAgentId - empty string reports its wrapper kind" {
  let error = try {
    CodingAgentId::CodingAgentId("") |> ignore
    "no error"
  } catch {
    EmptyId(kind~) => "EmptyId:\{kind}"
  }
  inspect(error, content="EmptyId:CodingAgentId")
}
