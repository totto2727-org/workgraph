name = "totto2727/workgraph-visualization"

version = "0.2.0"

readme = "README.md"

repository = "https://github.com/totto2727-org/workgraph"

license = "MIT"

keywords = [ "graph", "mermaid", "moonbit", "visualization" ]

description = "Runtime-independent workgraph visualization"

preferred_target = "wasm"

supported_targets = "js+native+wasm"

import {
  "moonbitlang/async@0.22.10",
  "totto2727/workgraph-core@0.2.0",
}

source = "src"
