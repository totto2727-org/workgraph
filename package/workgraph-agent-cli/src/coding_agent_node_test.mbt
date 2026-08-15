///|
suberror CodingAgentNodeTestError {
  OpenContextFailed
  OpenFailed
  PromptBuildFailed
  PromptFailed
  DecodeFailed
} derive(Debug)

///|
enum CodingAgentNodeFailurePhase {
  OpenContext
  Open
  PromptBuild
  Prompt
  Decode
} derive(Eq)

///|
struct CodingAgentNodeFakeSession {
  label : String
  calls : Array[String]
  mut fail_once : Bool
  block_on : String?
  cleanup : Array[String]
  continuation_value : @cli.Continuation?
}

///|
struct CodingAgentNodeSerialSession {
  mut active : Int
  mut max_active : Int
}

///|
impl @cli.CliSession for CodingAgentNodeSerialSession with fn id(_self) {
  None
}

///|
impl @cli.CliSession for CodingAgentNodeSerialSession with fn continuation(
  _self,
) {
  None
}

///|
impl @cli.CliSession for CodingAgentNodeSerialSession with fn prompt(
  self,
  prompt,
) {
  self.active = self.active + 1
  if self.active > self.max_active {
    self.max_active = self.active
  }
  defer {
    self.active = self.active - 1
  }
  @async.pause()
  @async.pause()
  @cli.FinalResponse::FinalResponse("response:\{prompt.text}")
}

///|
impl @cli.CliSession for CodingAgentNodeFakeSession with fn id(self) {
  Some(self.label)
}

///|
impl @cli.CliSession for CodingAgentNodeFakeSession with fn continuation(self) {
  self.continuation_value
}

///|
impl @cli.CliSession for CodingAgentNodeFakeSession with fn prompt(self, prompt) {
  self.calls.push("prompt:\{self.label}:\{prompt.text}")
  if self.fail_once {
    self.fail_once = false
    raise PromptFailed
  }
  if self.block_on == Some(prompt.text) {
    defer self.cleanup.push("cleanup:\{self.label}")
    while true {
      @async.pause()
    }
  }
  @cli.FinalResponse::FinalResponse(
    "response:\{prompt.text}",
    session_id=self.label,
    changed_files=[@path.Path("src/changed.mbt")],
    continuation?=self.continuation_value,
  )
}

///|
fn coding_agent_node_test_run_id(value : String) -> @core.RunId {
  @core.RunId::RunId(value) catch {
    _ => abort("test run ID must be valid")
  }
}

///|
fn coding_agent_node_test_agent_id(value : String) -> CodingAgentId {
  CodingAgentId::CodingAgentId(value) catch {
    _ => abort("test coding-agent ID must be valid")
  }
}

///|
fn coding_agent_node_metadata(name : String) -> @core.NodeMetadata {
  @core.NodeMetadata::NodeMetadata(
    name~,
    description=None,
    kind=@core.CodingAgent,
    tags=["coding-agent-node-test"],
  )
}

///|
fn coding_agent_node_context(
  group : @async.TaskGroup[Unit],
  node_id : @core.NodeId,
  resources : @core.ResourceStore,
) -> @core.NodeContext {
  @core.NodeContext::NodeContext(
    coding_agent_node_test_run_id("coding-agent-node-run"),
    node_id,
    1,
    group,
    resources~,
  )
}

///|
fn coding_agent_open_context(
  group : @async.TaskGroup[Unit],
) -> CodingAgentOpenContext {
  CodingAgentOpenContext::CodingAgentOpenContext(
    run_id=coding_agent_node_test_run_id("coding-agent-open-run"),
    task_group=group,
    workspace=WorkspaceRef::WorkspaceRef(@path.Path("/workspace"), []),
    approval=Never,
    network=Disabled,
    environment=@immut_hashmap.new(),
    events=@core.EventSink::discard(),
  )
}

