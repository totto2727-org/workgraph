///|
/// Configuration shared by every Codex session opened by this adapter.
pub struct CodexAgentOptions {
  codex_path_override : @path.Path?
  base_url : String?
  api_key : String?
  config : @sdk.CodexConfigObject?
  resume_thread_id : String?
  model : String?
  sandbox : @sdk.SandboxMode?
  skip_git : Bool?
  reasoning : @sdk.ModelReasoningEffort?
  web_search : @sdk.WebSearchMode?
}

///|
/// Creates Codex adapter options with the SDK's defaults.
pub fn CodexAgentOptions::CodexAgentOptions(
  codex_path_override? : @path.Path,
  base_url? : String,
  api_key? : String,
  config? : @sdk.CodexConfigObject,
  resume_thread_id? : String,
  model? : String,
  sandbox? : @sdk.SandboxMode,
  skip_git? : Bool,
  reasoning? : @sdk.ModelReasoningEffort,
  web_search? : @sdk.WebSearchMode,
) -> CodexAgentOptions {
  {
    codex_path_override,
    base_url,
    api_key,
    config,
    resume_thread_id,
    model,
    sandbox,
    skip_git,
    reasoning,
    web_search,
  }
}

///|
/// Raised when execution is requested after a session has closed.
pub suberror CodexAdapterError {
  SessionClosed
} derive(Debug)

///|
priv struct CodexAgentSession {
  session : &@agent_cli.CliSession
  mutex : @async.Mutex
  mut closed : Bool
}

///|
fn approval_mode(policy : @coding.ApprovalPolicy) -> @sdk.ApprovalMode {
  match policy {
    @coding.Never => @sdk.Never
    @coding.OnRequest => @sdk.OnRequest
    @coding.OnFailure => @sdk.OnFailure
    @coding.Untrusted => @sdk.Untrusted
  }
}

///|
fn network_enabled(policy : @coding.NetworkPolicy) -> Bool {
  match policy {
    @coding.Disabled => false
    @coding.Enabled => true
  }
}

///|
impl @coding.CodingAgentSession for CodexAgentSession with fn id(self) {
  match self.session.id() {
    Some(id) =>
      Some(@coding.SessionId::SessionId(id) catch { _ => return None })
    None => None
  }
}

///|
impl @coding.CodingAgentSession for CodexAgentSession with fn execute(
  self,
  request,
) {
  self.mutex.acquire()
  if self.closed {
    self.mutex.release()
    raise CodexAdapterError::SessionClosed
  }
  let result = Ok(
    self.session.prompt(
      @agent_cli.Prompt::Prompt(
        request.instruction,
        context_files=request.context_files,
      ),
    ),
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
impl @coding.CodingAgentSession for CodexAgentSession with fn close(self) {
  self.mutex.acquire()
  self.closed = true
  self.mutex.release()
}

///|
/// Creates a coding agent backed by the pinned Codex SDK.
pub fn codex_agent(
  id : @coding.CodingAgentId,
  options : CodexAgentOptions,
) -> @coding.CodingAgent {
  @coding.CodingAgent::CodingAgent(id, async fn(context) {
    @async.pause()
    let cli = @codex_adapter.codex_cli(
      options=@sdk.CodexOptions::CodexOptions(
        codex_path_override?=options.codex_path_override,
        base_url?=options.base_url,
        api_key?=options.api_key,
        config?=options.config,
        env=Map(context.environment.to_array()),
      ),
      thread_options=@sdk.ThreadOptions::ThreadOptions(
        model?=options.model,
        sandbox_mode?=options.sandbox,
        working_directory=context.workspace.root,
        skip_git_repo_check?=options.skip_git,
        model_reasoning_effort?=options.reasoning,
        network_access_enabled=network_enabled(context.network),
        web_search_mode?=options.web_search,
        approval_policy=approval_mode(context.approval),
        additional_directories=[..context.workspace.additional_writable_roots],
      ),
      resume_thread_id?=options.resume_thread_id,
    )
    let session = CodexAgentSession::{
      session: cli.start(),
      mutex: @async.Mutex::Mutex(),
      closed: false,
    }
    (session : &@coding.CodingAgentSession)
  })
}
