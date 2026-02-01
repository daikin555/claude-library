---
title: "mcp list と mcp get コマンドで孤立プロセスが残る問題を修正"
date: 2026-01-13
tags: ['バグ修正', 'MCP', 'コマンド', 'プロセス管理']
---

## 原文（日本語に翻訳）

`mcp list` と `mcp get` コマンドが孤立した MCP サーバープロセスを残す問題を修正

## 原文（英語）

Fixed `mcp list` and `mcp get` commands leaving orphaned MCP server processes

## 概要

Claude Code v2.1.6 では、MCP（Model Context Protocol）サーバー管理の重要な問題が修正されました。以前のバージョンでは、`/mcp list` や `/mcp get` コマンドを実行した際に、MCP サーバープロセスが正しく終了されず、バックグラウンドで孤立プロセスとして残り続ける問題がありました。この修正により、プロセスが適切にクリーンアップされ、システムリソースの無駄遣いが解消されました。

## 基本的な使い方

この修正は自動的に適用され、ユーザー側での特別な操作は不要です。

MCP コマンドの正常な動作:
1. `/mcp list` で MCP サーバー一覧を表示
2. `/mcp get <name>` で特定の MCP サーバー情報を取得
3. コマンド終了後、プロセスが自動的にクリーンアップされる

## 実践例

### 修正前の問題（v2.1.5以前）

MCP コマンドを実行するたびにプロセスが残る:

```bash
# MCP サーバー一覧を確認
/mcp list

# 数回実行後、プロセスを確認
$ ps aux | grep mcp
user  1234  mcp-server --stdio  # 孤立プロセス
user  1235  mcp-server --stdio  # 孤立プロセス
user  1236  mcp-server --stdio  # 孤立プロセス
user  1237  mcp-server --stdio  # 孤立プロセス
# 複数の孤立プロセスが蓄積

# システムリソースを消費
$ top
# CPU使用率が上昇
# メモリ使用量が増加
```

この問題により:
- CPU とメモリの無駄遣い
- システムパフォーマンスの低下
- 長時間使用後にリソース不足が発生

### 修正後の動作（v2.1.6以降）

v2.1.6 では、プロセスが正しくクリーンアップされます:

```bash
# MCP サーバー一覧を確認
/mcp list

# プロセスを確認
$ ps aux | grep mcp
# 実行中の MCP サーバーのみ表示される
# 孤立プロセスは存在しない

# 何度実行してもプロセスは増えない
/mcp list
/mcp list
/mcp list

$ ps aux | grep mcp
# クリーンな状態を維持
```

### MCP サーバー一覧の確認

利用可能な MCP サーバーを確認:

```bash
# MCP サーバー一覧を表示
/mcp list

# 出力例:
Available MCP servers:
  ✓ filesystem - File operations
  ✓ database - Database queries
  ✓ web-search - Web search capabilities
  ○ analytics - Analytics tools (disabled)

# プロセスは自動的にクリーンアップされる
```

### 特定の MCP サーバー情報の取得

MCP サーバーの詳細情報を確認:

```bash
# 特定のサーバー情報を取得
/mcp get filesystem

# 出力例:
MCP Server: filesystem
Status: Enabled
Version: 1.0.0
Capabilities:
  - read_file
  - write_file
  - list_directory
Configuration:
  root: /home/user/projects

# コマンド終了後、プロセスは自動終了
```

### 孤立プロセスの手動クリーンアップ（v2.1.5以前のユーザー向け）

v2.1.5 以前を使用していた場合、既存の孤立プロセスを手動で終了:

```bash
# 孤立した MCP プロセスを確認
$ ps aux | grep mcp-server

# 孤立プロセスを終了
$ pkill -f "mcp-server"

# または個別に終了
$ kill 1234 1235 1236 1237

# プロセスが終了したことを確認
$ ps aux | grep mcp-server
# 何も表示されなければ成功
```

### MCP サーバーの有効化/無効化

MCP サーバーの状態管理:

```bash
# MCP サーバーを有効化
/mcp enable filesystem

# MCP サーバーを無効化
/mcp disable analytics

# 状態を確認
/mcp list

# これらのコマンドでもプロセスは正しく管理される
```

### システムリソースの確認

MCP プロセスのリソース使用状況:

```bash
# v2.1.5 以前（問題あり）
$ ps aux | grep mcp | wc -l
15  # 15個の孤立プロセス

$ free -h
# メモリが圧迫されている

# v2.1.6 以降（正常）
$ ps aux | grep mcp | wc -l
2  # 実行中のサーバーのみ

$ free -h
# メモリは正常
```

### 長時間使用時の動作

長時間使用しても問題なし:

```bash
# 1日中 Claude Code を使用
# 何度も /mcp list を実行

# v2.1.5 以前:
# → 数百のプロセスが蓄積
# → システムが遅くなる

# v2.1.6 以降:
# → プロセスは常にクリーンな状態
# → パフォーマンスは安定
```

### MCP サーバーの再起動

MCP サーバーを再起動する場合:

```bash
# サーバーを無効化
/mcp disable filesystem

# サーバーを再度有効化
/mcp enable filesystem

# v2.1.6 では、古いプロセスは正しく終了される
# 新しいプロセスのみが起動
```

## 注意点

- この修正は Claude Code v2.1.6 で導入されました
- v2.1.5 以前を使用していた場合、既存の孤立プロセスは手動で終了する必要があります
- MCP サーバープロセスは、使用中のみバックグラウンドで実行されます
- コマンド実行後、不要なプロセスは自動的に終了されます
- この修正により、長時間の使用でもシステムリソースが安定します
- 複数の MCP サーバーを使用している場合でも、プロセス管理は正常に機能します
- MCP サーバーの応答がない場合のタイムアウト処理も改善されています

## 関連情報

- [Changelog v2.1.6](https://github.com/anthropics/claude-code/releases/tag/v2.1.6)
- [MCP (Model Context Protocol)](https://modelcontextprotocol.io/)
- [Claude Code MCP 統合](https://code.claude.com/docs/mcp)
