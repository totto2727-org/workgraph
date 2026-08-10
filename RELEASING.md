# Releasing Workgraph

Publishing is selected only by a push to `main`, and the shared `publish-moonbit` action handles future publication. The workflow declares no deployment gate and has no `workflow_dispatch` trigger, input, confirmation value, or shell guard. This migration supplies no credentials and performs no registry mutation.

The split-repository dependency contract is `totto2727/any-collection@0.2.1`, `totto2727/lens@0.4.1`, `totto2727/x@0.2.0`, and `totto2727/geo@0.1.2` before `totto2727/admiral@0.6.2`, which must be available before the Workgraph `0.1.3` release. Future coordinated releases may then publish `totto2727/bw@0.2.2`, `totto2727/wt@0.1.3`, and `totto2727/mdt@0.1.7`.

The guarded release order is:

1. `totto2727/workgraph-core@0.1.3`
2. `totto2727/workgraph-agent-cli@0.1.3`
3. `totto2727/workgraph-llm@0.1.3`
4. `totto2727/workgraph-visualization@0.1.3`
5. `totto2727/workgraph-codex-cli@0.1.3`
6. `totto2727/workgraph-opencode-cli@0.1.3`

The workflow checks every manifest and package listing before publishing each frozen module in this order. Do not bypass the dependency order or publish from a local migration checkout.
