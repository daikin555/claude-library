---
title: "ローカルスラッシュコマンド実行時のスピナー表示を修正"
date: 2026-01-14
tags: ['バグ修正', 'UI', 'コマンド']
---

## 原文（日本語に翻訳）

`/model`や`/theme`のようなローカルスラッシュコマンドを実行する際に、スピナーが一瞬表示される問題を修正しました。

## 原文（英語）

Fixed spinner briefly flashing when running local slash commands like `/model` or `/theme`

## 概要

`/model`, `/theme`, `/help`などのローカルで即座に実行されるスラッシュコマンドを実行した際、不必要にローディングスピナーが一瞬表示されるUI上の問題が修正されました。これらのコマンドはAPI呼び出しを必要としないため、スピナー表示は不要でした。

## 問題の詳細

### ローカルスラッシュコマンドとは

以下のコマンドはローカルで即座に実行され、APIリクエストを必要としません：

- `/model` - モデルの切り替え
- `/theme` - テーマの変更
- `/help` - ヘルプの表示
- `/clear` - 会話履歴のクリア
- `/context` - コンテキスト情報の表示

### 修正前の動作

```
ユーザー: /model haiku

⟳ Loading... (0.1秒表示)
✓ Switched to Claude 3 Haiku
```

一瞬のスピナー表示により、UIがちらついて見えました。

### 修正後の動作

```
ユーザー: /model haiku

✓ Switched to Claude 3 Haiku
(スピナーなし、即座に結果表示)
```

## 実践例

### モデル切り替え

**修正前:**
```
/model sonnet
⟳ (チラッ)
✓ Switched to Claude 3.5 Sonnet
```

**修正後（v2.1.7）:**
```
/model sonnet
✓ Switched to Claude 3.5 Sonnet
```

### テーマ変更

**修正前:**
```
/theme dark
⟳ (チラッ)
✓ Theme changed to dark
```

**修正後（v2.1.7）:**
```
/theme dark
✓ Theme changed to dark
```

### ヘルプ表示

**修正前:**
```
/help
⟳ (チラッ)
Available commands: ...
```

**修正後（v2.1.7）:**
```
/help
Available commands: ...
```

## 技術的な改善点

- **条件付きスピナー**: APIリクエストが必要なコマンドのみスピナーを表示
- **即座のフィードバック**: ローカルコマンドは遅延なく結果を表示
- **視覚的な改善**: UIのちらつきが削減され、よりスムーズな操作感

## 影響を受けるコマンド

スピナーが表示されなくなったローカルコマンド：

- `/model <model-name>` - モデル選択
- `/theme <theme-name>` - テーマ切り替え
- `/help` - ヘルプ表示
- `/clear` - 会話クリア
- `/context` - コンテキスト情報
- `/tasks` - タスク一覧
- その他のローカル設定コマンド

引き続きスピナーが表示されるコマンド（API呼び出しが必要）：

- `/commit` - コミット作成
- `/review-pr` - PR レビュー
- その他のAI処理を伴うコマンド

## 注意点

- **視覚的な変更のみ**: 機能自体に変更はありません
- **即座の応答**: ローカルコマンドは引き続き即座に実行されます
- **ネットワークコマンドは変更なし**: API呼び出しを伴うコマンドは引き続きスピナーが表示されます

## 関連情報

- [スラッシュコマンド一覧](https://code.claude.com/docs/)
- [Changelog v2.1.7](https://github.com/anthropics/claude-code/releases/tag/v2.1.7)
