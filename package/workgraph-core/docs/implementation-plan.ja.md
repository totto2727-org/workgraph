# Workgraphパッケージ分割記録

## 結果

従来の単一グラフモジュールを、targetを個別指定できる6つのMoonBitモジュールへ分割しました。ランタイム非依存コードはnative専用CLI依存を継承しません。

## パッケージ境界

```text
package/
├── workgraph-core/
│   └── src/examples/basic/
├── workgraph-agent-cli/
├── workgraph-llm/
│   ├── src/examples/basic/
│   └── src/test/
├── workgraph-visualization/
│   └── src/examples/basic/
├── workgraph-codex-cli/
│   ├── src/examples/basic/
│   └── src/test/
└── workgraph-opencode-cli/
    ├── src/examples/basic/
    └── src/test/
```

coreは識別子、グラフ構築とコンパイル、ランタイムのstate reducer、イベント、coding-agent契約、インメモリresource storeを所有します。LLM SDKやCLI SDKはインポートしません。

`workgraph-agent-cli`、`workgraph-llm`、`workgraph-visualization`はそれぞれcoreをインポートします。CodexとOpenCodeはcoreとagent CLIに加え、対応するCLI SDKだけをインポートします。

## Targetポリシー

- `workgraph-core`、`workgraph-agent-cli`、`workgraph-llm`、`workgraph-visualization`はpreferred targetとsupported targetを宣言せず、互換性を制限せずに既定のWasm GC backendを使用します。
- `workgraph-codex-cli`と`workgraph-opencode-cli`は、公開済みSDK依存がnative専用のため、nativeをpreferred targetおよびsupported targetとします。

## テストの所有

unit testは実装ファイルの隣に置きます。LLM provider、Codex CLI、OpenCode CLIのintegration testは、所有モジュールの`src/test`パッケージに置きます。従来の共有testing helperとモジュール横断E2E workflowは、削除した集約workflow suite専用だったため削除しました。

## Examples

- coreは基本グラフとインメモリresourceのexampleを提供します。
- LLMは認証不要の`mizchi/llm.MockProvider`グラフexampleを提供します。
- visualizationはMermaid exampleを提供します。
- CodexとOpenCodeはそれぞれ実CLIを使うcoding-agent graph exampleを提供します。
- codingは両CLIモジュールから利用されるため、単独exampleを持ちません。

## 検証

```bash
vp run mbt:check
vp run mbt:build
vp run mbt:test
moon run package/workgraph-llm/src/examples/basic
moon run --target native package/workgraph-codex-cli/src/examples/basic
moon run --target native package/workgraph-opencode-cli/src/examples/basic
```