///|
fn lifecycle_runtime(
  scope : @core.ResourceScope,
  calls : Array[String],
) -> @core.GraphRuntime[Int, Int] raise {
  let node_id = @core.NodeId::NodeId("coding-agent-lifecycle")
  let mut opened = 0
  let agent = CodingAgent::CodingAgent(
    coding_agent_node_test_agent_id("fake-agent"),
    async fn(_context) {
      @async.pause()
      opened = opened + 1
      let number = opened
      calls.push("open:\{number}")
      @cli.Cli::Cli(fn() {
        calls.push("start:\{number}")
        let session = CodingAgentNodeFakeSession::{
          label: "session-\{number}",
          calls,
          fail_once: false,
          block_on: None,
          cleanup: [],
          continuation_value: None,
        }
        (session : &@cli.CliSession)
      })
    },
  )
  let definition = @core.GraphDefinition::GraphDefinition(
    @core.Reducer::Reducer(fn(state : Int, patch : Int) { state + patch }),
  )
  definition.add_node(
    coding_agent_node(
      node_id,
      coding_agent_node_metadata("coding-agent-lifecycle"),
      CodingAgentNodeSpec::CodingAgentNodeSpec(
        agent~,
        resource_key=@core.ResourceKey::ResourceKey("lifecycle-session"),
        resource_scope=scope,
        open_context=fn(context, _state) {
          coding_agent_open_context(context.task_group)
        },
        build_prompt=fn(_context, state : Int) {
          @cli.Prompt::Prompt("state=\{state}")
        },
        select_continuation=fn(_context, _state) { None },
        decode_response=fn(_state, response) {
          calls.push("decode:\{response.text}")
          @core.NodeOutput::NodeOutput(
            Some(1),
            Some(Json::string(response.text)),
          )
        },
      ),
    ),
  )
  definition.set_router(
    node_id,
    @core.router([@core.DeclaredRoute::DeclaredRoute(node_id)], fn(
      state,
      _completion,
    ) {
      if state < 2 {
        @core.To(node_id)
      } else {
        @core.End
      }
    }),
  )
  definition.set_entry(node_id)
  @core.GraphRuntime::GraphRuntime(definition.compile())
}

///|
async test "coding_agent_node lifecycle 1 - node scope opens a fresh SDK session for every attempt" {
  let calls : Array[String] = []
  let result = lifecycle_runtime(@core.Node, calls).invoke(0)
  inspect(result.final_state, content="2")
  inspect(result.steps, content="2")
  inspect(
    calls.join(","),
    content="open:1,start:1,prompt:session-1:state=0,decode:response:state=0,open:2,start:2,prompt:session-2:state=1,decode:response:state=1",
  )
}

///|
async test "coding_agent_node lifecycle 2 - run scope reuses one session and isolates invocations" {
  let calls : Array[String] = []
  let runtime = lifecycle_runtime(@core.Run, calls)
  runtime.invoke(0) |> ignore
  runtime.invoke(0) |> ignore
  inspect(
    calls.join(","),
    content="open:1,start:1,prompt:session-1:state=0,decode:response:state=0,prompt:session-1:state=1,decode:response:state=1,open:2,start:2,prompt:session-2:state=0,decode:response:state=0,prompt:session-2:state=1,decode:response:state=1",
  )
}

