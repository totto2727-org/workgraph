name = "totto2727/workgraph-llm"

version = "0.1.3"

readme = "README.md"

repository = "https://github.com/totto2727-org/workgraph"

license = "MIT"

keywords = [ "agent", "graph", "llm", "moonbit" ]

description = "Runtime-independent typed LLM nodes for workgraph"

import {
  "mizchi/llm@0.3.1",
  "moonbitlang/async@0.20.3",
  "totto2727/workgraph-core@0.1.3",
}

preferred_target = "native"

supported_targets = "+native+js"

source = "src"
