---
title: "並列ツール実行時の孤立tool_resultエラーを修正"
date: 2026-01-14
tags: ['バグ修正', 'ツール実行', 'エラーハンドリング']
---

## 原文（日本語に翻訳）

ストリーミング実行中に兄弟ツールが失敗した際に発生する孤立したtool_resultエラーを修正しました。

## 原文（英語）

Fixed orphaned tool_result errors when sibling tools fail during streaming execution

## 概要

Claude Codeが複数のツールを並列実行する際、一部のツールが失敗すると、他のツールの結果が「孤立」してエラーが発生する問題が修正されました。この問題により、正常に実行されたツールの結果が適切に処理されず、不可解なエラーメッセージが表示されていました。

## 問題の詳細

### 修正前の動作

Claude Codeは効率化のため、複数のツールを並列実行します。例えば：

```
# 並列実行例
- Read file A
- Read file B
- Grep pattern in directory
```

この際、1つのツール（例：存在しないファイルの読み込み）が失敗すると、他の正常に完了したツールの結果（tool_result）が適切に処理されず、以下のようなエラーが発生していました：

```
Error: orphaned tool_result detected
Tool execution failed: unexpected tool_result without matching tool_use
```

### 修正後の動作

v2.1.7以降、並列実行中にツールが失敗しても：

- 成功したツールの結果は正常に処理される
- 失敗したツールのエラーは適切に報告される
- 「孤立したtool_result」エラーは発生しない

## 実践例

### 複数ファイルの並列読み込み

存在しないファイルを含む複数ファイルの読み込みを試みる場合。

**修正前:**
```
# 3つのファイルを並列読み込み
Read: config.json ✓
Read: data.json ✓
Read: missing.json ✗ (File not found)

❌ Error: orphaned tool_result detected
# 全体が失敗し、config.jsonとdata.jsonの内容も取得できない
```

**修正後（v2.1.7）:**
```
# 3つのファイルを並列読み込み
Read: config.json ✓
Read: data.json ✓
Read: missing.json ✗ (File not found)

✓ config.jsonとdata.jsonの内容は正常に取得
❌ missing.jsonのエラーのみが報告される
```

### 並列検索操作

複数のGrepツールを並列実行する場合。

**修正前:**
```
Grep "function" in src/ ✓
Grep "class" in lib/ ✓
Grep "invalid[" in test/ ✗ (Invalid regex)

❌ Error: orphaned tool_result
# 他の検索結果も失われる
```

**修正後（v2.1.7）:**
```
Grep "function" in src/ ✓
Grep "class" in lib/ ✓
Grep "invalid[" in test/ ✗ (Invalid regex)

✓ src/とlib/の検索結果は取得できる
❌ test/の無効な正規表現エラーのみが報告される
```

### 混合ツール並列実行

異なる種類のツールを並列実行する場合。

```
# 以下を並列実行
Read package.json ✓
Bash git status ✓
Glob "**/*.ts" ✗ (Permission denied)

# v2.1.7以降は、成功した2つの結果を取得し、
# Globのパーミッションエラーのみが報告される
```

## 技術的な改善点

- **エラー分離**: 各ツールのエラーが他のツールに影響しない
- **部分的成功**: 一部のツールが失敗しても、成功したツールの結果は利用可能
- **明確なエラー報告**: どのツールが失敗したか明確に報告される
- **ストリーミング対応**: ストリーミング実行中でも正しく処理される

## 注意点

- **失敗したツールの結果は得られない**: 当然ながら、失敗したツールの結果は取得できません
- **エラーハンドリング**: 並列実行時は、一部のツールが失敗する可能性を考慮したコードを書くことを推奨します
- **デバッグ**: 複数のツールが失敗した場合、それぞれ個別にエラーメッセージが表示されます

## 影響を受けるシナリオ

この修正により、以下のシナリオが改善されました：

- **大規模コードベースの探索**: 多数のファイルを並列読み込みする際、一部のファイルが存在しなくても他のファイルは読み込まれる
- **複数ディレクトリの検索**: 一部のディレクトリにアクセス権がなくても、他のディレクトリの検索結果は取得できる
- **混合操作**: 読み込み、検索、コマンド実行などを並列実行する際の安定性が向上

## 関連情報

- [Claude Code ツールシステム](https://code.claude.com/docs/)
- [並列実行とパフォーマンス](https://code.claude.com/docs/)
- [Changelog v2.1.7](https://github.com/anthropics/claude-code/releases/tag/v2.1.7)
