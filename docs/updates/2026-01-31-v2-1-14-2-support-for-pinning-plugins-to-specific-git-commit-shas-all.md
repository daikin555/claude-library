---
title: "プラグインを特定のGitコミットSHAに固定する機能を追加"
date: 2026-01-20
tags: ['新機能', 'プラグイン', 'バージョン管理']
---

## 原文（日本語に翻訳）

特定のGitコミットSHAにプラグインを固定する機能を追加。マーケットプレイスのエントリから正確なバージョンをインストールできるようになりました

## 原文（英語）

Added support for pinning plugins to specific git commit SHAs, allowing marketplace entries to install exact versions

## 概要

Claude Code v2.1.14では、プラグインを特定のGitコミットSHA（ハッシュ値）に固定する機能が追加されました。これにより、プラグインマーケットプレイスからインストールする際に、特定のバージョンを正確に指定できるようになります。本番環境での安定性確保や、チーム全体で同じバージョンのプラグインを使用する際に非常に有用です。

## 基本的な使い方

プラグインを特定のコミットSHAに固定するには、プラグインの設定でGitコミットハッシュを指定します。

### プラグイン設定での指定方法

```json
{
  "mcpServers": {
    "my-plugin": {
      "command": "npx",
      "args": ["-y", "my-plugin@git+https://github.com/user/plugin#abc123def456"]
    }
  }
}
```

SHA指定の形式：`git+https://github.com/user/repo#<commit-sha>`

## 実践例

### 安定版プラグインの固定

本番環境で動作確認済みの特定バージョンを固定：

```json
{
  "mcpServers": {
    "database-plugin": {
      "command": "npx",
      "args": [
        "-y",
        "db-connector@git+https://github.com/org/db-connector#a1b2c3d4e5f6"
      ]
    }
  }
}
```

このように設定すると、プラグインは常にコミット`a1b2c3d4e5f6`のバージョンで動作します。

### チーム全体で同じバージョンを使用

プロジェクトの`.claude/mcp.json`で固定することで、チームメンバー全員が同じバージョンを使用：

```json
{
  "mcpServers": {
    "team-tools": {
      "command": "npx",
      "args": [
        "-y",
        "company-tools@git+https://github.com/company/tools#7890abcdef12"
      ]
    }
  }
}
```

### 破壊的変更を避ける

プラグインの新バージョンに破壊的変更が含まれる場合、動作確認済みバージョンに固定：

```json
{
  "mcpServers": {
    "api-client": {
      "command": "npx",
      "args": [
        "-y",
        "api-client@git+https://github.com/vendor/api-client#stable-2024"
      ]
    }
  }
}
```

### テスト済みバージョンの配布

マーケットプレイスのエントリで推奨バージョンを指定：

```json
{
  "name": "Recommended Plugin Version",
  "description": "Tested and verified version",
  "mcpServer": {
    "command": "npx",
    "args": [
      "-y",
      "awesome-plugin@git+https://github.com/dev/awesome#verified-stable"
    ]
  }
}
```

## 注意点

- **コミットSHAの確認**：GitHubリポジトリのコミット履歴からSHAをコピーする必要があります
- **フルSHAを推奨**：短縮SHAではなく、完全な40文字のSHAを使用することを推奨します
- **自動更新されない**：SHA固定を使用すると、プラグインは自動的に更新されません。セキュリティパッチなどを適用するには手動で更新が必要です
- **Git URL形式**：`git+https://`プレフィックスと`#<sha>`サフィックスの形式に注意してください
- **プライベートリポジトリ**：プライベートリポジトリの場合、適切な認証設定が必要です
- **マーケットプレイスとの互換性**：マーケットプレイスエントリでSHA固定を使用する場合、ユーザーはそのバージョンが確実にインストールされます

## 関連情報

- [Claude Code プラグイン](https://code.claude.com/docs/en/plugins)
- [Claude Code MCP設定](https://code.claude.com/docs/en/mcp)
- [Claude Code 設定ガイド](https://code.claude.com/docs/en/settings)
- [Git コミットSHAについて（GitHub Docs）](https://docs.github.com/en/pull-requests/committing-changes-to-your-project/creating-and-editing-commits/about-commits)
- [Changelog v2.1.14](https://github.com/anthropics/claude-code/releases/tag/v2.1.14)
