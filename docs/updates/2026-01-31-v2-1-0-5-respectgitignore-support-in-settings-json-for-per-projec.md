---
title: "@メンションファイルピッカーのrespectGitignore設定を追加"
date: 2026-01-31
tags: ['新機能', '設定', 'セキュリティ']
---

## 原文（日本語に翻訳）

@メンションファイルピッカーの動作をプロジェクトごとに制御するための `respectGitignore` 設定を `settings.json` に追加しました

## 原文（英語）

Added `respectGitignore` support in `settings.json` for per-project control over @-mention file picker behavior

## 概要

Claude Code v2.1.0で導入された、.gitignoreファイルの尊重設定です。`settings.json` に `respectGitignore` フィールドを追加することで、@メンションでファイルを選択する際に.gitignoreのルールを適用するかをプロジェクトごとに制御できます。セキュリティ上重要な設定で、.envファイルなどの機密情報を含むファイルへのアクセスを制限できます。

## 基本的な使い方

`.claude/settings.json` に `respectGitignore` 設定を追加します。

```json
{
  "respectGitignore": true
}
```

この設定により、@メンションでファイルを選択する際、.gitignoreに記載されたファイルが候補から除外されます。

```bash
# .gitignoreの例
.env
node_modules/
dist/

# Claude Code起動後、@メンションでファイル選択
# → .env、node_modules/、dist/ 内のファイルは表示されない
```

## 実践例

### 機密ファイルの保護

.envファイルなどの機密情報を含むファイルをClaude Codeから保護します。

```json
{
  "respectGitignore": true
}
```

```bash
# .gitignore
.env
.env.local
credentials.json
secrets/
```

@メンションで上記のファイルは選択できなくなります。

### パーミッション設定との併用

より強固なセキュリティのため、パーミッション設定と併用します。

```json
{
  "respectGitignore": true,
  "permissions": {
    "Read": {
      "deny": [".env", "credentials.json"]
    }
  }
}
```

**重要**: 2026年1月時点で、.gitignoreの尊重だけでは不十分な場合があります。Claude CodeはRead()ツール使用時に.gitignoreを迂回できるバグが報告されているため、**パーミッション設定による明示的な拒否が推奨されます**。

### プロジェクトごとの設定

プロジェクトの特性に応じて設定を使い分けます。

```json
// セキュリティ重視プロジェクト
{
  "respectGitignore": true,
  "permissions": {
    "Read": {
      "deny": [".env*", "*.key", "*.pem"]
    }
  }
}
```

```json
// 開発用プロジェクト（柔軟性重視）
{
  "respectGitignore": false
}
```

## 注意点

- この機能は Claude Code v2.1.0（2026年1月7日リリース）で導入されました
- **重要なセキュリティ問題**: 2026年1月時点で、Claude Codeは.gitignoreを完全に尊重しない場合があります
  - .envファイルが.gitignoreに含まれていても、Read()ツールで読み取れてしまうバグが報告されています
  - 間接的なプロンプトインジェクション攻撃により、機密情報が漏洩するリスクがあります
- **推奨される対策**: `respectGitignore` だけでなく、`permissions` 設定で明示的に機密ファイルを拒否してください
- パーミッション設定は結合され、プロジェクトレベルの拒否はローカル許可で上書きできません（セキュリティポリシーの強制）
- 設定の優先順位: プロジェクト設定 (`.claude/settings.json`) > グローバル設定 (`~/.claude/settings.json`)
- CI/CDパイプラインや共有開発環境でClaude Codeを使用する場合は、特に注意が必要です

## 関連情報

- [Claude Code Settings Documentation](https://code.claude.com/docs/en/settings)
- [Organizing Personal and Project Settings](https://egghead.io/organizing-personal-and-project-settings-in-claude-code~q7qsw)
- [Claude Code ignores ignore rules (The Register)](https://www.theregister.com/2026/01/28/claude_code_ai_secrets_files)
- [Securing Claude Code: Protecting Sensitive Files](https://www.devproblems.com/securing-claude-code-protecting-your-sensitive-files-like-env/)