///|
async test "coding_agent_node continuation 1 - selects start or opaque continuation on acquisition" {
  @async.with_task_group() <| group => {
    let calls : Array[String] = []
    let resources = @core.ResourceStore::ResourceStore()
    let resumed_session = CodingAgentNodeFakeSession::{
      label: "resumed",
      calls,
      fail_once: false,
      block_on: None,
      cleanup: [],
      continuation_value: None,
    }
    let continuation = @cli.Continuation::Continuation(fn() {
      calls.push("continue")
      (resumed_session : &@cli.CliSession)
    })
    let started_session = CodingAgentNodeFakeSession::{
      label: "started",
      calls,
      fail_once: false,
      block_on: None,
      cleanup: [],
      continuation_value: Some(continuation),
    }
    let agent = CodingAgent::CodingAgent(
      coding_agent_node_test_agent_id("continuation-agent"),
      async fn(_context) {
        @async.pause()
        calls.push("open")
        @cli.Cli::Cli(fn() {
          calls.push("start")
          (started_session : &@cli.CliSession)
        })
      },
    )
    let make_node = fn(
      node_id : @core.NodeId,
      selected : @cli.Continuation?,
      prompt_text : String,
    ) -> @core.Node[Int, Int] raise {
      coding_agent_node(
        node_id,
        coding_agent_node_metadata(node_id.to_string()),
        CodingAgentNodeSpec::CodingAgentNodeSpec(
          agent~,
          resource_key=@core.ResourceKey::ResourceKey("continuation-resource"),
          resource_scope=@core.Node,
          open_context=fn(_context, _state) { coding_agent_open_context(group) },
          build_prompt=fn(_context, _state) { @cli.Prompt::Prompt(prompt_text) },
          select_continuation=fn(_context, _state) { selected },
          decode_response=fn(_state, response) {
            @core.NodeOutput::NodeOutput(
              None,
              Some(Json::string(response.text)),
            )
          },
        ),
      )
    }
    let first_id = @core.NodeId::NodeId("continuation-start")
    let first = make_node(first_id, None, "first")
    (first.execute)(coding_agent_node_context(group, first_id, resources), 0)
    |> ignore
    resources.release_node(first_id)
    let second_id = @core.NodeId::NodeId("continuation-resume")
    let second = make_node(second_id, Some(continuation), "second")
    (second.execute)(coding_agent_node_context(group, second_id, resources), 0)
    |> ignore
    resources.release_node(second_id)
    inspect(
      calls.join(","),
      content="open,start,prompt:started:first,open,continue,prompt:resumed:second",
    )
  }
}

///|
async test "coding_agent_node isolation 1 - different agents cannot share a caller resource key" {
  @async.with_task_group() <| group => {
    let calls : Array[String] = []
    let resources = @core.ResourceStore::ResourceStore()
    let shared_key = @core.ResourceKey::ResourceKey("shared")
    let make_node = fn(agent_name : String) -> @core.Node[Int, Int] raise {
      let agent = CodingAgent::CodingAgent(
        coding_agent_node_test_agent_id(agent_name),
        async fn(_context) {
          @async.pause()
          calls.push("open:\{agent_name}")
          @cli.Cli::Cli(fn() {
            calls.push("start:\{agent_name}")
            let session = CodingAgentNodeFakeSession::{
              label: agent_name,
              calls,
              fail_once: false,
              block_on: None,
              cleanup: [],
              continuation_value: None,
            }
            (session : &@cli.CliSession)
          })
        },
      )
      coding_agent_node(
        @core.NodeId::NodeId(agent_name),
        coding_agent_node_metadata(agent_name),
        CodingAgentNodeSpec::CodingAgentNodeSpec(
          agent~,
          resource_key=shared_key,
          resource_scope=@core.Run,
          open_context=fn(_context, _state) { coding_agent_open_context(group) },
          build_prompt=fn(_context, _state) { @cli.Prompt::Prompt("work") },
          select_continuation=fn(_context, _state) { None },
          decode_response=fn(_state, response) {
            @core.NodeOutput::NodeOutput(
              None,
              Some(Json::string(response.text)),
            )
          },
        ),
      )
    }
    let node_a = make_node("agent-a")
    let node_b = make_node("agent-b")
    (node_a.execute)(coding_agent_node_context(group, node_a.id, resources), 0)
    |> ignore
    (node_b.execute)(coding_agent_node_context(group, node_b.id, resources), 0)
    |> ignore
    resources.close_all()
    inspect(
      calls.join(","),
      content="open:agent-a,start:agent-a,prompt:agent-a:work,open:agent-b,start:agent-b,prompt:agent-b:work",
    )
  }
}

