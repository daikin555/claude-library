---
title: "マーケットプレイスソース削除時に設定が完全に削除されない問題を修正"
date: 2026-01-27
tags: ['バグ修正', 'マーケットプレイス', '設定管理']
---

## 原文（日本語に翻訳）

マーケットプレイスソースの削除時に設定が適切に削除されない問題を修正

## 原文（英語）

Fixed marketplace source removal not properly deleting settings

## 概要

Claude Code v2.1.20では、マーケットプレイスからスキルやMCPサーバーのソースを削除した際に、関連する設定ファイルが完全に削除されない問題が修正されました。以前は、ソースを削除してもバックエンドの設定が残り続け、ディスク容量の無駄遣いや設定の不整合を引き起こしていました。この修正により、クリーンな削除が保証されます。

## 基本的な使い方

マーケットプレイスソースを削除すると、関連する設定も自動的に削除されます：

```bash
# マーケットプレイスソースを追加
claude
> /marketplace add https://github.com/example/custom-skills

# スキルが利用可能になる
> /skills
# custom-skills からのスキルが表示される

# ソースを削除
> /marketplace remove https://github.com/example/custom-skills

# 修正前：
# - ソースは削除されるが、設定ファイルが残る
# - ~/.config/claude-code/ に古い設定が蓄積

# 修正後：
# - ソースと関連設定の両方が完全に削除される
# - クリーンな状態に復元
```

## 実践例

### 不要なスキルパッケージの削除

試験的に追加したスキルを削除する場合：

```bash
# 複数のスキルソースを試す
> /marketplace add https://github.com/user1/ml-tools
> /marketplace add https://github.com/user2/dev-helpers
> /marketplace add https://github.com/user3/productivity-boost

# 使わないものを削除
> /marketplace remove https://github.com/user2/dev-helpers

# 修正により：
# - dev-helpers の設定ファイルが完全削除
# - settings.json から関連エントリが削除
# - ディスク容量が解放される
```

### MCPサーバーソースのクリーンアップ

古いMCPサーバー設定を整理：

```bash
# 開発中に複数のMCPサーバーソースを追加
> /marketplace add https://github.com/company/internal-mcp-tools

# プロジェクト完了後、削除
> /marketplace remove https://github.com/company/internal-mcp-tools

# 修正前の問題：
# - MCP設定ファイルが残る
# - 次回起動時に存在しないサーバーへの接続を試行
# - エラーログが発生

# 修正後：
# - すべての関連設定が削除
# - クリーンな起動
# - エラーなし
```

### マーケットプレイス設定のリセット

設定を一から作り直したい場合：

```bash
# すべてのカスタムソースを削除
> /marketplace list
Custom sources:
  - https://github.com/example/tools-a
  - https://github.com/example/tools-b
  - https://github.com/example/tools-c

# 1つずつ削除
> /marketplace remove https://github.com/example/tools-a
> /marketplace remove https://github.com/example/tools-b
> /marketplace remove https://github.com/example/tools-c

# 修正により：
# - 各削除でクリーンな状態になる
# - 設定ファイルの孤立データなし
# - フレッシュスタートが可能
```

### トラブルシューティング時のクリーンインストール

問題のあるソースを完全に削除して再インストール：

```bash
# 問題のあるソース
> /marketplace remove https://github.com/example/broken-skills

# 修正前：
# - 古い設定が残る
# - 再追加時に設定が競合
# - 問題が解決しない

# 修正後：
# - 完全に削除される
# - 再追加がクリーン
> /marketplace add https://github.com/example/broken-skills
# 新しい設定でインストール成功
```

### ディスク容量の管理

長期間使用後の設定整理：

```bash
# 設定ディレクトリのサイズを確認（修正前）
$ du -sh ~/.config/claude-code/
2.5G  # 多くの孤立設定ファイル

# 不要なソースをすべて削除
> /marketplace list
> /marketplace remove [不要なソース]

# 修正後のサイズ
$ du -sh ~/.config/claude-code/
800M  # 実際に使用している設定のみ

# 1.7GB のディスク容量を解放
```

### チーム環境での設定同期

チームメンバー間で設定を統一する際：

```bash
# メンバーAが推奨ソースリストを共有
# メンバーBが古いソースを削除

> /marketplace remove https://github.com/old/deprecated-tools

# 修正により：
# - 完全に削除されるため、設定の不整合がない
# - 新しい推奨ソースの追加が問題なく行える
# - チーム全体で統一された環境を維持
```

## 注意点

- この修正は、ソース削除時の設定ファイルクリーンアップに影響します
- 削除されるのは、マーケットプレイスソース固有の設定のみです
- ユーザーが手動で作成したカスタム設定は影響を受けません
- 削除前に重要な設定がある場合は、バックアップを推奨します
- この問題は、複数のソースを頻繁に追加・削除する開発者に特に影響していました

## 関連情報

- [Marketplace](https://code.claude.com/docs/en/marketplace/overview)
- [Managing Skills](https://code.claude.com/docs/en/skills/managing-skills)
- [Configuration Files](https://code.claude.com/docs/en/reference/configuration)
- [MCP Servers](https://code.claude.com/docs/en/mcp/servers)
- [Changelog v2.1.20](https://github.com/anthropics/claude-code/releases/tag/v2.1.20)
