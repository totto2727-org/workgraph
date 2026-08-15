///|
pub struct CodingAgentNodeSpec[S, P] {
  agent : CodingAgent
  resource_key : @core.ResourceKey
  resource_scope : @core.ResourceScope
  open_context : (@core.NodeContext, S) -> CodingAgentOpenContext raise
  build_prompt : (@core.NodeContext, S) -> @cli.Prompt raise
  select_continuation : (@core.NodeContext, S) -> @cli.Continuation? raise
  decode_response : (S, @cli.FinalResponse) -> @core.NodeOutput[P] raise
}

///|
/// Creates the callbacks and resource policy used by a coding-agent node.
pub fn[S, P] CodingAgentNodeSpec::CodingAgentNodeSpec(
  agent~ : CodingAgent,
  resource_key~ : @core.ResourceKey,
  resource_scope~ : @core.ResourceScope,
  open_context~ : (@core.NodeContext, S) -> CodingAgentOpenContext raise,
  build_prompt~ : (@core.NodeContext, S) -> @cli.Prompt raise,
  select_continuation~ : (@core.NodeContext, S) -> @cli.Continuation? raise,
  decode_response~ : (S, @cli.FinalResponse) -> @core.NodeOutput[P] raise,
) -> CodingAgentNodeSpec[S, P] {
  CodingAgentNodeSpec::{
    agent,
    resource_key,
    resource_scope,
    open_context,
    build_prompt,
    select_continuation,
    decode_response,
  }
}

///|
priv struct CodingAgentResource {
  session : &@cli.CliSession
  mutex : @async.Mutex
}

///|
impl Debug for CodingAgentResource with fn to_repr(_self) {
  @debug.Repr::literal("CodingAgentResource")
}

///|
extenum @any.Payload += {
  CodingAgentResource(CodingAgentResource)
}

///|
impl @any.Anyable for CodingAgentResource with fn iso() {
  {
    id: @any.TypeId::TypeId(
      "totto2727/workgraph-agent-cli",
      "CodingAgentResource",
      [],
    ),
    box: resource => CodingAgentResource(resource),
    unbox: payload => {
      guard payload is CodingAgentResource(resource)
      resource
    },
  }
}

///|
fn coding_agent_resource_ref(
  key : @core.ResourceKey,
  agent_id : CodingAgentId,
) -> @any_collection.AnyRef[@core.ResourceKey, CodingAgentResource] raise {
  let agent = agent_id.to_string()
  let composite_key = @core.ResourceKey::ResourceKey(
    "coding-agent:\{agent.length()}:\{agent}:\{key.to_string()}",
  )
  @any_collection.AnyRef::AnyRef(composite_key)
}

///|
/// Create a graph node that acquires an agent SDK session, serializes a prompt, and decodes its final response.
pub fn[S, P] coding_agent_node(
  id : @core.NodeId,
  metadata : @core.NodeMetadata,
  spec : CodingAgentNodeSpec[S, P],
) -> @core.Node[S, P] {
  @core.Node::Node(id, metadata, async fn(context, state) {
    let open_context = (spec.open_context)(context, state)
    let reference = coding_agent_resource_ref(spec.resource_key, spec.agent.id)
    let open_resource = async fn() {
      let cli = (spec.agent.open)(open_context)
      let session = match (spec.select_continuation)(context, state) {
        Some(continuation) => cli.continue_session(continuation)
        None => cli.start()
      }
      CodingAgentResource::{ session, mutex: @async.Mutex::Mutex() }
    }
    let resource = match spec.resource_scope {
      @core.Node =>
        context.resources.acquire_resource(
          reference,
          @core.Node,
          open_resource,
          fn(_resource) { () },
          owner=context.node_id,
        )
      @core.Run =>
        context.resources.acquire_resource(
          reference,
          @core.Run,
          open_resource,
          fn(_resource) { () },
        )
    }
    let prompt = (spec.build_prompt)(context, state)
    resource.mutex.acquire()
    defer resource.mutex.release()
    let response = resource.session.prompt(prompt)
    (spec.decode_response)(state, response)
  })
}
