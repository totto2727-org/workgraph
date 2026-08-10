///|
test "codex_agent 1 - retains public adapter options" {
  let options = CodexAgentOptions::CodexAgentOptions(
    resume_thread_id="thread-existing",
    model="gpt-5",
    sandbox=@sdk.WorkspaceWrite,
    skip_git=true,
    reasoning=@sdk.High,
    web_search=@sdk.Live,
  )
  debug_inspect(options.resume_thread_id, content="Some(\"thread-existing\")")
  debug_inspect(options.model, content="Some(\"gpt-5\")")
  debug_inspect(options.sandbox, content="Some(WorkspaceWrite)")
  debug_inspect(options.skip_git, content="Some(true)")
  debug_inspect(options.reasoning, content="Some(High)")
  debug_inspect(options.web_search, content="Some(Live)")
}
