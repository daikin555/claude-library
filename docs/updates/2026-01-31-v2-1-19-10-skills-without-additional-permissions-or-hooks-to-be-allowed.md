---
title: "追加のパーミッションやフックを持たないスキルは承認不要で使用可能に変更"
date: 2026-01-23
tags: ['変更', 'スキル', 'パーミッション', 'セキュリティ']
---

## 原文（日本語に翻訳）

追加のパーミッションやフックを必要としないスキルは、承認なしで使用できるように変更しました。

## 原文（英語）

Changed skills without additional permissions or hooks to be allowed without requiring approval

## 概要

Claude Code v2.1.19で導入された動作変更です。追加のパーミッション（ツールアクセス制限など）やフック（on-invoke、on-complete など）を定義していないシンプルなスキルは、ユーザーの明示的な承認なしで自動的に使用できるようになりました。これにより、基本的なプロンプトテンプレートやガイドラインを提供するだけのスキルを、よりスムーズに利用できます。

## 基本的な使い方

以下のようなシンプルなスキルは自動承認されます。

**自動承認されるスキルの例:**

```yaml
# .claude/skills/explain-code/SKILL.md
---
name: explain-code
description: コードの詳細な説明を生成する
argument-hint: [ファイルパス]
---

# コード説明タスク

$0 のコードを読んで、以下の観点で詳しく説明してください:

1. 全体的な目的と機能
2. 主要なロジックフロー
3. 使用されている重要な技術やパターン
4. 潜在的な改善点

説明は初心者にも分かりやすく、具体例を含めてください。
```

このスキルはパーミッションもフックも定義していないため、承認なしで即座に使用できます。

**承認が必要なスキルの例:**

```yaml
# .claude/skills/deploy/SKILL.md
---
name: deploy
description: 本番環境にデプロイする
allowed-tools: Bash(*)  # ← パーミッション定義
hooks:
  on-invoke: .claude/skills/deploy/on-invoke.sh  # ← フック定義
---

本番環境へのデプロイを実行します。
```

このスキルは追加のパーミッションとフックを持つため、引き続き承認が必要です。

## 実践例

### ドキュメント生成スキル

```yaml
# .claude/skills/document/SKILL.md
---
name: document
description: コードドキュメントを生成
argument-hint: [ファイルまたはディレクトリ]
---

# ドキュメント生成

$0 の包括的なドキュメントを生成してください:

## 構成
- 主要な関数/クラスの説明
- パラメータと戻り値の説明
- 使用例
- 注意事項

形式: JSDoc/docstring/コメント形式で既存ファイルに追加
```

**使用例:**

```bash
/document src/utils/parser.js
```

承認プロンプトなしで即座に実行されます。

### コードレビューテンプレート

```yaml
# .claude/skills/review-checklist/SKILL.md
---
name: review-checklist
description: コードレビューチェックリストを適用
agent: Explore
context: fork
---

# コードレビュー

以下のチェックリストに基づいてコードをレビューしてください:

## セキュリティ
- [ ] 入力検証は適切か
- [ ] 認証・認可は正しく実装されているか
- [ ] 機密情報の露出はないか

## パフォーマンス
- [ ] 不要なループや計算はないか
- [ ] データベースクエリは最適化されているか
- [ ] メモリリークの可能性はないか

## 保守性
- [ ] コードは理解しやすいか
- [ ] 適切なコメントがあるか
- [ ] テストカバレッジは十分か

具体的な問題点とファイルパス、行番号を含めて報告してください。
```

**使用例:**

```bash
/review-checklist
```

エージェントやコンテキストの指定はあるが、パーミッションやフックはないため自動承認されます。

### テストケース生成スキル

```yaml
# .claude/skills/generate-tests/SKILL.md
---
name: generate-tests
description: ユニットテストを生成
argument-hint: [対象ファイル]
---

# テストケース生成

$0 のユニットテストを生成してください:

## カバレッジ
- 正常系のテストケース
- エッジケース（境界値、null、空配列など）
- エラーハンドリングのテスト

## 要件
- 既存のテストフレームワークに合わせる
- モックやスタブを適切に使用
- テストは独立して実行可能に
- 分かりやすいテスト名とコメント

テストファイルは既存の命名規則に従って配置してください。
```

**使用例:**

```bash
/generate-tests src/services/payment.js
```

### リファクタリングガイド

```yaml
# .claude/skills/refactor-guide/SKILL.md
---
name: refactor-guide
description: リファクタリングの提案を生成
argument-hint: [ファイルまたは関数名]
---

# リファクタリングガイド

$0 のリファクタリング提案を作成してください:

## 分析観点
1. 複雑度の削減（関数の分割、条件の簡略化）
2. 重複コードの排除（DRY原則）
3. 命名の改善
4. デザインパターンの適用可能性

## 提案形式
各提案について:
- 現状の問題点
- 改善後のコード例
- 期待される効果
- リスク評価

優先度順に提案してください。
```

**使用例:**

```bash
/refactor-guide src/components/UserProfile.tsx
```

### アーキテクチャ分析スキル

```yaml
# .claude/skills/analyze-architecture/SKILL.md
---
name: analyze-architecture
description: プロジェクトのアーキテクチャを分析
agent: Explore
---

# アーキテクチャ分析

プロジェクトの構造とアーキテクチャを分析してください:

## 分析項目
1. ディレクトリ構造とその意図
2. 主要なモジュール/コンポーネントの関係
3. データフロー
4. 使用されているデザインパターン
5. 技術スタックの整合性

## 評価
- アーキテクチャの長所
- 潜在的な問題点
- スケーラビリティの考察
- 改善の提案

図やツリー構造を使って視覚的に説明してください。
```

**使用例:**

```bash
/analyze-architecture
```

## 注意点

- **自動承認の条件**: スキルがパーミッション（`allowed-tools`、`disable-*` など）やフック（`on-invoke`、`on-complete` など）を定義していない場合のみ
- **セキュリティ**: 自動承認されるスキルでも、Claudeが実行する実際のツール呼び出し（ファイル編集、コマンド実行など）は通常の承認フローに従います
- **既存のスキル**: この変更は既存のスキルにも適用されるため、シンプルなスキルを使用する際の承認プロンプトが表示されなくなります
- **スキルの追加**: 新しいスキルを追加した場合、パーミッションやフックの有無に応じて自動的に判断されます
- **明示的な承認が必要な場合**: セキュリティ上重要な操作を行うスキルには、必ず適切なパーミッションやフックを定義してください
- **監査ログ**: 自動承認されたスキルの使用も、セッション履歴に記録されます

## 関連情報

- [Claude Code 公式ドキュメント - Skills](https://code.claude.com/docs/en/skills)
- [Claude Code 公式ドキュメント - Permissions](https://code.claude.com/docs/en/skills#permissions)
- [Claude Code 公式ドキュメント - Hooks](https://code.claude.com/docs/en/hooks)
- [Changelog v2.1.19](https://github.com/anthropics/claude-code/releases/tag/v2.1.19)
