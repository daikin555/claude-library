---
title: "より細かく制御できるようになったパーミッション設定"
date: 2026-01-30
tags: [security, permissions, configuration, bash]
---

## 概要

Claude Code 2.1.27で、パーミッション設定の動作が改善されました。コンテンツレベルの `ask` 設定が、ツールレベルの `allow` 設定よりも優先されるようになり、より細かく安全なコマンド実行制御が可能になりました。

## 変更内容

### 以前の動作

```json
{
  "allow": ["Bash"],
  "ask": ["Bash(rm *)"]
}
```

上記の設定では、`allow: ["Bash"]` がすべてのbashコマンドを許可してしまい、`ask` の設定が無視されていました。つまり、危険な `rm` コマンドも確認なしで実行される可能性がありました。

### 新しい動作（2.1.27以降）

同じ設定で、`ask` の設定が優先されるようになりました。`rm *` のような危険なコマンドを実行する際には、必ず確認プロンプトが表示されます。

## 使い方

### 基本的な設定例

`~/.claude/permissions.json` または `.claude/permissions.json` に以下のように記述します。

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

## 活用シーン

### 1. 危険なコマンドのみ確認

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

### 2. プロダクション環境での操作制限

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

### 3. チーム開発での安全策

チームで共有する設定ファイルに、誤操作を防ぐためのルールを設定できます。

```json
{
  "allow": ["Bash"],
  "ask": [
    "Bash(git push origin main)",
    "Bash(git push origin master)",
    "Bash(npm version *)",
    "Bash(git tag *)"
  ]
}
```

## コード例

### パターンマッチングを活用した設定

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

この設定では：
- ファイル削除コマンド
- `--force` オプション付きのコマンド
- sudo権限が必要なコマンド
- productionに関連するコマンド
- mainやmasterブランチへのpush
- 環境変数ファイルやシークレットファイルの書き込み

などが確認対象になります。

### プロジェクト固有の設定

プロジェクトのルートに `.claude/permissions.json` を配置することで、プロジェクト固有のルールを設定できます。

```json
{
  "allow": ["Bash"],
  "ask": [
    "Bash(npm run build:prod)",
    "Bash(npm run deploy)",
    "Bash(docker-compose -f production.yml *)",
    "Bash(aws * --profile production)"
  ]
}
```

## 注意点・Tips

### パターンマッチングの仕様

- `*` はワイルドカードとして機能します
- パターンは大文字小文字を区別します
- 部分一致で動作します（`Bash(rm *)` は `rm -rf file.txt` にもマッチ）

### 設定の優先順位

1. コンテンツレベルの `ask` 設定（最優先）
2. ツールレベルの `allow` 設定
3. デフォルトの動作（確認を求める）

### グローバル設定とプロジェクト設定

```bash
# グローバル設定
~/.claude/permissions.json

# プロジェクト設定（優先される）
/path/to/project/.claude/permissions.json
```

プロジェクト設定がグローバル設定を上書きします。

### 設定の確認

設定が正しく動作しているか確認するには、実際にコマンドを実行してみます。

```bash
claude

# セッション内で
# > ファイルを削除してください
# 確認プロンプトが表示されるはず
```

### deny 設定との併用

より厳密な制御が必要な場合は、`deny` 設定と組み合わせます。

```json
{
  "allow": ["Bash"],
  "ask": ["Bash(rm *)"],
  "deny": ["Bash(rm -rf /)"]
}
```

この例では：
- 通常のbashコマンドは許可
- `rm *` は確認を求める
- `rm -rf /` は完全に禁止

### よくある設定例

```json
{
  "allow": ["Bash", "Write", "Edit", "Read", "Grep", "Glob"],
  "ask": [
    "Bash(rm *)",
    "Bash(git push * --force)",
    "Bash(npm publish)",
    "Bash(yarn publish)",
    "Bash(docker system prune)",
    "Bash(sudo *)",
    "Write(*.env)",
    "Write(*credentials*)"
  ],
  "deny": [
    "Bash(rm -rf /)",
    "Bash(:(){ :|:& };:)"
  ]
}
```

## まとめ

パーミッション設定の改善により、開発の効率性を損なうことなく、より安全なClaude Codeの使用が可能になりました。コンテンツレベルの `ask` 設定を活用して、危険なコマンドのみ確認を求めることで、誤操作を防ぎながらスムーズな開発フローを実現できます。
