---
title: "再開画面でのセッションタイトルの言語設定対応の修正"
date: 2026-01-22
tags: ['バグ修正', 'UI', '国際化']
---

## 原文（日本語に翻訳）

再開画面のセッションタイトルがユーザーの言語設定を尊重していない問題を修正しました

## 原文（英語）

Fixed session titles on the resume screen not respecting the user's language setting

## 概要

Claude Code v2.1.16では、セッション再開画面に表示されるセッションタイトルが、ユーザーの言語設定を無視して常に英語で表示される不具合が修正されました。この修正により、日本語などの非英語言語を設定しているユーザーも、セッションタイトルが設定した言語で正しく表示されるようになりました。これにより、セッション管理がより直感的になり、ユーザーエクスペリエンスが向上しました。

## 基本的な使い方

特別な操作は不要です。言語設定が正しく行われていれば、自動的に適用されます。

### 言語設定の確認

現在の言語設定を確認：

```bash
# 設定画面を開く
/config

# language設定を確認
```

### 言語設定の変更

日本語に設定する場合：

```bash
# CLIで設定ファイルを編集
# ~/.claude/settings.json または .claude/settings.json

{
  "language": "japanese"
}
```

または、対話的に設定：

```bash
/config
→ language: japanese
```

## 実践例

### 日本語環境での使用

言語設定を日本語にした場合のセッションタイトル表示：

```
修正前:
  /resume
  → Session 1: "Refactor authentication system"
  → Session 2: "Fix database connection issue"
  → Session 3: "Add new feature"

修正後:
  /resume
  → セッション 1: "認証システムのリファクタリング"
  → セッション 2: "データベース接続の問題修正"
  → セッション 3: "新機能の追加"
```

### セッション名の検索

日本語のセッションタイトルで検索が可能に：

```bash
# 再開画面で検索
/resume
→ 検索バーに「認証」と入力
→ 「認証システムのリファクタリング」がヒット
```

### 複数言語環境での作業

異なる言語設定の環境間でセッションを共有：

```
# 自宅（日本語設定）
/resume
→ "ユーザー登録機能の実装"

# 会社（英語設定）
/resume
→ "Implement user registration feature"

# 同じセッションでも、言語設定に応じてタイトルが翻訳される
```

## 注意点

- **自動生成タイトル**: セッションタイトルが自動生成される場合、設定した言語で生成されます。手動で設定したタイトルはそのまま保持されます
- **既存セッション**: v2.1.16より前に作成されたセッションのタイトルは、英語のままの場合があります。`/rename` コマンドで変更できます
- **言語設定の優先順位**: プロジェクト設定 > ユーザー設定の順で適用されます
- **サポート言語**: 現在サポートされている言語は、公式ドキュメントで確認してください

### セッション名の変更

既存のセッションタイトルを変更する：

```bash
# セッション内で名前を変更
/rename "新しいセッション名"

# または、再開画面から変更
/resume
→ セッションを選択
→ R キーを押して名前変更
```

### 言語設定のベストプラクティス

```json
// プロジェクト固有の設定（.claude/settings.json）
{
  "language": "japanese"
}

// ユーザーグローバル設定（~/.claude/settings.json）
{
  "language": "japanese"
}
```

## 関連情報

- [Claude Code 公式ドキュメント - 言語設定](https://code.claude.com/docs/en/settings#language)
- [セッション管理について](https://code.claude.com/docs/en/sessions)
- [設定ファイルのカスタマイズ](https://code.claude.com/docs/en/settings)
- [Changelog v2.1.16](https://github.com/anthropics/claude-code/releases/tag/v2.1.16)