///|
async test "coding_agent_node isolation 2 - sequential graph keeps configured agents and responses separate" {
  let calls : Array[String] = []
  let responses : Array[String] = []
  let events : Array[String] = []
  let shared_key = @core.ResourceKey::ResourceKey("shared-sequential")
  let make_node = fn(
    agent_name : String,
    prompt_text : String,
  ) -> @core.Node[Int, Int] raise {
    let agent = CodingAgent::CodingAgent(
      coding_agent_node_test_agent_id(agent_name),
      async fn(_context) {
        @async.pause()
        calls.push("open:\{agent_name}")
        @cli.Cli::Cli(fn() {
          calls.push("start:\{agent_name}")
          let session = CodingAgentNodeFakeSession::{
            label: "session-\{agent_name}",
            calls,
            fail_once: false,
            block_on: None,
            cleanup: [],
            continuation_value: None,
          }
          (session : &@cli.CliSession)
        })
      },
    )
    coding_agent_node(
      @core.NodeId::NodeId(agent_name),
      coding_agent_node_metadata(agent_name),
      CodingAgentNodeSpec::CodingAgentNodeSpec(
        agent~,
        resource_key=shared_key,
        resource_scope=@core.Run,
        open_context=fn(context, _state) {
          coding_agent_open_context(context.task_group)
        },
        build_prompt=fn(_context, _state) { @cli.Prompt::Prompt(prompt_text) },
        select_continuation=fn(_context, _state) { None },
        decode_response=fn(_state, response) {
          responses.push(
            "\{response.text}:\{response.session_id.unwrap_or("missing")}",
          )
          @core.NodeOutput::NodeOutput(
            Some(1),
            Some(Json::string(response.text)),
          )
        },
      ),
    )
  }
  let node_a = make_node("agent-a", "prompt-a")
  let node_b = make_node("agent-b", "prompt-b")
  let definition = @core.GraphDefinition::GraphDefinition(
    @core.Reducer::Reducer(fn(state : Int, patch : Int) { state + patch }),
  )
  definition.add_node(node_a)
  definition.add_node(node_b)
  definition.set_router(
    node_a.id,
    @core.router([@core.DeclaredRoute::DeclaredRoute(node_b.id)], fn(
      _state,
      _completion,
    ) {
      @core.To(node_b.id)
    }),
  )
  definition.set_router(
    node_b.id,
    @core.router([], fn(_state, _completion) { @core.End }),
  )
  definition.set_entry(node_a.id)
  let runtime = @core.GraphRuntime::GraphRuntime(
    definition.compile(),
    events=@core.EventSink::EventSink(fn(event) {
      match event {
        @core.NodeStarted(_) => events.push("node-started")
        @core.NodeCompleted(_) => events.push("node-completed")
        @core.RouteSelected(_) => events.push("route-selected")
        _ => ()
      }
    }),
  )
  let result = runtime.invoke(0)
  inspect(result.steps, content="2")
  inspect(result.final_state, content="2")
  inspect(
    calls.join(","),
    content="open:agent-a,start:agent-a,prompt:session-agent-a:prompt-a,open:agent-b,start:agent-b,prompt:session-agent-b:prompt-b",
  )
  inspect(
    responses.join(","),
    content="response:prompt-a:session-agent-a,response:prompt-b:session-agent-b",
  )
  inspect(
    events.join(","),
    content="node-started,node-completed,route-selected,node-started,node-completed,route-selected",
  )
}

