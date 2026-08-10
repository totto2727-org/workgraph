///|
fn codex_agent_test_run_id() -> @core.RunId {
  @core.RunId::RunId("codex-agent-test-run") catch {
    _ => abort("test run ID must be valid")
  }
}

///|
fn codex_agent_test_id() -> @coding_agent.CodingAgentId {
  @coding_agent.CodingAgentId::CodingAgentId("codex-agent-test") catch {
    _ => abort("test coding-agent ID must be valid")
  }
}

///|
fn codex_agent_test_context(
  group : @async.TaskGroup[Unit],
  environment : Map[String, String],
) -> @coding_agent.CodingAgentOpenContext {
  @coding_agent.CodingAgentOpenContext::CodingAgentOpenContext(
    run_id=codex_agent_test_run_id(),
    task_group=group,
    workspace=@coding_agent.WorkspaceRef::WorkspaceRef(@path.Path("/workspace"), [
      @path.Path("/workspace/extra"),
    ]),
    approval=@coding_agent.OnRequest,
    network=@coding_agent.Enabled,
    environment=@immut_hashmap.HashMap(environment.to_array()),
    events=@core.EventSink::discard(),
  )
}

///|
async fn with_fake_codex(
  events : String,
  run : async (@path.Path, Map[String, String], String) -> Unit,
) -> Unit {
  let root = @fs.tmpdir(prefix="workgraph-codex-test-")
  let executable = @path.Path(root).join("codex")
  let input_path = "\{root}/input"
  let script =
    #|#!/bin/sh
    #|/bin/cat > "$FAKE_CODEX_INPUT"
    #|printf '%s\n' "$FAKE_CODEX_EVENTS"
    #|
  let (code, _, stderr) = @process.collect_output("/bin/sh", [
    "-c",
    "printf '%s' \"$1\" > \"$2\" && chmod 755 \"$2\"",
    "fixture-writer",
    script,
    executable.to_string(),
  ])
  if code != 0 {
    abort("failed to create Codex fixture executable: \{stderr.text()}")
  }
  let environment = {
    "PATH": "/usr/bin:/bin",
    "FAKE_CODEX_EVENTS": events,
    "FAKE_CODEX_INPUT": input_path,
  }
  run(executable, environment, input_path) catch {
    error => {
      @async.protect_from_cancel(async fn() { @fs.rmdir(root, recursive=true) })
      raise error
    }
  }
  @fs.rmdir(root, recursive=true)
}

///|
fn successful_events() -> String {
  [
    "{\"type\":\"thread.started\",\"thread_id\":\"thread-42\"}", "{\"type\":\"turn.started\"}",
    "{\"type\":\"item.completed\",\"item\":{\"id\":\"patch-1\",\"type\":\"file_change\",\"changes\":[{\"path\":\"src/new.mbt\",\"kind\":\"add\"},{\"path\":\"src/old.mbt\",\"kind\":\"delete\"}],\"status\":\"completed\"}}",
    "{\"type\":\"item.completed\",\"item\":{\"id\":\"message-1\",\"type\":\"agent_message\",\"text\":\"completed response\"}}",
    "{\"type\":\"turn.completed\",\"usage\":{\"input_tokens\":1,\"cached_input_tokens\":0,\"output_tokens\":2,\"reasoning_output_tokens\":0}}",
  ].join("\n")
}

///|
async test "codex_agent 2 - maps request context and normalizes a successful SDK turn" {
  with_fake_codex(successful_events(), async fn(
    executable,
    environment,
    input_path,
  ) {
    @async.with_task_group() <| group => {
      let agent = @codex.codex_agent(
        codex_agent_test_id(),
        @codex.CodexAgentOptions::CodexAgentOptions(codex_path_override=executable),
      )
      let session = (agent.open)(codex_agent_test_context(group, environment))
      let response = session.execute(
        @coding_agent.CodingAgentRequest::CodingAgentRequest("apply the patch", [
          @path.Path("README.md"),
        ]),
      )
      debug_inspect(response.status, content="Succeeded")
      debug_inspect(response.summary, content="Some(\"completed response\")")
      debug_inspect(response.continuation_id, content="Some(\"thread-42\")")
      inspect(
        response.changed_files.map(fn(path) { path.to_string() }).join(","),
        content="src/new.mbt,src/old.mbt",
      )
      inspect(
        @fs.read_file(input_path).text(),
        content="apply the patch\n\nContext files supplied by the caller:\nREADME.md",
      )
      session.close()
    }
  })
}

///|
async test "codex_agent 3 - keeps unproven file changes empty" {
  with_fake_codex(
    [
      "{\"type\":\"thread.started\",\"thread_id\":\"thread-unproven\"}", "{\"type\":\"turn.started\"}",
      "{\"type\":\"item.completed\",\"item\":{\"id\":\"patch-failed\",\"type\":\"file_change\",\"changes\":[{\"path\":\"src/unproven.mbt\",\"kind\":\"update\"}],\"status\":\"failed\"}}",
      "{\"type\":\"item.completed\",\"item\":{\"id\":\"message-2\",\"type\":\"agent_message\",\"text\":\"no proven files\"}}",
      "{\"type\":\"turn.completed\",\"usage\":{\"input_tokens\":1,\"cached_input_tokens\":0,\"output_tokens\":1,\"reasoning_output_tokens\":0}}",
    ].join("\n"),
    async fn(executable, environment, _input_path) {
      @async.with_task_group() <| group => {
        let agent = @codex.codex_agent(
          codex_agent_test_id(),
          @codex.CodexAgentOptions::CodexAgentOptions(codex_path_override=executable),
        )
        let session = (agent.open)(codex_agent_test_context(group, environment))
        let response = session.execute(
          @coding_agent.CodingAgentRequest::CodingAgentRequest(
            "inspect unproven files",
            [],
          ),
        )
        inspect(response.changed_files.length(), content="0")
        session.close()
      }
    },
  )
}

///|
async test "codex_agent 4 - preserves turn failures and rejects execution after close" {
  with_fake_codex(
    [
      "{\"type\":\"thread.started\",\"thread_id\":\"thread-failed\"}", "{\"type\":\"turn.started\"}",
      "{\"type\":\"turn.failed\",\"error\":{\"message\":\"rate limited\"}}",
    ].join("\n"),
    async fn(executable, environment, _input_path) {
      @async.with_task_group() <| group => {
        let agent = @codex.codex_agent(
          codex_agent_test_id(),
          @codex.CodexAgentOptions::CodexAgentOptions(codex_path_override=executable),
        )
        let session = (agent.open)(codex_agent_test_context(group, environment))
        let turn_failed = try {
          session.execute(
            @coding_agent.CodingAgentRequest::CodingAgentRequest("fail", []),
          )
          |> ignore
          false
        } catch {
          @codex_sdk.CodexSdkError::TurnFailed(message~) => message == "rate limited"
          _ => false
        }
        inspect(turn_failed, content="true")
        session.close()
        let closed = try {
          session.execute(
            @coding_agent.CodingAgentRequest::CodingAgentRequest("after-close", []),
          )
          |> ignore
          false
        } catch {
          @codex.CodexAdapterError::SessionClosed => true
          _ => false
        }
        inspect(closed, content="true")
      }
    },
  )
}

// The native fake follows the pinned upstream Codex SDK executable-spy pattern:
// https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/tests/codexExecSpy.ts
