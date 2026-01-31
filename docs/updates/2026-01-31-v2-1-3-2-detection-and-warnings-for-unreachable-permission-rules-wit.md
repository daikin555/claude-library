---
title: "到達不能なパーミッションルールの検出と警告"
date: 2026-01-09
tags: ['新機能', 'パーミッション', '診断', 'セキュリティ']
---

## 原文（日本語に翻訳）

到達不能なパーミッションルールの検出と警告機能を追加しました。`/doctor` および保存時に警告が表示され、各ルールのソースと実行可能な修正ガイダンスが含まれます

## 原文（英語）

Added detection and warnings for unreachable permission rules, with warnings in `/doctor` and after saving rules that include the source of each rule and actionable fix guidance

## 概要

Claude Code v2.1.3では、到達不能（デッドコード化）したパーミッションルールを自動検出し、警告を表示する機能が追加されました。`/doctor` コマンドでの診断時や、ルール保存時に問題が検出された場合、どのルールが問題か、どこで定義されているか、どう修正すべきかが明確に示されます。これにより、意図しないパーミッション設定のミスを早期に発見できます。

## 基本的な使い方

パーミッションルールの問題を診断するには、`/doctor` コマンドを実行します。

```bash
# システム診断を実行
/doctor

# 到達不能なルールがある場合、警告が表示される
# 例：
# ⚠️ Unreachable permission rule detected
# Source: .claude/settings.json:15
# Fix: Remove or reorder this rule
```

## 実践例

### 到達不能なルールの例

より広範なルールが先に定義されている場合、後続のルールが到達不能になります。

```json
// ❌ 悪い例：2つ目のルールに到達しない
{
  "permissions": [
    {
      "tool": "Bash",
      "prompt": "*",  // すべてのBashコマンドを許可
      "action": "allow"
    },
    {
      "tool": "Bash",
      "prompt": "npm install",  // このルールには到達しない
      "action": "deny"
    }
  ]
}

// ✅ 良い例：より具体的なルールを先に配置
{
  "permissions": [
    {
      "tool": "Bash",
      "prompt": "npm install",
      "action": "deny"
    },
    {
      "tool": "Bash",
      "prompt": "*",
      "action": "allow"
    }
  ]
}
```

### `/doctor` での診断

定期的に `/doctor` を実行して、設定の健全性をチェックします。

```bash
# 診断実行
/doctor

# 出力例：
# ✅ No unreachable permission rules
# または
# ⚠️ Found 2 unreachable permission rules:
#   1. .claude/settings.json:25 - "npm test" rule is shadowed by "*" rule at line 20
#      Fix: Move this rule before the wildcard rule
#   2. .claude/project.json:10 - "git push" rule is redundant
#      Fix: Remove this duplicate rule
```

### 保存時の自動検証

パーミッションルールを編集して保存すると、自動的に検証が実行されます。

```bash
# 設定ファイルを編集後
# 保存時に自動的に警告が表示される

# 例：
# 💾 Saved settings
# ⚠️ Warning: 1 unreachable rule detected
#   - Line 30: This rule will never match because of the rule at line 15
#   - Suggestion: Reorder rules to fix
```

## 注意点

- パーミッションルールは上から順に評価されるため、順序が重要です
- より具体的なルールは、より一般的なルール（ワイルドカード `*` など）より前に配置してください
- 同じツール・プロンプトの組み合わせで複数のルールがある場合、最初にマッチしたルールのみが適用されます
- `/doctor` を定期的に実行して、設定の健全性を確認することを推奨します

## 関連情報

- [Claude Code 公式ドキュメント](https://claude.ai/code)
- [Changelog v2.1.3](https://github.com/anthropics/claude-code/releases/tag/v2.1.3)
- [パーミッション設定ガイド](https://github.com/anthropics/claude-code)
- [セキュリティベストプラクティス](https://github.com/anthropics/claude-code)