///|
async test "coding_agent_node continuation 2 - selected opaque continuation resumes only its configured agent" {
  let calls : Array[String] = []
  let mut selected_continuation : @cli.Continuation? = None
  let resumed_session = CodingAgentNodeFakeSession::{
    label: "session-a-resumed",
    calls,
    fail_once: false,
    block_on: None,
    cleanup: [],
    continuation_value: None,
  }
  let continuation = @cli.Continuation::Continuation(fn() {
    calls.push("continue:agent-a")
    (resumed_session : &@cli.CliSession)
  })
  let initial_session = CodingAgentNodeFakeSession::{
    label: "session-a-initial",
    calls,
    fail_once: false,
    block_on: None,
    cleanup: [],
    continuation_value: Some(continuation),
  }
  let agent_a = CodingAgent::CodingAgent(
    coding_agent_node_test_agent_id("continuation-agent-a"),
    async fn(_context) {
      @async.pause()
      calls.push("open:agent-a")
      @cli.Cli::Cli(fn() {
        calls.push("start:agent-a")
        (initial_session : &@cli.CliSession)
      })
    },
  )
  let agent_b = CodingAgent::CodingAgent(
    coding_agent_node_test_agent_id("continuation-agent-b"),
    async fn(_context) {
      @async.pause()
      calls.push("open:agent-b")
      @cli.Cli::Cli(fn() {
        calls.push("start:agent-b")
        let session = CodingAgentNodeFakeSession::{
          label: "session-b",
          calls,
          fail_once: false,
          block_on: None,
          cleanup: [],
          continuation_value: None,
        }
        (session : &@cli.CliSession)
      })
    },
  )
  let shared_key = @core.ResourceKey::ResourceKey("shared-continuation")
  let make_node = fn(
    node_id : @core.NodeId,
    agent : CodingAgent,
    prompt_text : String,
    select : () -> @cli.Continuation?,
  ) -> @core.Node[Int, Int] {
    coding_agent_node(
      node_id,
      coding_agent_node_metadata(node_id.to_string()),
      CodingAgentNodeSpec::CodingAgentNodeSpec(
        agent~,
        resource_key=shared_key,
        resource_scope=@core.Node,
        open_context=fn(context, _state) {
          coding_agent_open_context(context.task_group)
        },
        build_prompt=fn(_context, _state) { @cli.Prompt::Prompt(prompt_text) },
        select_continuation=fn(_context, _state) { select() },
        decode_response=fn(_state, response) {
          if response.continuation is Some(continuation) {
            selected_continuation = Some(continuation)
          }
          @core.NodeOutput::NodeOutput(
            Some(1),
            Some(Json::string(response.text)),
          )
        },
      ),
    )
  }
  let first_a = make_node(
    @core.NodeId::NodeId("continuation-a-start"),
    agent_a,
    "first",
    fn() { None },
  )
  let middle_b = make_node(
    @core.NodeId::NodeId("continuation-b"),
    agent_b,
    "middle",
    fn() { None },
  )
  let resumed_a = make_node(
    @core.NodeId::NodeId("continuation-a-resume"),
    agent_a,
    "second",
    fn() { selected_continuation },
  )
  let definition = @core.GraphDefinition::GraphDefinition(
    @core.Reducer::Reducer(fn(state : Int, patch : Int) { state + patch }),
  )
  definition.add_node(first_a)
  definition.add_node(middle_b)
  definition.add_node(resumed_a)
  definition.set_router(
    first_a.id,
    @core.router([@core.DeclaredRoute::DeclaredRoute(middle_b.id)], fn(
      _state,
      _completion,
    ) {
      @core.To(middle_b.id)
    }),
  )
  definition.set_router(
    middle_b.id,
    @core.router([@core.DeclaredRoute::DeclaredRoute(resumed_a.id)], fn(
      _state,
      _completion,
    ) {
      @core.To(resumed_a.id)
    }),
  )
  definition.set_router(
    resumed_a.id,
    @core.router([], fn(_state, _completion) { @core.End }),
  )
  definition.set_entry(first_a.id)
  let result = @core.GraphRuntime::GraphRuntime(definition.compile()).invoke(0)
  inspect(result.steps, content="3")
  inspect(result.final_state, content="3")
  inspect(
    calls.join(","),
    content="open:agent-a,start:agent-a,prompt:session-a-initial:first,open:agent-b,start:agent-b,prompt:session-b:middle,open:agent-a,continue:agent-a,prompt:session-a-resumed:second",
  )
}

