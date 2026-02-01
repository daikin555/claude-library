---
title: "特殊ファイルのシンボリックリンク解決をスキップしてFIFO読み取りハングを修正"
date: 2026-01-31
tags: ['バグ修正', 'ファイルシステム', 'FIFO']
---

## 原文（日本語に翻訳）

特殊ファイルタイプのシンボリックリンク解決をスキップすることで、FIFOファイル読み取り時のハングを修正しました

## 原文（英語）

Fixed a hang when reading FIFO files by skipping symlink resolution for special file types

## 概要

Claude Code v2.1.0で修正された、特殊ファイル読み取り時のハングバグです。以前のバージョンでは、FIFO（名前付きパイプ）やその他の特殊ファイルを読み取ろうとすると、シンボリックリンク解決処理が無限待機に入り、Claude Codeが応答しなくなっていました。この修正により、FIFO、ソケット、デバイスファイルなどの特殊ファイルタイプに対してはシンボリックリンク解決をスキップし、適切にエラーを返すようになりました。

## 修正前の問題

### 症状

```bash
# FIFOファイルの存在するディレクトリ
ls -l /tmp/
# prw-r--r-- 1 user user 0 Jan 31 10:00 my-pipe  # FIFO

# Claude Code起動
claude

> /tmp/my-pipe を読んで

# ハング（無応答）
# Claude Codeが永久に待機
# Ctrl+C で中断するしかない
```

### 根本原因

```
Read tool呼び出し:
1. ファイルパス: /tmp/my-pipe
2. シンボリックリンクチェック開始
3. FIFOファイルをopenで開く
4. FIFOは書き込み側が接続するまでブロック
5. 無限待機（デッドロック）
```

## 修正後の動作

### 適切なエラーハンドリング

```bash
# FIFOファイルを読み取り試行
claude

> /tmp/my-pipe を読んで

# 修正後:
# 1. ファイルタイプをチェック（stat syscall）
# 2. FIFOと判定
# 3. シンボリックリンク解決をスキップ
# 4. 適切なエラーメッセージを返す

# Claude:
# "エラー: /tmp/my-pipe は特殊ファイル（FIFO）です。
#  通常のファイルのみ読み取り可能です。"
```

## 実践例

### /proc ファイルシステムでの動作

Linuxの/procディレクトリには多数の特殊ファイルがあります。

```bash
# /proc 内のファイルを確認
claude

> /proc/self/fd/ のファイル一覧を表示

# 修正前: 一部の特殊ファイルでハング
# 修正後: 特殊ファイルをスキップして継続
# ✓ 通常のファイルのみ処理
```

### デバイスファイルの誤読み取り防止

/devディレクトリのデバイスファイルを誤って読もうとした場合。

```bash
# デバイスファイル
ls -l /dev/null
# crw-rw-rw- 1 root root 1, 3 Jan 31 /dev/null

claude

> /dev/null を読んで

# 修正前: ハング（無限にデータを読もうとする）
# 修正後: エラーメッセージ
# "エラー: /dev/null はデバイスファイルです。読み取りできません。"
```

### ソケットファイルのスキップ

Unixドメインソケットファイルの処理。

```bash
# ソケットファイル
ls -l /tmp/
# srwxr-xr-x 1 user user 0 Jan 31 my-socket  # ソケット

claude

> /tmp/my-socket を読んで

# 修正後: 即座にエラー
# "エラー: /tmp/my-socket はソケットファイルです。"
```

### グロブパターンでの自動スキップ

ディレクトリ内のファイルを一括処理する際、特殊ファイルを自動スキップ。

```bash
# 混在ディレクトリ
/tmp/
├── file1.txt        # 通常ファイル
├── file2.txt        # 通常ファイル
├── my-pipe          # FIFO
└── my-socket        # ソケット

claude

> /tmp/* のすべてのファイルを読んで

# 修正後:
# - file1.txt: ✓ 読み取り成功
# - file2.txt: ✓ 読み取り成功
# - my-pipe: スキップ（警告表示）
# - my-socket: スキップ（警告表示）

# Claude:
# "4ファイル中2ファイルを読み取りました。
#  2ファイルは特殊ファイルのためスキップしました。"
```

## 注意点

- この修正は Claude Code v2.1.0（2026年1月7日リリース）で実装されました
- 特殊ファイルタイプ:
  - **FIFO（named pipe）**: `mkfifo` で作成されるパイプ
  - **ソケット**: Unixドメインソケット
  - **デバイスファイル**: `/dev/` 内のキャラクタ・ブロックデバイス
  - **proc/sysファイルシステム**: 仮想ファイルシステム
- 修正の詳細:
  - ファイルを開く前に `stat()` でファイルタイプをチェック
  - 特殊ファイルと判定された場合、読み取りをスキップ
  - 適切なエラーメッセージを返す
- スキップされるファイルタイプ:
  ```bash
  # Linuxのファイルタイプ
  S_IFIFO   # FIFO (named pipe)
  S_IFCHR   # Character device
  S_IFBLK   # Block device
  S_IFSOCK  # Socket
  ```
- 通常ファイルとして扱われるもの:
  - 通常のファイル（S_IFREG）
  - シンボリックリンク（S_IFLNK）→ リンク先を読み取り
  - ディレクトリ（S_IFDIR）→ エラー（ディレクトリは読み取り不可）
- エラーメッセージ:
  ```
  Error: Cannot read file /tmp/my-pipe
  Reason: File is a FIFO (named pipe)
  Note: Only regular files can be read
  ```
- パフォーマンスへの影響:
  - `stat()` 呼び出しが追加されるが、オーバーヘッドは最小限
  - ハング防止により、全体的な安定性が向上
- デバッグ:
  - `--debug` フラグでファイルタイプチェックのログを確認
  - ログに「Skipping special file: /tmp/my-pipe (FIFO)」が表示される
- 回避策（修正前）:
  - FIFOファイルを明示的に除外
  - `find` コマンドで通常ファイルのみ検索:
    ```bash
    find /tmp -type f  # 通常ファイルのみ
    ```
- 関連するシステムコール:
  - `stat()`: ファイル情報取得
  - `lstat()`: シンボリックリンク自体の情報取得
  - `open()`: ファイルオープン（FIFOではブロック）
- FIFO の使用例（参考）:
  ```bash
  # FIFOを作成
  mkfifo /tmp/my-pipe

  # ターミナル1: 読み取り側（ブロック）
  cat /tmp/my-pipe

  # ターミナル2: 書き込み側
  echo "data" > /tmp/my-pipe

  # → ターミナル1でdataが表示される
  ```

## 関連情報

- [Read tool - Claude Code Docs](https://code.claude.com/docs/en/read-tool)
- [File system special files (Wikipedia)](https://en.wikipedia.org/wiki/Device_file)
- [FIFO (named pipes) in Linux](https://man7.org/linux/man-pages/man7/fifo.7.html)
