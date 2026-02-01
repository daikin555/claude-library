---
title: "複雑なBashコマンドのパーミッションプロンプトを削減"
date: 2026-01-31
tags: ['改善', 'bash', 'パーミッション', 'UX']
---

## 原文（日本語に翻訳）

複雑なBashコマンドのパーミッションプロンプトを削減しました

## 原文（英語）

Reduced permission prompts for complex bash commands

## 概要

Claude Code v2.1.0で実装された、パーミッションプロンプト削減の改善です。パイプライン、リダイレクト、コマンド置換などを含む複雑なBashコマンドに対して、不必要な複数回のパーミッション確認を求めることなく、より効率的に処理できるようになりました。これにより、ワークフローの中断が減り、v2.1.0で導入されたワイルドカードパターンマッチングと組み合わせることで、さらにスムーズな開発体験を実現します。

## 基本的な使い方

ワイルドカードパターンとの組み合わせで、複雑なコマンドの承認を簡素化します。

```json
{
  "permissions": {
    "Bash": {
      "allow": [
        "git *",
        "npm *",
        "docker *"
      ]
    }
  }
}
```

この設定により、以下のような複雑なコマンドも1回の承認で実行可能になります：

```bash
# パイプラインを含むコマンド
git log --oneline | grep "feature"

# リダイレクトを含むコマンド
npm run build > build.log 2>&1

# コマンド置換を含むコマンド
docker run -it $(docker build -q .)
```

## 実践例

### CI/CDパイプラインでの効率化

```bash
# 複雑なビルドコマンド
npm run test && npm run build && docker build -t app:latest .

# 以前: 各コマンド（npm run test、npm run build、docker build）
#       で個別に承認が必要だった
# 現在: "npm *"と"docker *"のパターンで1回の承認のみ
```

### ログ処理の簡素化

```bash
# ログのフィルタリングと集計
grep ERROR application.log | sort | uniq -c | sort -rn

# 複雑なパイプラインでも、適切なパターンがあれば
# 過度な承認プロンプトが表示されない
```

### Dockerコンテナ操作

```bash
# 複数のDocker操作を連鎖
docker ps -a | grep "exited" | awk '{print $1}' | xargs docker rm

# "docker *"パターンで承認されていれば、
# パイプライン全体でスムーズに実行
```

### Git操作の効率化

```bash
# ブランチの一括削除
git branch | grep "feature/" | xargs git branch -D

# "git *"パターンで承認済みなら、
# 複雑な操作でも中断されない
```

## 注意点

- この改善は Claude Code v2.1.0（2026年1月7日リリース）で実装されました
- ワイルドカードパターンマッチング（同じくv2.1.0で追加）と組み合わせると最も効果的です
- パーミッション設定の推奨事項：
  - よく使うツール（git、npm、docker など）にワイルドカードパターンを設定
  - 危険なコマンド（rm -rf、force push など）は明示的に拒否
  - Hooksを使用してより高度な制御を実装
- パイプライン、リダイレクト、コマンド置換の扱い：
  - 各コンポーネントコマンドが個別に評価されます
  - すべてのコンポーネントが許可パターンにマッチする必要があります
- セキュリティのバランス：
  - 過度な承認プロンプトを減らしつつ、セキュリティを維持
  - 重要な操作には依然として確認が必要
  - PreToolUse hooksで自動修正と確認を組み合わせることを推奨

## 関連情報

- [Identity and Access Management - Claude Code Docs](https://code.claude.com/docs/en/iam)
- [How To Modify Approvals in Claude Code](https://www.curiouslychase.com/tools/how-to-modify-approvals-in-claude-code)
- [A complete guide to Claude Code permissions](https://www.eesel.ai/blog/claude-code-permissions)
