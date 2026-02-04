---
title: "`/plan` コマンドショートカットでプロンプトから直接プランモードを起動"
date: 2026-01-31
tags: ['新機能', 'コマンド', 'プランモード']
---

## 原文（日本語に翻訳）

プロンプトから直接プランモードを有効化できる `/plan` コマンドショートカットを追加しました

## 原文（英語）

Added `/plan` command shortcut to enable plan mode directly from the prompt

## 概要

Claude Code v2.1.0で導入された、プランモードへの素早いアクセス機能です。従来はプランモードを有効にするために設定変更やCLIフラグが必要でしたが、`/plan`コマンドを使うことで、対話中にいつでも即座にプランモードに切り替えられるようになりました。プランモードでは、Claudeが実装を開始する前に詳細な計画を作成し、ユーザーの承認を得てから実行するため、大規模な変更でも安心して任せられます。

## 基本的な使い方

Claude Codeの対話モードで `/plan` コマンドを入力します。

```bash
# Claude Code起動
claude

# プランモードに切り替え
> /plan

# プランモードが有効化される
# Claudeは次のリクエストに対して実装計画を作成
```

## 実践例

### 大規模な機能追加の計画作成

新機能の実装前に、詳細な計画を確認してから作業を開始します。

```bash
> /plan
# Plan mode enabled

> ユーザー認証機能を追加して

# Claudeがプランを作成:
# Plan:
# 1. Install required packages (bcrypt, jsonwebtoken)
# 2. Create User model with password hashing
# 3. Implement /register endpoint
# 4. Implement /login endpoint with JWT
# 5. Create authentication middleware
# 6. Add password validation
# 7. Write tests for auth endpoints
#
# Files to create:
# - src/models/User.js
# - src/routes/auth.js
# - src/middleware/auth.js
# - tests/auth.test.js
#
# Files to modify:
# - package.json
# - src/app.js
#
# Approve plan? (yes/no)

> yes

# 承認後、Claudeがプランに従って実装を開始
```

### リファクタリングの影響範囲確認

大規模なリファクタリング前に、変更範囲を確認します。

```bash
> /plan

> このコンポーネントをHooksベースにリファクタリング

# Claudeがプランを作成:
# Plan:
# 1. Convert class component to functional component
# 2. Replace componentDidMount with useEffect
# 3. Replace this.state with useState hooks
# 4. Update event handlers to use arrow functions
# 5. Update prop access (remove 'this')
# 6. Update tests for new component structure
#
# Files to modify:
# - src/components/UserProfile.jsx (main changes)
# - src/components/UserProfile.test.jsx (test updates)
#
# Estimated changes: ~150 lines
#
# Approve plan? (yes/no)

# プランを確認して承認
> yes
```

### 複数ファイルの変更計画

複数ファイルにまたがる変更の全体像を把握します。

```bash
> /plan

> APIエンドポイントをv1からv2に移行

# Plan:
# 1. Create new API v2 routes structure
# 2. Implement backward compatibility middleware
# 3. Update API versioning in headers
# 4. Migrate endpoint implementations:
#    - /users -> /v2/users (add pagination)
#    - /posts -> /v2/posts (add filtering)
#    - /comments -> /v2/comments (add sorting)
# 5. Update OpenAPI documentation
# 6. Add deprecation warnings to v1
# 7. Update integration tests
#
# Files to create:
# - src/routes/v2/users.js
# - src/routes/v2/posts.js
# - src/routes/v2/comments.js
# - src/middleware/apiVersion.js
# - docs/api-v2.yaml
#
# Files to modify:
# - src/app.js (add v2 routes)
# - src/routes/v1/users.js (add deprecation)
# - tests/integration/api.test.js
#
# Approve plan? (yes/no)

# プランが期待と異なる場合、修正を依頼できる
> いや、v1は deprecated にするだけで、完全移行はまだしないで

# Claudeがプランを修正
```

## 注意点

- この機能は Claude Code v2.1.0（2026年1月7日リリース）で導入されました
- `/plan` コマンドの動作:
  - コマンド入力後、プランモードが有効化される
  - 次のユーザー入力に対して、Claudeが実装計画を作成
  - 計画にはファイル変更、新規作成、削除が含まれる
  - ユーザーが承認するまで、実際のコード変更は行われない
- プランモードとの違い:
  - `--plan` フラグ: Claude Code起動時から常にプランモード
  - `/plan` コマンド: 対話中に動的に切り替え
- プランモードの切り替え:
  ```bash
  # プランモード有効化
  > /plan

  # 次のリクエストでプランが作成される
  > <実装依頼>

  # プラン承認後、通常モードに戻る
  # 再度プランモードにするには /plan を再入力
  ```
- プランの承認/却下:
  - `yes` / `y`: プランを承認して実装開始
  - `no` / `n`: プランを却下
  - プランの修正を依頼することも可能
- プランモードのメリット:
  - 大規模な変更の全体像を事前に把握
  - 意図しない変更を防ぐ
  - 変更範囲の見積もり
  - 代替案の検討
- デメリット:
  - 小さな変更には冗長
  - プラン作成に追加時間がかかる
- 推奨される使用ケース:
  - 5ファイル以上の変更
  - 新機能の追加
  - アーキテクチャの変更
  - リファクタリング
  - 依存関係の更新

## 関連情報

- [Plan mode - Claude Code Docs](https://code.claude.com/docs/en/plan-mode)
- [Interactive mode](https://code.claude.com/docs/en/interactive-mode)
- [Slash commands](https://code.claude.com/docs/en/slash-commands)
