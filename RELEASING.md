# Releasing Workgraph

Publishing is intentionally available only through the protected manual GitHub Actions workflow. The `release` environment must require approval, and the operator must type `PUBLISH` before any authenticated command can run.

External prerequisites must already be available from the Mooncakes registry: `totto2727/any-collection@0.2.0`, `totto2727/codex-sdk@0.1.2`, and `totto2727/opencode-sdk@0.2.2`. A future coordinated release may upgrade the external any-collection dependency to `0.2.1`; this migration does not introduce that unpublished dependency.

The guarded release order is:

1. `totto2727/workgraph-core@0.1.3`
2. `totto2727/workgraph-agent-cli@0.1.3`
3. `totto2727/workgraph-llm@0.1.3`
4. `totto2727/workgraph-visualization@0.1.3`
5. `totto2727/workgraph-codex-cli@0.1.3`
6. `totto2727/workgraph-opencode-cli@0.1.3`

The workflow checks every manifest and package listing before publishing each frozen module in this order. Do not bypass the order or publish from a local migration checkout.
