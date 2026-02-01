---
title: "Writeツールがシステムumaskを無視して0o600で作成する問題を修正"
date: 2026-01-31
tags: ['バグ修正', 'ファイルパーミッション', 'Unix']
---

## 原文（日本語に翻訳）

Writeツールで作成されたファイルがシステムumaskを尊重せず、ハードコードされた0o600パーミッションを使用する問題を修正しました

## 原文（英語）

Fixed files created by the Write tool using hardcoded 0o600 permissions instead of respecting the system umask

## 概要

Claude Code v2.1.0で修正された、ファイルパーミッション設定バグです。以前のバージョンでは、Writeツールで作成されたすべてのファイルが、システムのumask設定を無視して`0o600`（所有者のみ読み書き可能）パーミッションで作成されていました。この修正により、システムのumask設定が適切に適用され、チーム開発環境や共有サーバーでの使用時に、正しいファイルパーミッションが設定されるようになりました。

## 修正前の問題

### 症状

```bash
# システムのumask設定を確認
umask
# 0022（ファイル: 0644、ディレクトリ: 0755）

# Claude Codeでファイル作成
claude

> README.md ファイルを作成して

# 修正前: 作成されたファイルのパーミッション
ls -l README.md
# -rw------- 1 user group 1234 Jan 31 10:00 README.md
# 0600（所有者のみアクセス可能）

# 期待: umaskに基づく 0644
# -rw-r--r-- 1 user group 1234 Jan 31 10:00 README.md
# グループとその他のユーザーが読み取り可能
```

### 影響

- チーム開発で他のメンバーがファイルにアクセスできない
- CI/CDパイプラインでパーミッションエラー
- Webサーバーがファイルを読み取れない

## 修正後の動作

### umaskの尊重

```bash
# システムのumask: 0022
umask
# 0022

# Claude Codeでファイル作成
claude

> config.json を作成

# 修正後: umaskが適用される
ls -l config.json
# -rw-r--r-- 1 user group 234 Jan 31 10:00 config.json
# 0644（グループとその他が読み取り可能）

# 実行可能ファイルの場合
> install.sh スクリプトを作成

ls -l install.sh
# -rwxr-xr-x 1 user group 456 Jan 31 10:00 install.sh
# 0755（すべてのユーザーが実行可能）
```

## 実践例

### チーム開発環境での共有

チームメンバーが作成したファイルにアクセスできます。

```bash
# 共有開発サーバー
# umask 0002（グループ書き込み可能）
umask
# 0002

claude

> team-docs.md を作成

# 修正後:
ls -l team-docs.md
# -rw-rw-r-- 1 alice devteam 789 Jan 31 10:00 team-docs.md
# グループメンバーが編集可能
```

### Webサーバー用ファイルの作成

Webサーバーがアクセスできるファイルを作成します。

```bash
# Web公開ディレクトリ
cd /var/www/html

# umask 0022（標準）
claude

> index.html を作成

# 修正後:
ls -l index.html
# -rw-r--r-- 1 www-data www-data 2048 Jan 31 10:00 index.html
# Webサーバーが読み取り可能
```

### CI/CD環境での自動生成

CI/CDパイプラインで生成されたファイルが正しく処理されます。

```bash
# GitHub Actions
- name: Generate files
  run: |
    # umask 0022がデフォルト
    claude --prompt "ドキュメントを生成"

# 生成されたファイル
# -rw-r--r-- docs/api.md
# CI/CDの次のステップで読み取り可能
```

### セキュリティ重視の環境

厳格なumaskでもproper動作します。

```bash
# セキュリティ重視のumask
umask 0077  # 所有者のみアクセス可能

claude

> secret-config.json を作成

# 修正後: umaskが適用される
ls -l secret-config.json
# -rw------- 1 user group 123 Jan 31 10:00 secret-config.json
# 所有者のみアクセス可能（意図通り）
```

## 注意点

- この修正は Claude Code v2.1.0（2026年1月7日リリース）で実装されました
- umask（ユーザーファイル作成マスク）:
  - ファイル/ディレクトリ作成時のデフォルトパーミッションを制御
  - 数値が大きいほど制限が厳しい
  - `umask` コマンドで確認・設定
- 一般的なumask値:
  - **0022**: 標準（ファイル: 0644、ディレクトリ: 0755）
  - **0002**: グループ書き込み可（ファイル: 0664、ディレクトリ: 0775）
  - **0077**: 所有者のみ（ファイル: 0600、ディレクトリ: 0700）
- パーミッション計算:
  ```
  ファイルのベース: 0666
  umask: 0022
  結果: 0666 - 0022 = 0644 (-rw-r--r--)

  ディレクトリのベース: 0777
  umask: 0022
  結果: 0777 - 0022 = 0755 (drwxr-xr-x)
  ```
- 修正前の動作（0o600）:
  - セキュリティを重視した設定
  - すべてのファイルが所有者のみアクセス可能
  - 共有環境では不便
- 修正後の動作:
  - システムのumaskを尊重
  - 環境に応じた適切なパーミッション
  - ユーザーの意図を反映
- Editツールへの影響:
  - Editツールは既存ファイルのパーミッションを保持
  - この修正による影響なし
- umaskの設定方法:
  ```bash
  # 一時的に設定
  umask 0002

  # 永続的に設定（~/.bashrc または ~/.zshrc）
  echo "umask 0002" >> ~/.bashrc
  ```
- セキュリティ考慮事項:
  - 機密ファイルを作成する場合、厳格なumask（0077）を設定
  - または作成後に手動で `chmod 600` を実行
- デバッグ:
  - `--debug` フラグでファイル作成のログを確認
  - ログに「Creating file with umask-based permissions」が表示される
- トラブルシューティング:
  - 期待と異なるパーミッションの場合:
    1. `umask` でumask値を確認
    2. 必要に応じてumaskを変更
    3. ファイルを再作成
- 既存ファイルの修正:
  ```bash
  # 一括でパーミッション修正
  find . -type f -perm 600 -exec chmod 644 {} \;
  ```
- Windowsへの影響:
  - Windowsではumaskの概念がない
  - この修正による影響なし
  - デフォルトのWindowsパーミッションが適用される

## 関連情報

- [Write tool - Claude Code Docs](https://code.claude.com/docs/en/write-tool)
- [File permissions (Wikipedia)](https://en.wikipedia.org/wiki/File-system_permissions)
- [umask - Linux man page](https://man7.org/linux/man-pages/man2/umask.2.html)
