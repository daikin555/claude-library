---
title: "権限設定でコンテンツレベルのaskがツールレベルのallowより優先されるように改善"
date: 2026-01-30
tags: ['権限', 'セキュリティ', '改善', 'Bash']
---

## 原文（日本語に翻訳）

権限設定がコンテンツレベルの`ask`をツールレベルの`allow`より優先するようになりました。以前は`allow: ["Bash"], ask: ["Bash(rm *)"]`の設定ですべてのbashコマンドが許可されていましたが、現在は`rm`コマンドで確認プロンプトが表示されます。

## 原文（英語）

Permissions now respect content-level `ask` over tool-level `allow`. Previously `allow: ["Bash"], ask: ["Bash(rm *)"]` allowed all bash commands, but will now permission prompt for `rm`.

## 概要

権限システムの優先順位が改善され、より細かい制御が可能になりました。ツール全体を許可(`allow`)しつつ、特定の危険なコマンドやパターンだけを確認対象(`ask`)にすることで、安全性とワークフローの効率を両立できます。

## 基本的な使い方

settings.jsonで権限を設定します。

```json
{
  "allow": ["Bash"],
  "ask": ["Bash(rm *)"]
}
```

この設定により：
- 通常のBashコマンドは自動的に実行される
- `rm`で始まるコマンドは実行前に確認プロンプトが表示される

## 実践例

### ファイル削除コマンドを慎重に扱う

本番環境で作業する際、削除系コマンドのみ確認したい場合：

```json
{
  "allow": ["Bash"],
  "ask": [
    "Bash(rm *)",
    "Bash(rmdir *)",
    "Bash(rm -rf *)"
  ]
}
```

これにより、通常の開発作業はスムーズに進みながら、ファイル削除時のみ確認できます。

### Git操作の特定コマンドのみ確認

Git操作は許可するが、force pushやブランチ削除は確認したい場合：

```json
{
  "allow": ["Bash(git *)"],
  "ask": [
    "Bash(git push *--force*)",
    "Bash(git push *-f*)",
    "Bash(git branch -D *)",
    "Bash(git reset --hard *)"
  ]
}
```

### データベース操作の保護

データベースコマンドは許可するが、破壊的操作のみ確認：

```json
{
  "allow": ["Bash(psql *)", "Bash(mysql *)"],
  "ask": [
    "Bash(*DROP TABLE*)",
    "Bash(*DELETE FROM*)",
    "Bash(*TRUNCATE*)"
  ]
}
```

### システム設定変更の制御

一般的なコマンドは許可しつつ、システム変更は確認：

```json
{
  "allow": ["Bash"],
  "ask": [
    "Bash(sudo *)",
    "Bash(chmod *)",
    "Bash(chown *)"
  ]
}
```

## v2.1.27以前の動作との違い

**v2.1.26以前：**
```json
{
  "allow": ["Bash"],
  "ask": ["Bash(rm *)"]
}
```
→ すべてのbashコマンドが確認なしで実行される（`ask`が無視される）

**v2.1.27以降：**
```json
{
  "allow": ["Bash"],
  "ask": ["Bash(rm *)"]
}
```
→ `rm`コマンドのみ確認プロンプトが表示される（期待通りの動作）

## 注意点

- この変更により、既存の権限設定の動作が変わる可能性があります
- 設定を見直して、意図した動作になっているか確認してください
- 権限ルールは`deny` → `ask` → `allow`の順序で評価されます
- より具体的なパターンを優先したい場合は、`ask`ルールを`allow`ルールより後に記述します
- ワイルドカードパターンはgitignore仕様に従います

## 権限システムの基本

Claude Codeの権限システムには3つのレベルがあります：

1. **deny**: 実行を完全にブロック（最優先）
2. **ask**: 実行前にユーザーに確認
3. **allow**: 自動的に実行を許可

ルールの評価順序：
```
deny（拒否）→ ask（確認）→ allow（許可）
```

最初にマッチしたルールが適用されます。

## 関連情報

- [Configure permissions - Claude Code Docs](https://code.claude.com/docs/en/sdk/sdk-permissions)
- [Claude Code settings - Claude Code Docs](https://code.claude.com/docs/en/settings)
- [Identity and Access Management - Claude Code Docs](https://code.claude.com/docs/en/iam)
- [Changelog v2.1.27](https://github.com/anthropics/claude-code/releases/tag/v2.1.27)
