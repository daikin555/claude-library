---
title: "設定バックアップにタイムスタンプを追加し、最新5件をローテーション保持"
date: 2026-01-27
tags: ['設定変更', 'データ保護', 'バックアップ']
---

## 原文（日本語に翻訳）

データ損失を防ぐため、設定バックアップにタイムスタンプを付与し、最新5件をローテーション保持するよう変更

## 原文（英語）

Changed config backups to be timestamped and rotated (keeping 5 most recent) to prevent data loss

## 概要

Claude Code v2.1.20では、設定ファイルのバックアップメカニズムが大幅に改善されました。以前は、設定変更時に単一のバックアップファイルのみが保存され、複数の変更履歴を追跡できませんでした。この変更により、設定バックアップにタイムスタンプが付与され、最新5件が自動的にローテーション保持されるようになります。これにより、誤った設定変更からの復旧が容易になり、データ損失のリスクが大幅に軽減されます。

## 基本的な使い方

設定変更時、自動的にバックアップが作成されます：

```bash
# 設定を変更
> /config model claude-opus-4.5

# 変更前の動作：
# ~/.config/claude-code/settings.json.bak（単一ファイル）

# 変更後の動作：
# バックアップディレクトリに複数保存：
~/.config/claude-code/backups/
  ├── settings.json.2026-01-31-14-30-45.bak
  ├── settings.json.2026-01-31-12-15-20.bak
  ├── settings.json.2026-01-30-18-42-10.bak
  ├── settings.json.2026-01-30-09-25-33.bak
  └── settings.json.2026-01-29-16-08-05.bak  # 最も古い

# 最新5件が保持される
```

## 実践例

### 誤った設定変更からの復旧

設定を間違えて変更してしまった場合：

```bash
# 誤って重要な設定を削除
> /config permissions.allow = []

# Claudeが動作しなくなった...

# バックアップから復元
$ ls ~/.config/claude-code/backups/
settings.json.2026-01-31-14-30-45.bak  # ← 変更直前
settings.json.2026-01-31-12-15-20.bak
settings.json.2026-01-30-18-42-10.bak
...

# 最新のバックアップを確認
$ cat ~/.config/claude-code/backups/settings.json.2026-01-31-14-30-45.bak
{
  "permissions": {
    "allow": ["Bash", "Read", "Write", ...]
  }
}

# 復元
$ cp ~/.config/claude-code/backups/settings.json.2026-01-31-14-30-45.bak \
     ~/.config/claude-code/settings.json

# 変更により：
# - 複数世代のバックアップから選択可能
# - タイムスタンプで識別しやすい
# - 確実に復旧できる
```

### 設定変更履歴の追跡

どの設定をいつ変更したか追跡：

```bash
# バックアップの一覧表示
$ ls -lt ~/.config/claude-code/backups/

-rw-r--r-- settings.json.2026-01-31-14-30-45.bak  # モデル変更
-rw-r--r-- settings.json.2026-01-31-12-15-20.bak  # 権限追加
-rw-r--r-- settings.json.2026-01-30-18-42-10.bak  # MCP設定
-rw-r--r-- settings.json.2026-01-30-09-25-33.bak  # テーマ変更
-rw-r--r-- settings.json.2026-01-29-16-08-05.bak  # 初期設定

# 差分を確認
$ diff \
  ~/.config/claude-code/backups/settings.json.2026-01-31-12-15-20.bak \
  ~/.config/claude-code/backups/settings.json.2026-01-31-14-30-45.bak

< "model": "claude-sonnet-4.5"
> "model": "claude-opus-4.5"

# 変更内容が明確に
```

### 実験的な設定のテスト

新しい設定を試してから元に戻す：

```bash
# ベースライン（14:30の状態）
Day 1, 14:30 - 安定した設定

# 実験1
Day 1, 15:00 - 新しいMCPサーバーを追加
> /config mcp.servers.experimental = {...}

# 実験2
Day 1, 15:30 - 権限設定を調整
> /config permissions.allow += ["Bash(docker *)"]

# 問題発生...
Day 1, 16:00 - 設定が競合している

# バックアップから選択
$ ls -lt ~/.config/claude-code/backups/
settings.json.2026-01-31-16-00-00.bak  # 問題のある状態
settings.json.2026-01-31-15-30-00.bak  # 実験2
settings.json.2026-01-31-15-00-00.bak  # 実験1
settings.json.2026-01-31-14-30-00.bak  # ベースライン ← これに戻す
settings.json.2026-01-31-12-00-00.bak  # さらに古い

# 安全な状態に復元
$ cp settings.json.2026-01-31-14-30-00.bak settings.json

# 変更により：
# - 複数の実験段階を保存
# - 任意の時点に戻れる
# - 安心して試行錯誤できる
```

