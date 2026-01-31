---
title: "より細かく制御できるようになったパーミッション設定"
date: 2026-01-31
tags: [security, permissions, configuration, bash]
---

## 原文（日本語に翻訳）

パーミッション設定において、コンテンツレベルの `ask` 設定がツールレベルの `allow` 設定よりも優先されるようになりました。

## 原文（英語）

Content-level `ask` now takes precedence over tool-level `allow` in permission configuration

## 概要

Claude Code 2.1.27で、パーミッション設定の動作が改善されました。コンテンツレベルの `ask` 設定が、ツールレベルの `allow` 設定よりも優先されるようになり、より細かく安全なコマンド実行制御が可能になりました。

## 基本的な使い方

以前は `allow: ["Bash"]` がすべてのbashコマンドを許可してしまい、`ask` の設定が無視されていました。新しいバージョンでは、`ask` の設定が優先されます。

```json
{
  "allow": ["Bash"],
  "ask": [
    "Bash(rm *)",
    "Bash(rm -rf *)",
    "Bash(sudo *)"
  ]
}
```

この設定により：
- 通常のbashコマンドは自動的に実行される
- `rm *`、`rm -rf *`、`sudo` で始まるコマンドは実行前に確認が求められる

## 実践例

### 危険なコマンドのみ確認

開発作業では多くのbashコマンドを実行しますが、破壊的なコマンドのみ確認を求めることで、安全性と効率性を両立できます。

```json
{
  "allow": ["Bash", "Write", "Edit"],
  "ask": [
    "Bash(rm *)",
    "Bash(git push --force)",
    "Bash(npm publish)",
    "Bash(docker system prune)"
  ]
}
```

### プロダクション環境での操作制限

本番環境に影響を与える可能性のあるコマンドを厳重に管理できます。

```json
{
  "allow": ["Bash"],
  "ask": [
    "Bash(*production*)",
    "Bash(*deploy*)",
    "Bash(kubectl delete *)",
    "Bash(terraform destroy)"
  ]
}
```

### パターンマッチングを活用した包括的な設定

```json
{
  "allow": ["Bash", "Write", "Edit", "Read"],
  "ask": [
    "Bash(rm *)",
    "Bash(* --force *)",
    "Bash(sudo *)",
    "Bash(*production*)",
    "Bash(git push * main)",
    "Bash(git push * master)",
    "Write(*.env)",
    "Write(*secret*)"
  ]
}
```

この設定では、ファイル削除、`--force` オプション付きコマンド、sudo権限が必要なコマンド、本番環境関連、機密ファイルの書き込みなどが確認対象になります。

### deny 設定との併用

```json
{
  "allow": ["Bash"],
  "ask": ["Bash(rm *)"],
  "deny": ["Bash(rm -rf /)"]
}
```

- 通常のbashコマンドは許可
- `rm *` は確認を求める
- `rm -rf /` は完全に禁止

## 注意点

- **設定の優先順位**: コンテンツレベルの `ask` 設定（最優先）→ ツールレベルの `allow` 設定 → デフォルトの動作
- **パターンマッチング**: `*` はワイルドカードとして機能し、部分一致で動作します（`Bash(rm *)` は `rm -rf file.txt` にもマッチ）
- **プロジェクト設定の優先**: プロジェクトの `.claude/permissions.json` はグローバルの `~/.claude/permissions.json` より優先されます
- **設定ファイルの場所**:
  - グローバル: `~/.claude/permissions.json`
  - プロジェクト: `/path/to/project/.claude/permissions.json`

## 関連情報

- [Claude Code公式ドキュメント](https://docs.claude.ai/claude-code)
- [権限管理の強化：ワイルドカード許可とCLAUDE.md](./2026-01-27-permissions-and-claude-md)
