---
title: "ヘッドレスセッション終了時の非同期フック未キャンセル問題を修正"
date: 2026-01-29
tags: ['バグ修正', 'hooks', 'ヘッドレス', 'メモリリーク']
---

## 原文（日本語に翻訳）

ヘッドレスストリーミングセッションが終了したときに、保留中の非同期フックがキャンセルされない問題を修正

## 原文（英語）

Fixed pending async hooks not being cancelled when headless streaming sessions ended

## 概要

ヘッドレスモード（`--headless`）でClaude Codeを使用した際に、セッションが終了してもバックグラウンドで実行中の非同期フックがキャンセルされずに残り続ける問題が修正されました。この問題により、不要なプロセスがメモリに残ったり、リソースが適切に解放されなかったりする可能性がありましたが、v2.1.23では確実にクリーンアップされるようになりました。特にCI/CD環境や自動化スクリプトでの使用において、重要な改善となります。

## 基本的な使い方

この修正は自動的に適用されるため、ユーザー側での特別な設定は不要です。ヘッドレスモードでClaude Codeを使用する際、セッション終了時にすべての非同期処理が適切にクリーンアップされます。

### ヘッドレスモードの基本

```bash
# ヘッドレスモードで実行
claude --headless "タスクを実行"

# セッション終了時、すべてのフックが自動的にキャンセルされる
```

## 実践例

### CI/CDパイプラインでの使用

修正前は、パイプラインが完了してもバックグラウンドプロセスが残ることがありました。

```yaml
# .github/workflows/code-review.yml
name: Code Review

on: [pull_request]

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Run Claude Code Review
        run: |
          claude --headless "Review the changes in this PR"
          # v2.1.23では、このステップ完了時にすべてのフックが確実に終了

      - name: Next step
        run: echo "前のステップのフックは完全にクリーンアップ済み"
```

### カスタムフックを使用した自動化

非同期フックを設定している場合の動作改善：

```json
// ~/.claude/settings.json
{
  "hooks": {
    "onToolCall": {
      "command": "node ~/scripts/log-tool-usage.js",
      "async": true
    },
    "onComplete": {
      "command": "node ~/scripts/notify-completion.js",
      "async": true
    }
  }
}
```

```bash
# v2.1.22以前の問題
claude --headless "ファイルを解析"
# セッション終了後も、非同期フックのプロセスが残る可能性があった

# v2.1.23以降
claude --headless "ファイルを解析"
# セッション終了時、すべての非同期フックが確実にキャンセルされる
```

### バッチ処理スクリプト

複数のタスクを連続実行する場合のメモリリーク防止：

```bash
#!/bin/bash
# batch-process.sh

files=(
  "src/auth.ts"
  "src/api.ts"
  "src/database.ts"
)

for file in "${files[@]}"; do
  echo "Processing $file..."
  claude --headless "Review and optimize $file"
  # v2.1.23では、各反復後にメモリが適切に解放される
done

echo "All files processed without memory leaks"
```

### 長時間実行されるサーバーでの使用

```javascript
// server.js - Claude Codeを統合したWebサーバー
const { spawn } = require('child_process');

app.post('/api/analyze', async (req, res) => {
  const claude = spawn('claude', [
    '--headless',
    `Analyze: ${req.body.code}`
  ]);

  let output = '';

  claude.stdout.on('data', (data) => {
    output += data.toString();
  });

  claude.on('close', (code) => {
    // v2.1.23では、プロセス終了時にすべてのフックが確実に終了
    res.json({ analysis: output });
  });

  // タイムアウト処理
  setTimeout(() => {
    claude.kill(); // フックも含めてすべて終了される
  }, 30000);
});
```

## 注意点

- この修正はv2.1.23で導入されたため、以前のバージョンでは依然として問題が発生する可能性があります
- ヘッドレスモードを頻繁に使用するCI/CD環境では、v2.1.23以降へのアップグレードを強く推奨します
- カスタムフックが長時間実行される処理を行う場合、適切なタイムアウト設定を検討してください
- 非同期フックが外部リソース（データベース、API）にアクセスする場合、接続のクリーンアップを適切に実装してください
- この修正により、ヘッドレスセッションの終了がわずかに遅くなる可能性がありますが、リソースリークを防ぐために重要です
- Docker環境でClaude Codeを使用する場合、コンテナ終了時のグレースフルシャットダウンが改善されます

## 関連情報

- [Claude Code Hooks ドキュメント](https://code.claude.com/docs/hooks)
- [Node.js 非同期処理のベストプラクティス](https://nodejs.org/en/docs/guides/blocking-vs-non-blocking/)
- [メモリリークの検出と防止](https://nodejs.org/en/docs/guides/simple-profiling/)
- [Changelog v2.1.23](https://github.com/anthropics/claude-code/releases/tag/v2.1.23)
- CI/CD環境でのClaude Code使用については、公式ドキュメントの「ヘッドレスモード」セクションを参照してください