///|
async test "coding_agent_node mutex 1 - provider error releases the retained session mutex" {
  @async.with_task_group() <| group => {
    let calls : Array[String] = []
    let resources = @core.ResourceStore::ResourceStore()
    let node_id = @core.NodeId::NodeId("mutex-retry")
    let session = CodingAgentNodeFakeSession::{
      label: "retry-session",
      calls,
      fail_once: true,
      block_on: None,
      cleanup: [],
      continuation_value: None,
    }
    let agent = CodingAgent::CodingAgent(
      coding_agent_node_test_agent_id("mutex-agent"),
      async fn(_context) {
        @async.pause()
        @cli.Cli::Cli(fn() {
          calls.push("start")
          (session : &@cli.CliSession)
        })
      },
    )
    let node : @core.Node[Int, Int] = coding_agent_node(
      node_id,
      coding_agent_node_metadata("mutex-retry"),
      CodingAgentNodeSpec::CodingAgentNodeSpec(
        agent~,
        resource_key=@core.ResourceKey::ResourceKey("mutex-retry"),
        resource_scope=@core.Run,
        open_context=fn(_context, _state) { coding_agent_open_context(group) },
        build_prompt=fn(_context, state) {
          @cli.Prompt::Prompt("attempt-\{state}")
        },
        select_continuation=fn(_context, _state) { None },
        decode_response=fn(_state, response) {
          @core.NodeOutput::NodeOutput(
            Some(1),
            Some(Json::string(response.text)),
          )
        },
      ),
    )
    let failed = try {
      (node.execute)(coding_agent_node_context(group, node_id, resources), 0)
      |> ignore
      false
    } catch {
      PromptFailed => true
      _ => false
    }
    let retried = @async.with_timeout_opt(500, async fn() {
      (node.execute)(coding_agent_node_context(group, node_id, resources), 1)
    })
    resources.close_all()
    inspect(failed, content="true")
    assert_true(retried is Some(_))
    inspect(
      calls.join(","),
      content="start,prompt:retry-session:attempt-0,prompt:retry-session:attempt-1",
    )
  }
}

///|
async test "coding_agent_node mutex 2 - concurrent callers serialize one retained session" {
  @async.with_task_group() <| group => {
    let resources = @core.ResourceStore::ResourceStore()
    let node_id = @core.NodeId::NodeId("mutex-serialization")
    let session = CodingAgentNodeSerialSession::{ active: 0, max_active: 0 }
    let agent = CodingAgent::CodingAgent(
      coding_agent_node_test_agent_id("serial-agent"),
      async fn(_context) {
        @async.pause()
        @cli.Cli::Cli(fn() { (session : &@cli.CliSession) })
      },
    )
    let node : @core.Node[Int, Int] = coding_agent_node(
      node_id,
      coding_agent_node_metadata("mutex-serialization"),
      CodingAgentNodeSpec::CodingAgentNodeSpec(
        agent~,
        resource_key=@core.ResourceKey::ResourceKey("mutex-serialization"),
        resource_scope=@core.Run,
        open_context=fn(_context, _state) { coding_agent_open_context(group) },
        build_prompt=fn(_context, state) {
          @cli.Prompt::Prompt("attempt-\{state}")
        },
        select_continuation=fn(_context, _state) { None },
        decode_response=fn(_state, response) {
          @core.NodeOutput::NodeOutput(None, Some(Json::string(response.text)))
        },
      ),
    )
    (node.execute)(coding_agent_node_context(group, node_id, resources), 0)
    |> ignore
    let first = group.spawn(async fn() {
      (node.execute)(coding_agent_node_context(group, node_id, resources), 1)
      |> ignore
    })
    while session.active == 0 {
      @async.pause()
    }
    let second = group.spawn(async fn() {
      (node.execute)(coding_agent_node_context(group, node_id, resources), 2)
      |> ignore
    })
    first.wait()
    second.wait()
    resources.close_all()
    inspect(session.max_active, content="1")
  }
}

