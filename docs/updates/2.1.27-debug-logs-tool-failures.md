---
title: "デバッグログにツール呼び出しの失敗と拒否を追加"
date: 2025-01-27
tags: [debugging, logging, tool-calls]
---

## 原文（日本語訳）

デバッグログにツール呼び出しの失敗と拒否を追加

## 原文（英語）

Added tool call failures and denials to debug logs

## 概要

Claude Codeのデバッグログに、ツール呼び出しが失敗した場合や拒否された場合の詳細情報が記録されるようになりました。これにより、問題のトラブルシューティングや、なぜ特定のツールが実行されなかったのかを理解しやすくなります。

## 基本的な使い方

デバッグモードを有効にして、ツール呼び出しのログを確認できます。

```bash
# デバッグモードでClaude Codeを起動
ANTHROPIC_LOG=debug claude
```

ログファイルは `~/.claude/debug.log` に保存されます。

## 実践例

### ツール呼び出しの失敗を調査する

開発中に特定のツールが動作しない場合、デバッグログで詳細を確認できます。

```bash
# デバッグログをリアルタイムで監視
tail -f ~/.claude/debug.log
```

### パーミッション拒否の理由を確認

ツール実行が拒否された場合、その理由をログで確認できます。

```bash
# ログから拒否されたツール呼び出しを検索
grep "denied" ~/.claude/debug.log
```

### カスタムフックのデバッグ

フックが期待通りに動作しない場合、ツール呼び出しの詳細ログで問題を特定できます。

```bash
# 特定のツール名でフィルタリング
grep "tool_name.*Bash" ~/.claude/debug.log
```

## 注意点

- デバッグログには機密情報が含まれる可能性があるため、共有する際は注意してください
- `ANTHROPIC_LOG=debug` を設定するとログファイルのサイズが大きくなる可能性があります
- 本番環境では通常デバッグモードを無効にしておくことを推奨します

## 関連情報

- [Claude Code デバッグガイド](https://code.claude.com/docs/en/debugging)
- [ツールパーミッション管理](https://code.claude.com/docs/en/permissions)
- [フック設定](https://code.claude.com/docs/en/hooks)
