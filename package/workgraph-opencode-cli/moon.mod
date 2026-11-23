name = "totto2727/workgraph-opencode-cli"

version = "0.3.0"

readme = "README.md"

repository = "https://github.com/totto2727-org/workgraph"

license = "MIT"

keywords = [ "agent", "graph", "moonbit", "opencode" ]

description = "OpenCode CLI integration for workgraph"

import {
  "moonbitlang/async@0.22.10",
  "moonbitlang/x@0.5.8",
  "totto2727/agent-sdk@0.2.2",
  "totto2727/opencode-sdk@0.4.2",
  "totto2727/workgraph-agent-cli@0.3.0",
  "totto2727/workgraph-core@0.2.0",
}

preferred_target = "wasm"

supported_targets = "+wasm+native"

source = "src"