///|
async test "coding_agent_node cancellation 1 - cleanup and cancellation propagate before mutex reuse" {
  @async.with_task_group() <| group => {
    let calls : Array[String] = []
    let cleanup : Array[String] = []
    let resources = @core.ResourceStore::ResourceStore()
    let node_id = @core.NodeId::NodeId("cancellation")
    let session = CodingAgentNodeFakeSession::{
      label: "cancel-session",
      calls,
      fail_once: false,
      block_on: Some("block"),
      cleanup,
      continuation_value: None,
    }
    let agent = CodingAgent::CodingAgent(
      coding_agent_node_test_agent_id("cancel-agent"),
      async fn(_context) {
        @async.pause()
        @cli.Cli::Cli(fn() { (session : &@cli.CliSession) })
      },
    )
    let node : @core.Node[Int, Int] = coding_agent_node(
      node_id,
      coding_agent_node_metadata("cancellation"),
      CodingAgentNodeSpec::CodingAgentNodeSpec(
        agent~,
        resource_key=@core.ResourceKey::ResourceKey("cancellation"),
        resource_scope=@core.Run,
        open_context=fn(_context, _state) { coding_agent_open_context(group) },
        build_prompt=fn(_context, state) {
          if state == 0 {
            @cli.Prompt::Prompt("block")
          } else {
            @cli.Prompt::Prompt("retry")
          }
        },
        select_continuation=fn(_context, _state) { None },
        decode_response=fn(_state, response) {
          @core.NodeOutput::NodeOutput(None, Some(Json::string(response.text)))
        },
      ),
    )
    let task = group.spawn(
      async fn() {
        (node.execute)(coding_agent_node_context(group, node_id, resources), 0)
        |> ignore
      },
      allow_failure=true,
    )
    while calls.is_empty() {
      @async.pause()
    }
    task.cancel()
    let cancelled = try {
      task.wait()
      false
    } catch {
      error => @async.is_cancellation_error(error)
    }
    let retried = @async.with_timeout_opt(500, async fn() {
      (node.execute)(coding_agent_node_context(group, node_id, resources), 1)
    })
    resources.close_all()
    inspect(cancelled, content="true")
    inspect(cleanup.join(","), content="cleanup:cancel-session")
    assert_true(retried is Some(_))
    inspect(
      calls.join(","),
      content="prompt:cancel-session:block,prompt:cancel-session:retry",
    )
  }
}

