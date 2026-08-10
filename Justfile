check:
    moon check

test:
    moon test

package-list:
    for module in package/workgraph-core package/workgraph-agent-cli package/workgraph-llm package/workgraph-visualization package/workgraph-codex-cli package/workgraph-opencode-cli; do (cd "$module" && moon package --list); done
