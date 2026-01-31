---
title: "ターミナル終了時の残留プロセス問題を修正"
date: 2026-01-23
tags: ['バグ修正', 'プロセス管理', 'ターミナル']
---

## 原文（日本語に翻訳）

ターミナルが閉じられた際にClaude Codeプロセスが残留する問題を修正しました。`process.exit()` からのEIOエラーをキャッチし、フォールバックとしてSIGKILLを使用するようにしました。

## 原文（英語）

Fixed dangling Claude Code processes when terminal is closed by catching EIO errors from `process.exit()` and using SIGKILL as fallback

## 概要

Claude Code v2.1.19で、ターミナルを強制終了した際にClaude Codeのプロセスがバックグラウンドで残り続けてしまう問題が修正されました。この問題は、ターミナルエミュレータが予期せず閉じられた場合やSSH接続が切断された場合に、プロセスが適切にクリーンアップされずにゾンビプロセスとして残留していました。

v2.1.19では、`process.exit()` からのEIO（Input/Output Error）エラーを適切にキャッチし、通常の終了処理が失敗した場合はSIGKILLシグナルを使用して強制終了することで、確実にプロセスを終了させるようになりました。

## 問題が発生していたシナリオ

### ターミナルの強制終了

- ターミナルウィンドウを×ボタンで強制的に閉じた場合
- 「強制終了」でターミナルアプリを終了した場合
- システムシャットダウン時にターミナルが強制終了された場合

### SSH接続の切断

```bash
# SSHでリモートサーバーに接続してClaude Codeを実行
ssh user@remote-server
cd /project
claude

# ネットワーク切断や接続タイムアウトが発生
# → 以前のバージョンでは Claude Code プロセスが残留
```

### CI/CD環境での強制終了

```yaml
# GitHub Actions
jobs:
  review:
    runs-on: ubuntu-latest
    timeout-minutes: 10  # タイムアウト設定
    steps:
      - run: claude -p "Review this code"
      # タイムアウト時にプロセスが残留していた
```

## 修正による改善

### プロセスの確実な終了

v2.1.19以降では、以下の2段階終了メカニズムで確実にクリーンアップされます:

1. **通常の終了処理**: `process.exit()` による正常終了を試行
2. **フォールバック処理**: EIOエラーが発生した場合はSIGKILLで強制終了

### リソースリークの防止

残留プロセスによる問題を防止:

- **メモリ使用量**: ゾンビプロセスによるメモリ消費を防止
- **CPU使用率**: バックグラウンドで動作し続けることによるCPU負荷を回避
- **ファイルディスクリプタ**: 開いたままのファイルやネットワーク接続を適切にクローズ
- **プロセス数制限**: システムのプロセス数上限に達することを防止

## 実践例

### ターミナルの安全な使用

以前は残留プロセスの心配がありましたが、v2.1.19以降は安心して使用できます:

```bash
# Claude Codeを起動
claude

# 作業中...

# ターミナルを×ボタンで閉じても
# → プロセスは確実に終了します
```

### SSH経由でのリモート作業

ネットワーク切断時も安全:

```bash
# リモートサーバーでの作業
ssh user@production-server
claude -p "Deploy the latest changes"

# SSH接続が突然切れても
# → Claude Codeプロセスは適切に終了
```

### プロセス監視の必要性が減少

以前は定期的なプロセス監視が必要でしたが、v2.1.19以降は不要に:

```bash
# 以前: 残留プロセスの確認と削除が必要だった
ps aux | grep claude
pkill -9 claude

# v2.1.19以降: 自動的にクリーンアップされる
# 手動での介入は不要
```

### CI/CD環境での安定性向上

タイムアウトやキャンセル時も安全:

```yaml
# GitHub Actions
jobs:
  code-review:
    runs-on: ubuntu-latest
    timeout-minutes: 15
    steps:
      - uses: actions/checkout@v4
      - name: Install Claude Code
        run: curl -fsSL https://claude.ai/install.sh | bash

      - name: Run review
        run: claude -p "Review changes for security issues"
        # タイムアウトやジョブキャンセル時も
        # プロセスが確実に終了する
```

### Docker/コンテナ環境

コンテナ停止時のクリーンな終了:

```bash
# Dockerコンテナ内でClaude Codeを実行
docker run -it my-dev-env claude

# コンテナを停止
docker stop <container-id>
# → Claude Codeプロセスは適切にクリーンアップされる
```

## トラブルシューティング

### 残留プロセスの確認方法

もし古いバージョンでプロセスが残留している場合:

```bash
# Claude Codeプロセスの確認（Linux/macOS）
ps aux | grep "claude"

# プロセス数の確認
pgrep -c claude

# 詳細情報の表示
pgrep -a claude
```

### 残留プロセスの手動削除

v2.1.19より前のバージョンで残留したプロセスを削除:

```bash
# すべてのClaude Codeプロセスを終了（注意: 実行中のセッションも終了します）
pkill claude

# より確実な強制終了
pkill -9 claude

# または特定のPIDを指定
kill -9 <PID>
```

### アップグレード推奨

この問題を根本的に解決するには、v2.1.19以降にアップグレードしてください:

```bash
# Claude Codeをアップデート
claude update

# バージョン確認
claude --version

# v2.1.19以上であることを確認
```

## 技術的な詳細

### EIOエラーとは

**EIO (Input/Output Error)** は、入出力操作が失敗したことを示すエラーです。ターミナルが予期せず閉じられると、標準入出力へのアクセスが失敗し、このエラーが発生します。

### SIGKILLフォールバック

- **SIGTERM/SIGINT**: 通常の終了シグナル（プロセスが無視できる）
- **SIGKILL**: 強制終了シグナル（プロセスが無視できない、カーネルが即座に終了させる）

v2.1.19では、通常の終了が失敗した場合にSIGKILLを使用することで、どのような状況でもプロセスが確実に終了するようになりました。

## 注意点

- **バージョン確認**: この修正はv2.1.19で導入されました。それより前のバージョンでは問題が発生する可能性があります
- **正常終了を優先**: 可能な限りCtrl+Dやexitコマンドでの正常終了を推奨します
- **セッションの保存**: 強制終了前に重要な作業は保存するか、セッションに名前を付けておくことを推奨します

## 関連情報

- [Claude Code 公式ドキュメント - トラブルシューティング](https://code.claude.com/docs/en/troubleshooting)
- [Changelog v2.1.19](https://github.com/anthropics/claude-code/releases/tag/v2.1.19)
