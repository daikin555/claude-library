---
title: "折りたたみ表示のRead/Searchグループで進行中は現在形、完了後は過去形を表示"
date: 2026-01-27
tags: ['UI変更', 'ツール表示', 'ユーザー体験']
---

## 原文（日本語に翻訳）

折りたたまれたread/searchグループで、進行中は現在形（「Reading」「Searching for」）、完了時は過去形（「Read」「Searched for」）を表示するよう変更

## 原文（英語）

Changed collapsed read/search groups to show present tense ("Reading", "Searching for") while in progress, and past tense ("Read", "Searched for") when complete

## 概要

Claude Code v2.1.20では、複数のファイル読み込みや検索操作がグループ化されて表示される際の表現が改善されました。以前は、操作の進行状況に関わらず一貫した表記でしたが、この変更により、実行中は現在形（Reading、Searching for）、完了後は過去形（Read、Searched for）で表示されるようになります。これにより、タスクの状態が文法的にも視覚的にも明確になり、より自然な英語表現でステータスが伝わります。

## 基本的な使い方

ファイル操作時、自動的に適切な時制で表示されます：

```bash
# 複数ファイルを読み込む指示
> src/ ディレクトリの全てのファイルを確認して

# 実行中（現在形）：
▼ Reading 15 files...
  - src/app.js
  - src/utils.js
  - src/config.js
  ...

# 完了後（過去形）：
▶ Read 15 files
```

## 実践例

### 大量のファイル読み込み

プロジェクト全体のコードレビュー時：

```bash
> このプロジェクトの全てのTypeScriptファイルをレビューして

# 読み込み開始時（現在形）：
▼ Reading 47 TypeScript files...
  src/components/Header.tsx
  src/components/Footer.tsx
  src/utils/helpers.ts
  ...

# 変更の利点：
# - "Reading" = 今まさに読み込んでいる
# - 進行中であることが文法的に明確
# - リアルタイム感がある

# 読み込み完了後（過去形）：
▶ Read 47 TypeScript files

# 変更の利点：
# - "Read" = 読み込みが完了した
# - 過去の操作であることが明確
# - 折りたたんで次のステップに集中できる
```

### コードベース全体の検索

特定のパターンを大規模検索：

```bash
> プロジェクト全体から "TODO" コメントを検索して

# 検索中（現在形）：
▼ Searching for "TODO" in 230 files...
  Found in src/app.js (3 matches)
  Found in src/api/users.js (1 match)
  Scanning src/utils/...

# 変更により：
# - "Searching for" = 検索が進行中
# - アクティブな操作であることが伝わる
# - 待機する必要があることが明確

# 検索完了後（過去形）：
▶ Searched for "TODO" in 230 files (12 matches)

# 変更により：
# - "Searched for" = 検索が終了
# - 結果を確認できる状態
# - 次のアクションに移れる
```

### 複数のグループ化されたツール実行

エージェントが複数の操作を順次実行：

```bash
> この機能の全ての関連ファイルを確認して、依存関係を分析して

# ステップ1: ファイル読み込み（進行中）
▼ Reading 8 related files...
  components/UserProfile.tsx
  hooks/useUser.ts
  ...

# ステップ2: 依存関係検索（進行中）
▼ Searching for imports in 8 files...
  Analyzing dependencies...

# ステップ1完了（過去形に変化）
▶ Read 8 related files

# ステップ2完了（過去形に変化）
▶ Searched for imports in 8 files

# 変更の効果：
# - 各ステップの状態が一目瞭然
# - 完了したタスクと進行中のタスクを区別しやすい
# - 会話履歴を振り返った時も、何が終わったか明確
```

### 長時間実行される検索操作

大規模コードベースでの詳細検索：

```bash
> 全てのAPIエンドポイント定義を見つけて

# 大量のファイルをスキャン中（現在形）
▼ Searching for API endpoints in 500+ files...
  Progress: 150/500 files scanned...
  Progress: 300/500 files scanned...
  Progress: 450/500 files scanned...

# 変更前の問題：
# - 完了後も「Searching」のまま
# - 本当に終わったのか不明確

# 変更後（完了時に過去形）：
▶ Searched for API endpoints in 523 files (45 endpoints found)

# 改善点：
# - 検索が完全に終了したことが明確
# - 結果の確認に集中できる
```

### 折りたたみ表示との連携

会話履歴を整理する際：

```bash
# 会話履歴の中で：

[1] ▶ Read 15 configuration files
    # 過去形 → このステップは完了している

[2] ▼ Reading 8 test files...
    # 現在形 → このステップは進行中

[3] [ ] Next: Analyze test coverage
    # 未実行 → これから実行

# 変更により：
# - 時制で進行状況が一目で分かる
# - スクロールバックして確認する際も状態が明確
# - 長いセッションでも追跡しやすい
```

### リアルタイムフィードバック

ユーザーがプロセスを監視する場合：

```bash
> データベーススキーマファイルを全て読み込んで分析

# リアルタイム表示（現在形）：
▼ Reading database schema files...
  ✓ migrations/001_initial.sql
  ✓ migrations/002_users.sql
  ⏳ migrations/003_products.sql  # 読み込み中
  ⏸ migrations/004_orders.sql    # 待機中
  ⏸ migrations/005_payments.sql  # 待機中

# 完了後（過去形）：
▶ Read 5 database schema files

# 改善効果：
# - 進行中: "Reading" + リアルタイム進捗
# - 完了後: "Read" + 要約結果
# - ステータスの変化が自然で直感的
```

## 注意点

- この変更は、折りたたみ可能なツールグループ表示にのみ適用されます
- 単一のファイル読み込みや検索には影響しません
- 英語の文法ルールに従った自然な表現になります
- 日本語UIの場合も、英語の時制に相当する表現が使用されます
- 折りたたみ・展開の動作自体は変更されていません

## 関連情報

- [Tool Execution Display](https://code.claude.com/docs/en/reference/tool-display)
- [Read Tool](https://code.claude.com/docs/en/reference/tools#read)
- [Grep Tool](https://code.claude.com/docs/en/reference/tools#grep)
- [UI Improvements](https://code.claude.com/docs/en/whats-new#ui-improvements)
- [Changelog v2.1.20](https://github.com/anthropics/claude-code/releases/tag/v2.1.20)
