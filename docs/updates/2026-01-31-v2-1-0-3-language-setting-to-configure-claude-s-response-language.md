---
title: "Claudeの応答言語を設定するlanguage設定を追加"
date: 2026-01-31
tags: ['新機能', '設定', '国際化']
---

## 原文（日本語に翻訳）

Claudeの応答言語を設定するための `language` 設定を追加しました（例: language: "japanese"）

## 原文（英語）

Added `language` setting to configure Claude's response language (e.g., language: "japanese")

## 概要

Claude Code v2.1.0で導入された言語設定機能です。`settings.json` に `language` フィールドを追加することで、Claude Codeの応答言語をグローバルに設定できます。日本語、スペイン語などの言語を指定可能で、CLAUDE.mdファイルで毎回指定する必要がなくなります。特に日本語ユーザーにとって、コンパクション後に突然英語に切り替わる問題が解消される大きな改善です。

## 基本的な使い方

`~/.claude/settings.json` に `language` フィールドを追加して、Claude Codeの応答言語を設定します。

```json
{
  "language": "japanese"
}
```

設定後、Claude Codeを起動すると、すべての応答が指定した言語で返されます。

```bash
# Claude Codeを起動
claude

# すべての応答が日本語で返される
# セッション中に言語が切り替わることはない
```

## 実践例

### 日本語での一貫した会話

日本語を設定することで、セッション全体を通じて日本語で会話できます。

```json
{
  "language": "japanese",
  "model": "sonnet"
}
```

これにより、以下のような状況でも日本語が維持されます：
- コンパクション（会話履歴の要約）後
- 長い会話の継続中
- エラーメッセージの表示時

### スペイン語チームでの利用

多言語チームでスペイン語を共通言語として設定します。

```json
{
  "language": "spanish"
}
```

### プロジェクトごとの言語設定

プロジェクト固有の言語設定は `.claude/settings.json` で上書きできます。

```json
{
  "language": "french"
}
```

グローバル設定は日本語、特定プロジェクトのみフランス語といった使い分けが可能です。

## 注意点

- この機能は Claude Code v2.1.0（2026年1月7日リリース）で導入されました
- 設定可能な言語: "japanese"、"spanish"、"french"、"german"など（自然言語名で指定）
- グローバル設定 (`~/.claude/settings.json`) とプロジェクト設定 (`.claude/settings.json`) の両方で指定可能
- プロジェクト設定はグローバル設定を上書きします
- この設定により、CLAUDE.mdファイルで「常に日本語で会話する」のような指示を記述する必要がなくなります
- 日本語ユーザーにとって特に有用: コンパクション後にClaudeが英語を話し始める問題が解消されます
- 言語設定はモデル選択などの他の設定と併用できます

## 関連情報

- [Claude Code の言語を settings.json で設定する](https://yaakai.to/note/129)
- [Claude Codeに言語設定が自由入力できると聞いて](https://posfie.com/@ftnext/p/0i7ESmk)
- [Claude Code 2.1.0 Release Notes](https://hyperdev.matsuoka.com/p/claude-code-210-ships)
