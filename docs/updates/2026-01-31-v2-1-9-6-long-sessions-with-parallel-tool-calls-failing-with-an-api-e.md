---
title: "長時間セッションでの並列ツール呼び出しエラーを修正"
date: 2026-01-16
tags: ['バグ修正', '安定性向上', 'API']
---

## 原文（日本語訳）

orphan tool_result blocks に関するAPIエラーで長時間セッションの並列ツール呼び出しが失敗する問題を修正しました。

## 原文（英語）

Fixed long sessions with parallel tool calls failing with an API error about orphan tool_result blocks

## 概要

長時間のセッションで並列ツール呼び出しを使用した際に、"orphan tool_result blocks"（孤立したツール結果ブロック）に関するAPIエラーが発生してセッションが失敗する問題が修正されました。この問題は、複数のツールを同時に呼び出す最適化機能（並列ツール呼び出し）を使用している場合に、会話が長くなるにつれて発生しやすくなっていました。v2.1.9では、ツール呼び出しとその結果の関連付けが正しく管理されるようになり、長時間のセッションでも安定して動作します。

## 問題の詳細

### 発生していた症状

- 長時間のセッション（多数のツール呼び出しを含む）で突然エラーが発生
- エラーメッセージ: "orphan tool_result blocks" または類似のAPI検証エラー
- 並列ツール呼び出し（複数のツールを同時実行）使用時に頻発
- セッションが途中で停止し、作業が中断される

### 発生原因

Claude Codeは効率化のため、独立した複数のツール呼び出しを並列実行します。例えば、複数のファイルを同時に読み込んだり、複数のディレクトリを並列検索したりします。長時間セッションでは、この並列呼び出しの結果とツール呼び出しリクエストの対応関係が、APIリクエスト構築時に正しく維持されない場合があり、APIがこれを検証エラーとして拒否していました。

## 修正内容

v2.1.9では、以下の改善が行われました：

- ツール呼び出しと結果ブロックの対応関係を正確に追跡
- 長時間セッションでの会話履歴管理の改善
- 並列ツール呼び出し時のAPIリクエスト構築ロジックの修正
- ツール結果の孤立を防ぐバリデーションの強化

## 影響を受けていたユースケース

### 大規模コードベースの探索

複数のディレクトリやファイルを並列で検索・読み込みする際に問題が発生していました。

```
# 以前は長時間セッションで失敗する可能性があった
> Find all API endpoints in this codebase
> Read the configuration files for each service
> Check the test coverage for these components
```

### 並列データ収集

複数の情報源から同時にデータを取得する操作で問題が起きていました。

```
# 複数のMCPサーバーから並列でデータ取得
> Check GitHub issues, Sentry errors, and database logs
```

### 長時間のリファクタリング作業

多数のファイル変更を伴う長時間のリファクタリングセッションで問題が発生していました。

```
# 多数のファイルを並列で読み込み・編集
> Refactor the authentication system across all services
> Update all API clients to use the new auth flow
```

## 注意点

- この修正により、長時間セッションの安定性が大幅に向上しました
- 並列ツール呼び出しは引き続き自動的に使用されます（ユーザー側の設定変更は不要）
- 既存のセッションでエラーが発生していた場合、v2.1.9にアップデート後は新規セッションで改善されます
- この問題は主にAPI側の検証エラーによるもので、実際のツール実行には影響していませんでした

## 関連情報

- [Claude Code並列処理の仕組み](https://code.claude.com/docs/en/how-claude-code-works)
- [トラブルシューティング](https://code.claude.com/docs/en/troubleshooting)
- [Changelog v2.1.9](https://github.com/anthropics/claude-code/releases/tag/v2.1.9)
