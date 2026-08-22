name = "totto2727/workgraph-codex-cli"

version = "0.2.1"

readme = "README.md"

repository = "https://github.com/totto2727-org/workgraph"

license = "MIT"

keywords = [ "agent", "codex", "graph", "moonbit" ]

description = "Codex CLI integration for workgraph"

import {
  "moonbitlang/async@0.21.0",
  "moonbitlang/x@0.5.1",
  "totto2727/agent-sdk@0.2.1",
  "totto2727/codex-sdk@0.4.1",
  "totto2727/workgraph-agent-cli@0.2.1",
  "totto2727/workgraph-core@0.1.4",
}

preferred_target = "wasm"

supported_targets = "+wasm+native"

source = "src"