///|
async fn coding_agent_node_assert_phase(
  phase : CodingAgentNodeFailurePhase,
) -> Unit {
  @async.with_task_group() <| group => {
    let node_id = @core.NodeId::NodeId("coding-agent-phase")
    let resources = @core.ResourceStore::ResourceStore()
    let calls : Array[String] = []
    let session = CodingAgentNodeFakeSession::{
      label: "phase",
      calls,
      fail_once: phase == Prompt,
      block_on: None,
      cleanup: [],
      continuation_value: None,
    }
    let node : @core.Node[Int, Int] = coding_agent_node(
      node_id,
      coding_agent_node_metadata("coding-agent-phase"),
      CodingAgentNodeSpec::CodingAgentNodeSpec(
        agent=CodingAgent::CodingAgent(
          coding_agent_node_test_agent_id("phase-agent"),
          async fn(_context) {
            @async.pause()
            calls.push("open")
            if phase == Open {
              raise OpenFailed
            }
            @cli.Cli::Cli(fn() {
              calls.push("start")
              (session : &@cli.CliSession)
            })
          },
        ),
        resource_key=@core.ResourceKey::ResourceKey("coding-agent-phase"),
        resource_scope=@core.Node,
        open_context=(_context, _state) => {
          calls.push("open-context")
          if phase == OpenContext {
            raise OpenContextFailed
          }
          coding_agent_open_context(group)
        },
        build_prompt=(_context, _state) => {
          calls.push("build-prompt")
          if phase == PromptBuild {
            raise PromptBuildFailed
          }
          @cli.Prompt::Prompt("phase")
        },
        select_continuation=fn(_context, _state) { None },
        decode_response=(_state, _response) => {
          calls.push("decode")
          if phase == Decode {
            raise DecodeFailed
          }
          @core.NodeOutput::NodeOutput(None, None)
        },
      ),
    )
    let observed = try {
      (node.execute)(coding_agent_node_context(group, node_id, resources), 0)
      |> ignore
      false
    } catch {
      OpenContextFailed => phase == OpenContext
      OpenFailed => phase == Open
      PromptBuildFailed => phase == PromptBuild
      PromptFailed => phase == Prompt
      DecodeFailed => phase == Decode
      _ => false
    }
    resources.release_node(node_id) catch {
      _ => ()
    }
    inspect(observed, content="true")
    let expected_calls = match phase {
      OpenContext => "open-context"
      Open => "open-context,open"
      PromptBuild => "open-context,open,start,build-prompt"
      Prompt => "open-context,open,start,build-prompt,prompt:phase:phase"
      Decode => "open-context,open,start,build-prompt,prompt:phase:phase,decode"
    }
    inspect(calls.join(","), content=expected_calls)
  }
}

///|
async test "coding_agent_node errors 1 - preserves every phase failure and stops later phases" {
  coding_agent_node_assert_phase(OpenContext)
  coding_agent_node_assert_phase(Open)
  coding_agent_node_assert_phase(PromptBuild)
  coding_agent_node_assert_phase(Prompt)
  coding_agent_node_assert_phase(Decode)
}

///|
async test "coding_agent_node errors 2 - retries an open failure without caching it" {
  @async.with_task_group() <| group => {
    let node_id = @core.NodeId::NodeId("coding-agent-open-retry")
    let resources = @core.ResourceStore::ResourceStore()
    let mut opens = 0
    let calls : Array[String] = []
    let session = CodingAgentNodeFakeSession::{
      label: "retry-open",
      calls,
      fail_once: false,
      block_on: None,
      cleanup: [],
      continuation_value: None,
    }
    let node : @core.Node[Int, Int] = coding_agent_node(
      node_id,
      coding_agent_node_metadata("coding-agent-open-retry"),
      CodingAgentNodeSpec::CodingAgentNodeSpec(
        agent=CodingAgent::CodingAgent(
          coding_agent_node_test_agent_id("open-retry-agent"),
          async fn(_context) {
            @async.pause()
            opens = opens + 1
            if opens == 1 {
              raise OpenFailed
            }
            @cli.Cli::Cli(fn() { (session : &@cli.CliSession) })
          },
        ),
        resource_key=@core.ResourceKey::ResourceKey("coding-agent-open-retry"),
        resource_scope=@core.Run,
        open_context=fn(_context, _state) { coding_agent_open_context(group) },
        build_prompt=fn(_context, _state) { @cli.Prompt::Prompt("retry") },
        select_continuation=fn(_context, _state) { None },
        decode_response=fn(_state, _response) {
          @core.NodeOutput::NodeOutput(Some(1), None)
        },
      ),
    )
    let first_failed = try {
      (node.execute)(coding_agent_node_context(group, node_id, resources), 0)
      |> ignore
      false
    } catch {
      OpenFailed => true
      _ => false
    }
    let second = (node.execute)(
      coding_agent_node_context(group, node_id, resources),
      0,
    )
    resources.close_all()
    inspect(first_failed, content="true")
    inspect(opens, content="2")
    inspect(calls.join(","), content="prompt:retry-open:retry")
    debug_inspect(second.patch, content="Some(1)")
  }
}
