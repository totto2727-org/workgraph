///|
/// Configuration shared by every OpenCode CLI session opened by this adapter.
pub struct OpenCodeAgentOptions {
  opencode_path_override : @path.Path?
  config : @sdk.OpenCodeConfigObject?
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
  config? : @sdk.OpenCodeConfigObject,
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
/// Raised when execution is requested after a session has closed.
pub suberror OpenCodeAdapterError {
  SessionClosed
} derive(Debug)

///|
priv struct OpenCodeAgentSession {
  session : &@agent_cli.CliSession
  workspace_root : @path.Path
  mutex : @async.Mutex
  mut closed : Bool
}

///|
fn request_prompt(
  workspace_root : @path.Path,
  request : @coding.CodingAgentRequest,
) -> @agent_cli.Prompt {
  let context_files : Array[@path.Path] = []
  for path in request.context_files {
    context_files.push(
      if path.is_absolute() {
        path
      } else {
        workspace_root.join(path)
      },
    )
  }
  @agent_cli.Prompt::Prompt(
    request.instruction,
    context_files=ReadOnlyArray::from_array(context_files),
  )
}

///|
fn merged_environment(
  options : OpenCodeAgentOptions,
  context : @coding.CodingAgentOpenContext,
) -> Map[String, String] {
  let environment = @env.get_env_vars()
  for key, value in options.extra_env {
    environment[key] = value
  }
  // Run context is caller-owned, so it overrides adapter defaults.
  for key, value in context.environment {
    environment[key] = value
  }
  environment
}

///|
impl @coding.CodingAgentSession for OpenCodeAgentSession with fn id(self) {
  match self.session.id() {
    Some(id) =>
      Some(@coding.SessionId::SessionId(id) catch { _ => return None })
    None => None
  }
}

///|
impl @coding.CodingAgentSession for OpenCodeAgentSession with fn execute(
  self,
  request,
) {
  self.mutex.acquire()
  if self.closed {
    self.mutex.release()
    raise OpenCodeAdapterError::SessionClosed
  }
  let result = Ok(
    self.session.prompt(request_prompt(self.workspace_root, request)),
  ) catch {
    error => Err(error)
  }
  self.mutex.release()
  let response = match result {
    Ok(response) => response
    Err(error) => raise error
  }
  @coding.CodingAgentResponse::CodingAgentResponse(
    status=@coding.Succeeded,
    summary=Some(response.text),
    continuation_id=response.session_id,
    changed_files=response.changed_files,
  )
}

///|
impl @coding.CodingAgentSession for OpenCodeAgentSession with fn close(self) {
  self.mutex.acquire()
  self.closed = true
  self.mutex.release()
}

///|
/// Creates a coding agent backed by the OpenCode CLI SDK.
pub fn opencode_agent(
  id : @coding.CodingAgentId,
  options : OpenCodeAgentOptions,
) -> @coding.CodingAgent {
  @coding.CodingAgent::CodingAgent(id, async fn(context) {
    @async.pause()
    let cli = @opencode_adapter.opencode_cli(
      options=@sdk.OpenCodeOptions::OpenCodeOptions(
        opencode_path_override?=options.opencode_path_override,
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
    let session = OpenCodeAgentSession::{
      session: cli.start(),
      workspace_root: context.workspace.root,
      mutex: @async.Mutex::Mutex(),
      closed: false,
    }
    (session : &@coding.CodingAgentSession)
  })
}
