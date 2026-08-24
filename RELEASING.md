# Releasing Workgraph

Publishing is selected only by a push to `main`, and the shared `publish-moonbit` action handles future publication. The workflow declares no deployment gate and has no `workflow_dispatch` trigger, input, confirmation value, or shell guard. This migration supplies no credentials and performs no registry mutation.

The split-repository dependency contract starts with `totto2727/any-collection@0.2.2`, `totto2727/lens@0.4.3`, `totto2727/x@0.6.1`, `totto2727/geo@0.1.3`, and `mizchi/tui@0.10.0`. Publish `totto2727/codex-sdk@0.4.1` and `totto2727/opencode-sdk@0.4.1` before `totto2727/agent-sdk@0.2.1`; publish `totto2727/admiral@0.6.5` before `totto2727/bw@0.2.3` and `totto2727/wt@0.1.4`. The coordinated ecosystem release also includes `totto2727/mdt@0.1.10`. The Workgraph `0.1.4` and `0.2.1` modules are released only after their `any-collection`, `agent-sdk`, and provider SDK pins are available.

The guarded release order is:

1. `totto2727/workgraph-core@0.1.4`
2. `totto2727/workgraph-agent-cli@0.2.1`
3. `totto2727/workgraph-llm@0.1.4`
4. `totto2727/workgraph-visualization@0.1.4`
5. `totto2727/workgraph-codex-cli@0.2.1`
6. `totto2727/workgraph-opencode-cli@0.2.1`

The workflow checks every manifest and package listing before publishing each frozen module in this order. Do not bypass the dependency order or publish from a local migration checkout.
