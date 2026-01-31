---
title: "CLAUDE_CODE_TMPDIR：一時ディレクトリのカスタマイズ"
date: 2026-01-12
tags: [新機能, 環境変数, 設定]
---

# CLAUDE_CODE_TMPDIR：一時ディレクトリのカスタマイズ

## 原文（日本語に翻訳）

Claude Codeが内部で使用する一時ファイルの保存先ディレクトリを上書きするための環境変数 `CLAUDE_CODE_TMPDIR` が追加されました。カスタムの一時ディレクトリ要件がある環境で便利です。

## 原文（英語）

Added `CLAUDE_CODE_TMPDIR` environment variable to override the temp directory used for internal temp files, useful for environments with custom temp directory requirements

## 概要

Claude Code v2.1.5で、`CLAUDE_CODE_TMPDIR` 環境変数が導入されました。この環境変数を設定することで、Claude Codeが内部処理で使用する一時ファイルの保存先を、システムのデフォルト一時ディレクトリから任意の場所に変更できます。企業のセキュリティポリシーに準拠したストレージの使用や、パフォーマンスの最適化のために特定のディスクを使用したい場合に役立ちます。

## 基本的な使い方

### 環境変数の設定

Claude Codeを起動する前に、`CLAUDE_CODE_TMPDIR` 環境変数を設定します。

#### Linux / macOS

```bash
# シェルで直接設定
export CLAUDE_CODE_TMPDIR=/path/to/custom/tmp

# Claude Codeを起動
claude
```

#### Windows (PowerShell)

```powershell
# 環境変数を設定
$env:CLAUDE_CODE_TMPDIR = "C:\path\to\custom\tmp"

# Claude Codeを起動
claude
```

#### Windows (コマンドプロンプト)

```cmd
# 環境変数を設定
set CLAUDE_CODE_TMPDIR=C:\path\to\custom\tmp

# Claude Codeを起動
claude
```

### 永続的な設定

#### Linux / macOS (Bashの場合)

`~/.bashrc` または `~/.bash_profile` に以下を追加：

```bash
export CLAUDE_CODE_TMPDIR=/path/to/custom/tmp
```

#### Linux / macOS (Zshの場合)

`~/.zshrc` に以下を追加：

```bash
export CLAUDE_CODE_TMPDIR=/path/to/custom/tmp
```

#### Windows (システム環境変数)

1. 「システムのプロパティ」→「環境変数」を開く
2. 「ユーザー環境変数」または「システム環境変数」で新規作成
3. 変数名：`CLAUDE_CODE_TMPDIR`
4. 変数値：`C:\path\to\custom\tmp`

## 実践例

### セキュリティ要件の遵守

企業のセキュリティポリシーで、一時ファイルを暗号化されたボリュームに保存する必要がある場合：

```bash
# 暗号化ボリュームを一時ディレクトリとして指定
export CLAUDE_CODE_TMPDIR=/mnt/encrypted-volume/claude-tmp

# ディレクトリが存在しない場合は作成
mkdir -p /mnt/encrypted-volume/claude-tmp

# Claude Codeを起動
claude
```

### パフォーマンスの最適化

高速なSSDを一時ディレクトリとして使用することで、大きなファイルの処理を高速化：

```bash
# 高速SSDのパスを指定
export CLAUDE_CODE_TMPDIR=/mnt/nvme-ssd/tmp/claude

# ディレクトリを作成（存在しない場合）
mkdir -p /mnt/nvme-ssd/tmp/claude

# Claude Codeを起動
claude
```

### ストレージ容量の管理

システムの `/tmp` が小さい環境で、容量の大きな別のディスクを使用：

```bash
# 容量の大きいディスクを一時ディレクトリとして指定
export CLAUDE_CODE_TMPDIR=/data/tmp/claude

# ディレクトリを作成
mkdir -p /data/tmp/claude

# Claude Codeを起動
claude
```

### CI/CD環境での利用

GitLab CI、GitHub Actions、JenkinsなどのCI/CD環境で、ビルドごとに独立した一時ディレクトリを使用：

```yaml
# .gitlab-ci.yml の例
claude_job:
  script:
    - export CLAUDE_CODE_TMPDIR=$CI_PROJECT_DIR/.tmp/claude
    - mkdir -p $CLAUDE_CODE_TMPDIR
    - claude --version
    - # Claude Codeを使用したタスク
```

```yaml
# GitHub Actions の例
- name: Setup Claude Code
  run: |
    export CLAUDE_CODE_TMPDIR=${{ github.workspace }}/.tmp/claude
    mkdir -p $CLAUDE_CODE_TMPDIR
    claude --version
```

### Docker環境での利用

Dockerコンテナ内でボリュームマウントされたディレクトリを一時ディレクトリとして使用：

```dockerfile
# Dockerfile
FROM ubuntu:latest

# Claude Codeのインストール（例）
RUN curl -fsSL https://claude.ai/install.sh | sh

# 一時ディレクトリの環境変数を設定
ENV CLAUDE_CODE_TMPDIR=/app/tmp/claude

# ディレクトリを作成
RUN mkdir -p /app/tmp/claude

# エントリポイント
ENTRYPOINT ["claude"]
```

```bash
# docker run時にボリュームをマウント
docker run -v /host/tmp:/app/tmp myimage
```

## 注意点・Tips

- **ディレクトリの事前作成**: `CLAUDE_CODE_TMPDIR` に指定したディレクトリは、Claude Codeを起動する前に作成しておく必要があります。存在しない場合、エラーになる可能性があります。
- **書き込み権限の確保**: 指定したディレクトリに対して、実行ユーザーが読み書き権限を持っていることを確認してください。
- **パスの指定**: 絶対パスで指定することを推奨します。相対パスを使用すると、作業ディレクトリによって挙動が変わる可能性があります。
- **ディスク容量の監視**: 一時ファイルが蓄積してディスクを圧迫することを避けるため、定期的にクリーンアップする仕組みを検討してください。
- **クロスプラットフォーム対応**: Windowsではパスの区切り文字が `\` ですが、多くの場合 `/` も使用できます。環境に応じて適切な形式を選択してください。
- **他の環境変数との関係**: この環境変数は、システムのデフォルト一時ディレクトリ（`TMPDIR`、`TEMP`、`TMP` など）とは独立して動作します。Claude Code固有の設定です。
- **デバッグ時の活用**: トラブルシューティング時に、一時ファイルを確認しやすい場所に設定することで、問題の特定が容易になります。

## 関連情報

- [Claude Code 公式ドキュメント](https://claude.ai/code)
- [Changelog v2.1.5](https://github.com/anthropics/claude-code/releases/tag/v2.1.5)
- [環境変数に関する他の記事](https://github.com/daikin555/claude-library/tree/main/docs/updates)
