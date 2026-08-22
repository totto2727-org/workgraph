name = "totto2727/workgraph-visualization"

version = "0.1.4"

readme = "README.md"

repository = "https://github.com/totto2727-org/workgraph"

license = "MIT"

keywords = [ "graph", "mermaid", "moonbit", "visualization" ]

description = "Runtime-independent workgraph visualization"

preferred_target = "wasm"

supported_targets = "js+native+wasm"

import {
  "moonbitlang/async@0.21.0",
  "totto2727/workgraph-core@0.1.4",
}

source = "src"
