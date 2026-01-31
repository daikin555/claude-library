---
title: "ホームディレクトリに蓄積される破損した設定バックアップファイルを修正"
date: 2026-01-13
tags: ['バグ修正', '設定', 'ファイル管理', 'ストレージ']
---

## 原文（日本語に翻訳）

ホームディレクトリに破損した設定バックアップファイルが蓄積される問題を修正（現在は設定ファイルごとに1つのバックアップのみ作成）

## 原文（英語）

Fixed corrupted config backup files accumulating in the home directory (now only one backup is created per config file)

## 概要

Claude Code v2.1.6 では、設定ファイルのバックアップに関する重要な問題が修正されました。以前のバージョンでは、設定を変更するたびに新しいバックアップファイルが作成され、ホームディレクトリに大量の（時には破損した）バックアップファイルが蓄積していました。この修正により、設定ファイルごとに最新のバックアップ1つのみが保持されるようになり、ディスク容量の無駄遣いが解消されました。

## 基本的な使い方

この修正は自動的に適用され、ユーザー側での特別な操作は不要です。

設定ファイルのバックアップ動作:
1. 設定を変更すると、既存のバックアップが上書きされる
2. 各設定ファイルに対して1つのバックアップのみが保持される
3. 古いバックアップは自動的に削除される

## 実践例

### 修正前の問題（v2.1.5以前）

設定を変更するたびにバックアップが蓄積:

```bash
# ホームディレクトリを確認
$ ls -la ~/ | grep claude

-rw-r--r-- .claude-config.json.backup.20260101-120000
-rw-r--r-- .claude-config.json.backup.20260101-130000
-rw-r--r-- .claude-config.json.backup.20260101-140000
-rw-r--r-- .claude-config.json.backup.20260102-090000
...
-rw-r--r-- .claude-config.json.backup.20260130-183000
# 数十から数百のバックアップファイルが蓄積

# しかも一部が破損している
$ cat ~/.claude-config.json.backup.20260115-100000
{
  "model": "claude-sonnet-4"
  # 不完全な JSON、破損したファイル
```

この問題により:
- ディスク容量の無駄遣い（数MB〜数百MB）
- ホームディレクトリの散らかり
- バックアップファイルの破損

### 修正後の動作（v2.1.6以降）

v2.1.6 では、最新のバックアップ1つのみが保持されます:

```bash
# ホームディレクトリを確認
$ ls -la ~/ | grep claude

-rw-r--r-- .claude-config.json
-rw-r--r-- .claude-config.json.backup  # 1つだけ

# 内容も完全
$ cat ~/.claude-config.json.backup
{
  "model": "claude-sonnet-4",
  "theme": "dark",
  ...
}  # 完全な JSON
```

### 設定変更時のバックアップ動作

設定を変更した場合:

```bash
# 1回目の設定変更
/config
# theme を "dark" に変更
# → .claude-config.json.backup が作成される

# 2回目の設定変更
/config
# model を "claude-opus-4" に変更
# → 既存の .claude-config.json.backup が上書きされる

# 結果: バックアップは常に1つだけ
$ ls ~/.claude-config.json*
.claude-config.json
.claude-config.json.backup  # 最新の状態
```

### バックアップからの復元

設定を誤って変更した場合:

```bash
# 設定を誤って変更してしまった
/config
# 何かを間違えた...

# バックアップから復元
$ cp ~/.claude-config.json.backup ~/.claude-config.json

# Claude Code を再起動
$ claude

# 前回の設定が復元される
```

### 古いバックアップファイルのクリーンアップ

v2.1.5 以前から使用している場合、手動でクリーンアップ:

```bash
# 古いバックアップファイルを確認
$ ls -la ~/ | grep "claude.*backup"

# 古いタイムスタンプ付きバックアップを削除
$ rm ~/.claude-config.json.backup.2026*

# .backup のみを残す
$ ls ~/.claude-config.json*
.claude-config.json
.claude-config.json.backup  # これだけ残す
```

### ディスク容量の確認

バックアップファイルのサイズを確認:

```bash
# v2.1.5 以前の場合
$ du -sh ~/.claude*backup*
45M ~/.claude-config.json.backup.*  # 大量のファイル

# v2.1.6 以降の場合
$ du -sh ~/.claude*backup
12K ~/.claude-config.json.backup  # 1ファイルのみ
```

### 複数の設定ファイル

Claude Code が複数の設定ファイルを使用している場合:

```bash
# 各設定ファイルに対して1つのバックアップ
$ ls ~/.claude*

.claude-config.json
.claude-config.json.backup

.claude-auth.json
.claude-auth.json.backup

.claude-mcp.json
.claude-mcp.json.backup

# 各ファイルに1つずつ、合計3つのバックアップ
# 以前は数百のファイルが存在していた
```

### バックアップの自動管理

バックアップは自動的に管理されます:

```bash
# 設定変更のたびに
1. 現在の設定を .backup にコピー（上書き）
2. 新しい設定を保存
3. 古いバックアップは自動削除

# ユーザーは何もする必要がない
```

## 注意点

- この修正は Claude Code v2.1.6 で導入されました
- 設定ファイルごとに最新のバックアップ1つのみが保持されます
- v2.1.5 以前から使用している場合、古いバックアップファイルが残っている可能性があります
- 古いバックアップファイルは手動で削除しても問題ありません
- バックアップファイルは設定変更時に自動的に作成されます
- 破損したバックアップの問題も同時に修正されました
- ディスク容量の節約だけでなく、ホームディレクトリの整理整頓にも貢献します
- 複数世代のバックアップが必要な場合は、手動でコピーを作成してください

## 関連情報

- [Changelog v2.1.6](https://github.com/anthropics/claude-code/releases/tag/v2.1.6)
- [Claude Code 設定管理](https://code.claude.com/docs/configuration)
