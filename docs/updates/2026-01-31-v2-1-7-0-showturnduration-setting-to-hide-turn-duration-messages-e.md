---
title: "ターン実行時間の表示を制御する設定を追加"
date: 2026-01-14
tags: ['新機能', '設定', 'UI']
---

## 原文（日本語に翻訳）

ターン実行時間のメッセージ（例：「Cooked for 1m 6s」）を非表示にする`showTurnDuration`設定を追加しました。

## 原文（英語）

Added `showTurnDuration` setting to hide turn duration messages (e.g., "Cooked for 1m 6s")

## 概要

Claude Codeの各応答（ターン）の最後に表示される実行時間メッセージを非表示にできる設定です。デフォルトでは「Cooked for 1m 6s」のようなメッセージが表示されますが、このメッセージが不要な場合や、よりクリーンな出力を求める場合に無効化できます。

## 基本的な使い方

設定ファイル（`~/.claude/settings.json`）で以下のように設定します。

### 実行時間メッセージを非表示にする

```json
{
  "showTurnDuration": false
}
```

### デフォルト（表示する）

```json
{
  "showTurnDuration": true
}
```

または、設定を省略した場合もデフォルトで表示されます。

## 実践例

### スクリーンショットやログを共有する場合

プレゼンテーションや技術ブログで Claude Code の出力を共有する際、実行時間メッセージが不要な場合があります。

```json
{
  "showTurnDuration": false
}
```

この設定により、出力が以下のようにクリーンになります。

**設定前:**
```
Here's the solution to your problem...

Cooked for 1m 6s
```

**設定後:**
```
Here's the solution to your problem...
```

### CI/CDパイプラインでの使用

自動化されたスクリプトやCI/CDパイプラインでClaude Codeを使用する場合、実行時間メッセージはログを冗長にする可能性があります。

```json
{
  "showTurnDuration": false
}
```

### パフォーマンス計測時

逆に、Claude Codeの応答速度を計測したい場合は、この設定を`true`（デフォルト）のままにしておくことで、各ターンの実行時間を簡単に確認できます。

```json
{
  "showTurnDuration": true
}
```

## 注意点

- **デフォルトは表示**: 設定を省略した場合、実行時間メッセージは表示されます
- **リアルタイム反映**: 設定変更後、次のターンから即座に反映されます
- **情報価値**: 実行時間メッセージは、複雑なタスクがどれだけ時間を要したかを把握するのに役立つため、特別な理由がない限り表示を推奨します

## 関連情報

- [Claude Code 設定ガイド](https://code.claude.com/docs/)
- [Changelog v2.1.7](https://github.com/anthropics/claude-code/releases/tag/v2.1.7)
