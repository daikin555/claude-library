---
title: "VSCode拡張機能：長時間セッション後のOAuthトークン失効による401エラーを修正"
date: 2026-01-30
tags: ['バグ修正', 'VSCode', 'OAuth', '認証']
---

## 原文（日本語に翻訳）

VSCode: 長時間のセッション後にOAuthトークンの有効期限切れで発生する401エラーを修正

## 原文（英語）

VSCode: Fixed OAuth token expiration causing 401 errors after extended sessions

## 概要

VSCode拡張機能で長時間セッションを実行している際に、OAuthトークンの有効期限が切れて401認証エラーが発生する問題が修正されました。これにより、長時間のコーディングセッションでも中断されることなく、安定してClaude Codeを使用できるようになります。

## 問題の背景

v2.1.27以前では、以下のような問題が発生していました：

- 長時間（数時間以上）のセッション中にOAuthトークンが失効
- 突然の401認証エラーでタスクが中断
- `/login`コマンドで再認証してもセッションが回復しない
- 進行中の作業コンテキストが失われる

## 修正内容

v2.1.27では以下が改善されました：

- トークンの自動更新メカニズムの実装
- セッション中のトークン失効の検出と適切な処理
- エラー発生時の自動リトライ機能
- ユーザーエクスペリエンスの向上

## 実践例

### 長時間の開発セッション

大規模なリファクタリングやコードレビューなど、数時間にわたる作業でも中断されません：

```
# VSCodeでClaude Code拡張機能を使用
# 3時間以上のセッションでも安定して動作
1. プロジェクトを開く
2. Claude Code拡張機能を起動
3. 長時間のタスクを実行（例：大規模リファクタリング）
4. トークン更新が自動的に行われる
```

### 自動化タスクの実行

CI/CDパイプラインやバックグラウンドタスクでの使用：

```typescript
// VSCodeタスク設定例
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Claude Code Review",
      "type": "shell",
      "command": "claude -p 'このPRをレビューしてください'",
      "problemMatcher": []
    }
  ]
}
```

長時間実行されるタスクでも、トークン失効による中断がなくなります。

### 夜間バッチ処理

夜間に実行される自動テストやドキュメント生成などのバッチ処理：

```bash
# 夜間実行スクリプト
#!/bin/bash
# 数時間かかるタスクでも安定動作
claude -p "全テストを実行してカバレッジレポートを生成"
claude -p "APIドキュメントを更新"
claude -p "パフォーマンステストを実行"
```

### チーム開発での共有セッション

ペアプログラミングやコードレビューセッション中も安定：

```
1. VSCodeでLive Shareセッションを開始
2. Claude Code拡張機能を使用
3. 長時間のペアプログラミングセッションを実施
4. トークン失効の心配なし
```

## トラブルシューティング

もし401エラーが発生した場合（v2.1.27でも稀に発生する可能性）：

1. **手動再ログイン：**
   ```bash
   /logout
   # VSCodeを再起動
   # 拡張機能で再度ログイン
   ```

2. **認証情報のクリア：**
   ```bash
   rm -rf ~/.config/claude-code/auth.json
   # VSCodeを再起動
   ```

3. **拡張機能の再インストール：**
   - VSCodeの拡張機能パネルから Claude Code を削除
   - 再インストール
   - 再度ログイン

## VSCode拡張機能の設定

安定したセッションのための推奨設定：

```json
// settings.json
{
  "claude-code.enableAutoSave": true,
  "claude-code.sessionPersistence": true,
  "claude-code.autoReconnect": true
}
```

## 注意点

- この修正はVSCode拡張機能に特化したものです
- CLI版やDesktop版では別のトークン管理メカニズムが使用されています
- 企業のプロキシやファイアウォール環境では、追加の設定が必要な場合があります
- OAuth認証を使用している場合のみ適用されます（APIキー認証は対象外）
- 非常に長時間（24時間以上）のセッションでは、定期的な再認証が推奨されます

## 影響を受けるユーザー

この修正により改善されるケース：

- VSCode拡張機能で長時間作業するユーザー
- 自動化タスクやCI/CDでVSCodeを使用しているチーム
- ペアプログラミングセッションを頻繁に行うチーム
- 夜間バッチ処理でClaude Codeを使用している環境

## 関連修正

以前のバージョンで報告されていた関連Issue：

- [OAuth token expiration disrupts autonomous workflows](https://github.com/anthropics/claude-code/issues/12447)
- [OAuth token expires mid-session with no recovery path](https://github.com/anthropics/claude-code/issues/18444)
- [401 error after re-authentication in VSCode](https://github.com/anthropics/claude-code/issues/17966)

## 関連情報

- [Use Claude Code in VS Code - Claude Code Docs](https://code.claude.com/docs/en/vs-code)
- [Troubleshooting - Claude Code Docs](https://code.claude.com/docs/en/troubleshooting)
- [Changelog v2.1.27](https://github.com/anthropics/claude-code/releases/tag/v2.1.27)
