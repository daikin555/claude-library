---
title: "PreToolUseフックでask決定時のupdatedInputを許可"
date: 2026-01-31
tags: ['改善', 'hooks', 'セキュリティ', 'パーミッション']
---

## 原文（日本語に翻訳）

PreToolUseフックで `ask` パーミッション決定を返す際に `updatedInput` を許可するよう修正しました。これにより、フックがミドルウェアとして機能しつつ、ユーザーの同意を求めることができます

## 原文（英語）

Fixed PreToolUse hooks to allow `updatedInput` when returning `ask` permission decision, enabling hooks to act as middleware while still requesting user consent

## 概要

Claude Code v2.1.0で修正された、PreToolUseフックの機能拡張です。`ask` パーミッション決定を返す際に `updatedInput` フィールドを使用できるようになり、フックがツール入力を修正しつつ、最終的な実行前にユーザーの承認を求めることが可能になりました。これにより、自動的なセキュリティ修正とユーザー確認を組み合わせた、より安全で透明性の高いワークフローを実現できます。

## 基本的な使い方

PreToolUseフックで `decision: "ask"` と `updatedInput` を組み合わせて返します。

```javascript
// .claude/hooks/preToolUse.js
module.exports = async (params) => {
  const { tool, input } = params;

  if (tool === "Bash" && input.command.includes("rm -rf")) {
    // 危険なコマンドを安全版に修正し、ユーザーに確認を求める
    return {
      decision: "ask",
      reason: "危険な 'rm -rf' を対話モード 'rm -ri' に変更しました。実行してよろしいですか？",
      updatedInput: {
        command: input.command.replace("rm -rf", "rm -ri")
      }
    };
  }

  return { decision: "approve" };
};
```

## 実践例

### 安全なファイル削除の強制

危険な削除コマンドを対話モードに自動変更し、ユーザーに確認を求めます。

```javascript
// .claude/hooks/preToolUse.js
module.exports = async ({ tool, input }) => {
  if (tool === "Bash" && /rm\s+-rf/.test(input.command)) {
    const safeCommand = input.command.replace(/rm\s+-rf/, "rm -ri");

    return {
      decision: "ask",
      reason: `セキュリティ: '-rf'を'-ri'に変更しました\n元: ${input.command}\n新: ${safeCommand}`,
      updatedInput: { command: safeCommand }
    };
  }

  return { decision: "approve" };
};
```

ユーザーには以下のように表示されます：
```
セキュリティ: '-rf'を'-ri'に変更しました
元: rm -rf /tmp/old-files
新: rm -ri /tmp/old-files

このコマンドを実行しますか？ [y/N]
```

### URLの自動HTTPSアップグレード

HTTPリクエストを自動的にHTTPSに変更し、ユーザーに通知します。

```javascript
module.exports = async ({ tool, input }) => {
  if (tool === "Bash" && input.command.includes("curl http://")) {
    const secureCommand = input.command.replace(/http:\/\//g, "https://");

    return {
      decision: "ask",
      reason: "HTTP を HTTPS にアップグレードしました（セキュリティ向上）",
      updatedInput: { command: secureCommand }
    };
  }

  return { decision: "approve" };
};
```

### Git強制プッシュの安全化

force pushに --force-with-lease を追加し、ユーザーに確認を求めます。

```javascript
module.exports = async ({ tool, input }) => {
  if (tool === "Bash" && /git\s+push.*--force(?!\-)/.test(input.command)) {
    const saferCommand = input.command.replace("--force", "--force-with-lease");

    return {
      decision: "ask",
      reason: "--force を --force-with-lease に変更（リモートの変更を保護）",
      updatedInput: { command: saferCommand }
    };
  }

  return { decision: "approve" };
};
```

### チーム規約の自動適用

コードフォーマッターのオプションを規約に準拠させます。

```javascript
module.exports = async ({ tool, input }) => {
  if (tool === "Bash" && input.command.startsWith("prettier")) {
    // チームの標準オプションを追加
    const enhancedCommand = `${input.command} --single-quote --trailing-comma all`;

    return {
      decision: "ask",
      reason: "チーム規約のPrettierオプションを追加しました",
      updatedInput: { command: enhancedCommand }
    };
  }

  return { decision: "approve" };
};
```

## 注意点

- この機能は Claude Code v2.1.0（2026年1月7日リリース）で導入されました
- v2.0.10以降、PreToolUseフックはツール実行前に入力を修正できます
- `updatedInput` は `Record<string, unknown>` 型のオブジェクトで、変更または追加したいフィールドを含めます
- `decision: "ask"` と `updatedInput` を組み合わせることで：
  - 自動的にセキュリティ修正を適用
  - 修正内容をユーザーに明示
  - ユーザーの最終承認を得てから実行
- `decision: "approve"` と `updatedInput` を使用すると、ユーザー確認なしに自動修正されます
- `decision: "block"` の場合、`updatedInput` は無視されます
- この機能により、「ブロックして訂正」サイクルを避け、トークン使用量を削減できます
- Hooksは以下を実現します：
  - 透明なサンドボックス化
  - 自動セキュリティ強制
  - チーム規約の遵守
  - 開発者体験の向上

## 関連情報

- [Get started with Claude Code hooks](https://code.claude.com/docs/en/hooks-guide)
- [Secure Your Claude Skills with Custom PreToolUse Hooks](https://egghead.io/secure-your-claude-skills-with-custom-pre-tool-use-hooks~dhqko)
- [A complete guide to hooks in Claude Code](https://www.eesel.ai/blog/hooks-in-claude-code)
- [Claude Code hooks mastery (GitHub)](https://github.com/disler/claude-code-hooks-mastery)
