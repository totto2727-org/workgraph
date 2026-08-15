///|
/// Configuration shared by every OpenCode CLI session opened by this adapter.
pub struct OpenCodeAgentOptions {
  opencode_path_override : @path.Path?
  config : @sdk.ConfigObject?
  resume_thread_id : String?
  model : String?
  agent : String?
  variant : String?
  title : String?
  thinking : Bool
  extra_env : Map[String, String]
}

///|
/// Creates OpenCode adapter options with the CLI SDK's defaults.
pub fn OpenCodeAgentOptions::OpenCodeAgentOptions(
  opencode_path_override? : @path.Path,
  config? : @sdk.ConfigObject,
  resume_thread_id? : String,
  model? : String,
  agent? : String,
  variant? : String,
  title? : String,
  thinking? : Bool = false,
  extra_env? : Map[String, String] = Map([]),
) -> OpenCodeAgentOptions {
  {
    opencode_path_override,
    config,
    resume_thread_id,
    model,
    agent,
    variant,
    title,
    thinking,
    extra_env,
  }
}

///|
/// Merges inherited, adapter, and open-context environments in precedence order.
fn merged_environment(
  options : OpenCodeAgentOptions,
  context : @coding.CodingAgentOpenContext,
) -> Map[String, String] {
  let environment = @env.get_env_vars()
  for key, value in options.extra_env {
    environment[key] = value
  }
  for key, value in context.environment {
    environment[key] = value
  }
  environment
}

///|
/// Creates a coding agent backed by the provider-neutral OpenCode CLI factory.
pub fn opencode_agent(
  id : @coding.CodingAgentId,
  options : OpenCodeAgentOptions,
) -> @coding.CodingAgent {
  @coding.CodingAgent::CodingAgent(id, async fn(context) {
    @async.pause()
    @opencode_adapter.opencode_cli(
      options=@sdk.ClientOptions::ClientOptions(
        executable_path_override?=options.opencode_path_override,
        config?=options.config,
        env=merged_environment(options, context),
      ),
      thread_options=@sdk.ThreadOptions::ThreadOptions(
        model?=options.model,
        agent?=options.agent,
        working_directory=context.workspace.root,
        variant?=options.variant,
        title?=options.title,
        thinking=options.thinking,
      ),
      resume_thread_id?=options.resume_thread_id,
    )
  })
}