### 自動ローテーションの仕組み

古いバックアップの自動削除：

```bash
# 初期状態：5件のバックアップ
settings.json.2026-01-31-14-00.bak
settings.json.2026-01-30-18-00.bak
settings.json.2026-01-29-12-00.bak
settings.json.2026-01-28-09-00.bak
settings.json.2026-01-27-16-00.bak  # 最古

# 新しい設定変更
> /config theme dark

# 新しいバックアップ作成 + 最古を削除
settings.json.2026-01-31-15-00.bak  # ← 新規
settings.json.2026-01-31-14-00.bak
settings.json.2026-01-30-18-00.bak
settings.json.2026-01-29-12-00.bak
settings.json.2026-01-28-09-00.bak
# settings.json.2026-01-27-16-00.bak は削除された

# メリット：
# - ディスク容量の節約
# - 最新の変更履歴を保持
# - 完全自動管理
```

### チーム環境での設定同期

複数マシン間での設定管理：

```bash
# マシンA（デスクトップ）で設定変更
Desktop> /config model claude-opus-4.5

# バックアップをバージョン管理
Desktop> cp ~/.config/claude-code/backups/settings.json.* \
            ~/Dropbox/claude-configs/

# マシンB（ラップトップ）で同期
Laptop> ls ~/Dropbox/claude-configs/
settings.json.2026-01-31-14-30-45.bak
settings.json.2026-01-31-12-15-20.bak
...

# タイムスタンプで最新を識別
Laptop> cp ~/Dropbox/claude-configs/settings.json.2026-01-31-14-30-45.bak \
           ~/.config/claude-code/settings.json

# 変更により：
# - タイムスタンプで同期が容易
# - チーム間で設定を共有
# - バージョン管理が簡単
```

### 災害復旧シナリオ

システムクラッシュ後の復旧：

```bash
# システム障害発生...
# Claude Codeが起動しない

# バックアップディレクトリを確認
$ ls ~/.config/claude-code/backups/

# すべて無事に保存されている！
settings.json.2026-01-31-14-30-45.bak
settings.json.2026-01-31-12-15-20.bak
settings.json.2026-01-30-18-42-10.bak
settings.json.2026-01-30-09-25-33.bak
settings.json.2026-01-29-16-08-05.bak

# 最新の動作確認済み設定を復元
$ cp settings.json.2026-01-30-18-42-10.bak \
     ~/.config/claude-code/settings.json

# Claude Code再起動
$ claude

✓ Configuration loaded successfully

# 変更により：
# - データ損失を最小化
# - 迅速な復旧が可能
# - ダウンタイム削減
```

### バックアップの手動管理

重要な設定を長期保存：

```bash
# 完璧に調整した設定をアーカイブ
$ mkdir -p ~/.config/claude-code/archives/

$ cp ~/.config/claude-code/settings.json \
     ~/.config/claude-code/archives/settings-perfect-2026-01-31.json

# 5件のローテーションバックアップとは別に、
# 重要な設定を永続保存

# 後日、完璧な設定に戻したい場合
$ cp ~/.config/claude-code/archives/settings-perfect-2026-01-31.json \
     ~/.config/claude-code/settings.json

# 変更により：
# - ローテーションとアーカイブを併用
# - 柔軟なバックアップ戦略
```

## 注意点

- バックアップは最新5件のみ保持され、それ以前は自動削除されます
- 重要な設定を長期保存したい場合は、手動でアーカイブしてください
- バックアップファイルのタイムスタンプは、設定変更時刻を反映します
- 複数の設定ファイル（settings.json、mcp.json など）がある場合、それぞれ個別にバックアップされます
- バックアップディレクトリは`~/.config/claude-code/backups/`です

## 関連情報

- [Configuration Management](https://code.claude.com/docs/en/reference/configuration)
- [Backup and Restore](https://code.claude.com/docs/en/advanced/backup-restore)
- [Data Protection](https://code.claude.com/docs/en/security/data-protection)
- [Configuration Files](https://code.claude.com/docs/en/reference/config-files)
- [Changelog v2.1.20](https://github.com/anthropics/claude-code/releases/tag/v2.1.20)
