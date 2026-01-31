---
title: "共有システムでのユーザー別一時ディレクトリ分離を修正"
date: 2026-01-29
tags: ['バグ修正', 'パーミッション', 'マルチユーザー', 'セキュリティ']
---

## 原文（日本語に翻訳）

共有システムでのパーミッション競合を防ぐため、ユーザーごとの一時ディレクトリ分離を修正

## 原文（英語）

Fixed per-user temp directory isolation to prevent permission conflicts on shared systems

## 概要

複数のユーザーが同じシステムを使用する環境（サーバー、CI/CD環境、共有開発マシンなど）で、Claude Codeの一時ファイルがユーザー間で競合する問題が修正されました。これにより、各ユーザーが独立した一時ディレクトリを使用するようになり、ファイルパーミッションエラーやデータ漏洩のリスクが解消されます。

## 基本的な使い方

この修正は自動的に適用されるため、ユーザー側での特別な設定は不要です。Claude Code v2.1.23以降では、各ユーザーの一時ファイルが以下のような分離されたディレクトリに保存されます。

### Linux/macOS
```
/tmp/claude-code-<username>/
または
~/.claude/tmp/
```

### Windows
```
C:\Users\<username>\AppData\Local\Temp\claude-code\
```

## 実践例

### マルチユーザー開発サーバーでの使用

複数の開発者が同じサーバーにSSHでアクセスして作業する場合：

```bash
# ユーザーAがClaude Codeを起動
user-a@server:~$ claude
# 一時ファイルは /tmp/claude-code-user-a/ に作成される

# ユーザーBが同時にClaude Codeを起動
user-b@server:~$ claude
# 一時ファイルは /tmp/claude-code-user-b/ に作成される（競合なし）
```

### CI/CDパイプラインでの並列実行

GitHub ActionsやGitLab CIで複数のジョブを並列実行する場合、各ジョブが独立したユーザーコンテキストで実行されるため、一時ディレクトリの競合が発生しません。

```yaml
# .github/workflows/test.yml
jobs:
  test-feature-a:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run Claude Code
        run: claude --headless "test feature A"

  test-feature-b:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run Claude Code
        run: claude --headless "test feature B"
```

### Dockerコンテナでのマルチインスタンス実行

同じホスト上で複数のDockerコンテナを実行する場合：

```bash
# コンテナ1
docker run -u 1001:1001 -it claude-image
# 一時ディレクトリ: /tmp/claude-code-1001/

# コンテナ2（異なるユーザーID）
docker run -u 1002:1002 -it claude-image
# 一時ディレクトリ: /tmp/claude-code-1002/
```

### 共有開発環境でのクリーンアップ

古い一時ファイルを定期的にクリーンアップするスクリプト例：

```bash
#!/bin/bash
# cleanup-claude-tmp.sh

# 7日以上古い一時ファイルを削除
find /tmp/claude-code-$USER -type f -mtime +7 -delete 2>/dev/null

# 空のディレクトリを削除
find /tmp/claude-code-$USER -type d -empty -delete 2>/dev/null

echo "Claude Code一時ファイルのクリーンアップが完了しました"
```

## 注意点

- この修正はv2.1.23で導入されたため、それ以前のバージョンでは依然として競合が発生する可能性があります
- 共有システムでClaude Codeを使用する場合は、v2.1.23以降へのアップグレードを推奨します
- 一時ディレクトリは通常、セッション終了時に自動的にクリーンアップされますが、異常終了時には残る場合があります
- ディスク容量が制限されている環境では、定期的なクリーンアップスクリプトの設定を検討してください
- セキュリティ上、一時ファイルには機密情報が含まれる可能性があるため、適切なパーミッション（600または700）が設定されます
- コンテナ環境では、ユーザーIDが重複しないように注意してください

## 関連情報

- [Linuxファイルパーミッションについて](https://www.redhat.com/sysadmin/linux-file-permissions-explained)
- [マルチユーザーシステムのベストプラクティス](https://wiki.archlinux.org/title/Users_and_groups)
- [Changelog v2.1.23](https://github.com/anthropics/claude-code/releases/tag/v2.1.23)
- CI/CD環境でのClaude Code使用については、公式ドキュメントを参照してください
