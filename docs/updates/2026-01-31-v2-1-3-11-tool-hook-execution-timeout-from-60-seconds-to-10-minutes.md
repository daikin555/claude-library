---
title: "ツールフックの実行タイムアウトを10分に延長"
date: 2026-01-09
tags: ['変更', 'hooks', 'タイムアウト', '設定']
---

## 原文（日本語に翻訳）

ツールフックの実行タイムアウトを60秒から10分に変更しました

## 原文（英語）

Changed tool hook execution timeout from 60 seconds to 10 minutes

## 概要

Claude Code v2.1.3では、ツールフック（tool hooks）の実行タイムアウトが60秒から10分（600秒）に延長されました。これにより、テストスイートの実行やビルドプロセスなど、時間のかかる処理をフックで実行できるようになり、より柔軟なワークフローの構築が可能になります。

## 基本的な使い方

ツールフックは、特定のツール呼び出しの前後に自動実行されるスクリプトです。

```bash
# フックの設定例（.claude/hooks/ディレクトリ）
# pre-bash.sh, post-bash.sh など

# v2.1.3では、10分以内に完了する処理を実行できる
```

## 実践例

### 修正前の制限

以前は60秒でタイムアウトしてしまい、長時間処理を実行できませんでした。

```bash
# 修正前の動作例
# pre-bash.sh フックでテストを実行
#!/bin/bash
npm test  # テストスイートの実行に2分かかる

# 問題：
# ⏱️ タイムアウト！（60秒で強制終了）
# テストが完了せずにフックが失敗
# 本来のBashコマンドが実行されない
```

### 修正後の動作

v2.1.3では、最大10分の処理が可能になりました。

```bash
# 修正後の動作例
# pre-bash.sh フックでテストを実行
#!/bin/bash
npm test  # テストスイートの実行に2分かかる

# 改善：
# ✅ タイムアウトせずに完了（10分以内）
# テストが正常に完了
# 本来のBashコマンドも実行される
```

### ビルドプロセスの統合

ビルドやコンパイルをフックで実行できるようになりました。

```bash
# pre-commit フックの例
#!/bin/bash

# TypeScriptのコンパイル（1分）
npm run build

# Lintの実行（30秒）
npm run lint

# テストの実行（2分）
npm run test

# 合計約3.5分 → v2.1.3では問題なく実行可能
```

### 複雑なCI/CDチェックの実行

複数のチェックを組み合わせた検証も可能です。

```bash
# pre-bash.sh フックの例
#!/bin/bash

echo "Running pre-checks..."

# 型チェック
npm run type-check

# セキュリティ監査
npm audit

# E2Eテストの実行（時間がかかる）
npm run test:e2e

# パフォーマンステスト
npm run test:performance

# 合計5-8分程度 → v2.1.3では実行可能
```

### データベースマイグレーション

開発環境のセットアップやマイグレーションもフックで自動化できます。

```bash
# post-tool フックの例
#!/bin/bash

# データベースマイグレーション（数分かかる場合がある）
npm run db:migrate

# シードデータの投入
npm run db:seed

# キャッシュの生成
npm run cache:warm

# v2.1.3では、これらの処理をまとめて実行可能
```

### タイムアウト設定の例外処理

長時間処理でも、適切なフィードバックを提供できます。

```bash
# pre-bash.sh フックの例
#!/bin/bash

echo "Starting long-running checks..."

# プログレス表示付きで実行
npm test -- --verbose

# 10分以内に完了すれば成功
# 10分を超える場合は、処理を分割することを検討
```

## 注意点

- フックの実行時間は最大10分までです。それを超える処理は別の方法で実行してください
- フックが長時間実行されると、ユーザー体験が低下する可能性があります
- 可能な限り、フックの実行時間は短くすることを推奨します（数分以内）
- 非常に時間のかかる処理（ビルド、テストなど）は、バックグラウンドタスクや別のワークフローで実行することを検討してください
- フックがタイムアウトすると、設定によっては元のコマンドがブロックされる場合があります

## 関連情報

- [Claude Code 公式ドキュメント](https://claude.ai/code)
- [Changelog v2.1.3](https://github.com/anthropics/claude-code/releases/tag/v2.1.3)
- [Hooksの設定ガイド](https://github.com/anthropics/claude-code)
- [ツールフックのベストプラクティス](https://github.com/anthropics/claude-code)
- [タイムアウト設定とパフォーマンス](https://github.com/anthropics/claude-code)
