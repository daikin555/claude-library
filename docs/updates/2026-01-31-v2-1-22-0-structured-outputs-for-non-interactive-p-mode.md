---
title: "非対話モードでの構造化出力の修正"
date: 2026-01-28
tags: ['バグ修正', '非対話モード', 'CLI']
---

## 原文（日本語に翻訳）

非対話モード（-pフラグ）での構造化出力が正しく動作しない問題を修正

## 原文（英語）

Fixed structured outputs for non-interactive (-p) mode

## 概要

Claude Code v2.1.22では、非対話モード（`-p`または`--print`フラグ）で実行した際に、構造化されたJSON出力が正しく生成されない問題が修正されました。この修正により、スクリプトやCI/CDパイプラインなどの自動化されたワークフローで、Claude Codeからの出力を確実にパースできるようになりました。

## 基本的な使い方

非対話モードは、Claude Codeを対話的なターミナルセッションではなく、プログラムとして実行するためのモードです。

```bash
# 基本的な非対話モードの使用
claude -p "このディレクトリ内のPythonファイルを一覧表示して"

# パイプ入力と組み合わせた使用
echo "README.mdの内容を要約して" | claude

# 構造化されたJSON出力を取得
claude -p "src/ディレクトリの構造を説明して" --output-format=stream-json
```

v2.1.22以前は、このモードでJSON出力が破損したり、正しく構造化されない場合がありました。この修正により、安定したJSON出力が保証されます。

## 実践例

### CI/CDパイプラインでのコード分析

GitHub ActionsやGitLab CIなどのCI/CDパイプラインで、Claude Codeを使ってコードレビューや分析を自動化できます。

```yaml
# .github/workflows/code-review.yml
name: Automated Code Review
on: [pull_request]

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run Claude Code Analysis
        run: |
          claude -p "変更されたファイルをレビューして、潜在的な問題を報告して" \
            --output-format=stream-json > review-results.json
      - name: Parse Results
        run: |
          # JSON出力が正しく構造化されているため、jqでパース可能
          jq '.messages[] | select(.role == "assistant") | .content' review-results.json
```

### スクリプトによる一括処理

複数のファイルやディレクトリを一括処理するシェルスクリプトで使用できます。

```bash
#!/bin/bash
# batch-analyze.sh

for file in src/**/*.js; do
  echo "Analyzing $file..."
  result=$(claude -p "このJavaScriptファイルのコード品質を評価して: @$file" --output-format=stream-json)

  # v2.1.22の修正により、JSON出力が確実にパース可能
  echo "$result" | jq -r '.messages[-1].content' > "reports/$(basename $file .js)-analysis.txt"
done
```

### プログラムからのAPI的な使用

Node.jsやPythonなどのプログラムから、Claude Codeを子プロセスとして呼び出す場合に有効です。

```javascript
// Node.jsでの使用例
const { spawn } = require('child_process');

async function analyzCodeWithClaude(prompt) {
  return new Promise((resolve, reject) => {
    const claude = spawn('claude', ['-p', prompt, '--output-format=stream-json']);
    let output = '';

    claude.stdout.on('data', (data) => {
      output += data.toString();
    });

    claude.on('close', (code) => {
      if (code === 0) {
        try {
          // v2.1.22の修正により、JSON.parseが確実に成功
          const result = JSON.parse(output);
          resolve(result);
        } catch (err) {
          reject(err);
        }
      } else {
        reject(new Error(`Claude exited with code ${code}`));
      }
    });
  });
}

// 使用例
analyzCodeWithClaude('リポジトリ内のセキュリティ問題を検出して')
  .then(result => console.log(result.messages))
  .catch(err => console.error(err));
```

### レポート生成の自動化

定期的なコード品質レポートの生成に利用できます。

```bash
#!/bin/bash
# daily-report.sh

# プロジェクト全体の分析を実行
claude -p "プロジェクト全体のコード品質を分析し、改善点をリストアップして" \
  --output-format=stream-json | \
  jq -r '.messages[] | select(.role == "assistant") | .content' > daily-report-$(date +%Y%m%d).md

# Slackに通知
# (JSON出力が正しく構造化されているため、後処理が容易)
```

## 注意点

- この修正はClaude Code v2.1.22で適用されました
- 非対話モードを使用する際は、`-p`または`--print`フラグが必要です
- `--output-format=stream-json`を指定することで、ストリーミング形式のJSON出力を取得できます（v0.2.66で追加された機能）
- v2.1.22以前のバージョンでは、JSON出力が破損する可能性があるため、自動化スクリプトでは最新版の使用を推奨します
- 非対話モードでは、MCP（Model Context Protocol）サーバーが保留状態になる問題がありましたが、これはv2.0.67で修正されています

## 関連情報

- [Claude Code 公式ドキュメント](https://code.claude.com/docs/)
- [Changelog v2.1.22](https://github.com/anthropics/claude-code/releases/tag/v2.1.22)
- [非対話モードに関する過去の改善 (v0.2.66)](https://github.com/anthropics/claude-code/releases/tag/v0.2.66) - `--output-format=stream-json`のサポート追加
- [v2.0.67でのMCPサーバー関連の修正](https://github.com/anthropics/claude-code/releases/tag/v2.0.67)
