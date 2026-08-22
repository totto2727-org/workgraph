name = "totto2727/workgraph-core"

version = "0.1.4"

readme = "README.md"

repository = "https://github.com/totto2727-org/workgraph"

license = "MIT"

keywords = [ "agent", "graph", "runtime", "moonbit" ]

description = "Runtime-independent asynchronous graph compiler and runtime"

preferred_target = "wasm"

supported_targets = "js+native+wasm"

import {
  "Yoorkin/any@0.2.1",
  "moonbitlang/async@0.21.0",
  "totto2727/any-collection@0.2.2",
}

source = "src"
