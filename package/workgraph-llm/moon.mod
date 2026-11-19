name = "totto2727/workgraph-llm"

version = "0.2.0"

readme = "README.md"

repository = "https://github.com/totto2727-org/workgraph"

license = "MIT"

keywords = [ "agent", "graph", "llm", "moonbit" ]

description = "Runtime-independent typed LLM nodes for workgraph"

preferred_target = "js"

supported_targets = "js+native+wasm"

import {
  "totto2727/llm@0.3.3",
  "moonbitlang/regexp@0.3.7",
  "moonbitlang/async@0.22.9",
  "totto2727/workgraph-core@0.2.0",
}

source = "src"
