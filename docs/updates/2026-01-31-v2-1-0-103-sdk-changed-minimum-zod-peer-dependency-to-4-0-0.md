---
title: "[SDK] zodのpeer dependencyの最小バージョンを^4.0.0に変更"
date: 2026-01-31
tags: ['変更', 'SDK', '依存関係', 'Zod']
---

## 原文（日本語に翻訳）

[SDK] zodのpeer dependencyの最小バージョンを^4.0.0に変更しました

## 原文（英語）

[SDK] Changed minimum zod peer dependency to ^4.0.0

## 概要

Claude Code SDK v2.1.0で変更された、Zodライブラリの最小バージョン要件です。以前のバージョンでは、Zod v3系もサポートしていましたが、新機能でZod v4の機能を使用するため、最小バージョンが^4.0.0に引き上げられました。この変更により、最新のZod機能を活用した、より安全で型安全なスキーマ検証が可能になりました。

## 変更内容

```json
// package.json（変更前）
{
  "peerDependencies": {
    "zod": "^3.0.0"
  }
}

// package.json（変更後）
{
  "peerDependencies": {
    "zod": "^4.0.0"
  }
}
```

## 実践例

### SDKプロジェクトのアップグレード

```bash
# 既存プロジェクト
npm install @anthropic-ai/claude-code-sdk@latest

# Zodのバージョン確認
npm ls zod
# zod@3.22.0 ← 古いバージョン

# Zodをアップグレード
npm install zod@^4.0.0

# ✓ SDK v2.1.0で使用可能
```

### 新しいZod機能の利用

```typescript
import { z } from 'zod';

// Zod v4の新機能
const schema = z.object({
  name: z.string().brand<'UserName'>(),
  email: z.string().email(),
  age: z.number().positive(),
});

// SDK内で型安全なバリデーション
type User = z.infer<typeof schema>;
```

## 注意点

- Claude Code SDK v2.1.0で変更
- 影響:
  - SDK使用プロジェクトはZod v4が必要
  - Zod v3を使用中の場合はアップグレードが必要
- アップグレード方法:
  ```bash
  npm install zod@^4.0.0
  # または
  yarn add zod@^4.0.0
  ```
- 互換性:
  - Zod v3からv4は大部分が互換
  - 破壊的変更は最小限
  - [Zod移行ガイド](https://zod.dev/migration)参照
- 旧バージョンの使用:
  - SDK v2.0.x を使い続ければZod v3で動作
  - ただし新機能は利用不可

## 関連情報

- [Claude Code SDK - npm](https://www.npmjs.com/package/@anthropic-ai/claude-code-sdk)
- [Zod v4 documentation](https://zod.dev)
- [Migration guide](https://zod.dev/migration)
