---
title: "`/sandbox`コマンドUIを改善し、依存関係ステータスとインストール手順を表示"
date: 2026-01-27
tags: ['UI改善', 'サンドボックス', '依存関係管理']
---

## 原文（日本語に翻訳）

依存関係が不足している場合にステータスとインストール手順を表示するよう、`/sandbox`コマンドのUIを改善

## 原文（英語）

Improved `/sandbox` command UI to show dependency status with installation instructions when dependencies are missing

## 概要

Claude Code v2.1.20では、`/sandbox`コマンドのユーザーインターフェースが大幅に改善されました。以前は、サンドボックス環境の依存関係（Docker、Podmanなど）が不足している場合、エラーメッセージが表示されるだけでした。この改善により、必要な依存関係のステータスが明確に表示され、不足している場合は具体的なインストール手順が提示されるようになります。

## 基本的な使い方

`/sandbox`コマンドを実行すると、依存関係のステータスが確認できます：

```bash
# サンドボックスステータスを確認
> /sandbox

# 依存関係が整っている場合：
✓ Docker is installed (version 24.0.7)
✓ Sandbox environment ready

# 依存関係が不足している場合（改善後）：
✗ Docker is not installed

To use sandbox mode, install Docker:

macOS:
  brew install --cask docker

Linux (Ubuntu/Debian):
  sudo apt-get update
  sudo apt-get install docker.io
  sudo usermod -aG docker $USER

Windows:
  Visit https://docs.docker.com/desktop/install/windows/

After installation, restart your terminal.
```

## 実践例

### 初めてサンドボックスを使用する場合

新規ユーザーがサンドボックス機能を試そうとする際：

```bash
> /sandbox

# 改善前の出力：
Error: Docker not found
Failed to initialize sandbox

# ユーザーは何をすべきか分からない

# 改善後の出力：
Sandbox Dependency Check:
  ✗ Docker: Not installed
  ✓ Network: Available

Required: Docker

Installation instructions for your system (macOS):
  1. Install Homebrew if not already installed:
     /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  2. Install Docker Desktop:
     brew install --cask docker

  3. Start Docker Desktop from Applications

  4. Verify installation:
     docker --version

# ユーザーは明確な手順を得て、すぐに対応可能
```

### 複数の依存関係オプション

Docker以外の選択肢も表示：

```bash
> /sandbox

Sandbox Dependency Check:
  ✗ Docker: Not installed
  ✗ Podman: Not installed

You can use either Docker or Podman for sandbox mode.

Option 1: Docker (Recommended)
  macOS: brew install --cask docker
  Linux: sudo apt-get install docker.io

Option 2: Podman (Lighter alternative)
  macOS: brew install podman
  Linux: sudo apt-get install podman

Choose based on your preference and system requirements.
```

### CI/CD環境での使用

自動化環境でのセットアップ確認：

```bash
# CI スクリプト内で
claude /sandbox

# 改善後の出力（CI環境用）：
Sandbox Dependency Check:
  ✓ Docker: Installed (v24.0.7)
  ✓ Docker daemon: Running
  ✓ Network access: Available
  ✓ Disk space: 50GB available

All sandbox dependencies satisfied.
Ready for automated testing.

# スクリプトは依存関係の詳細を確認でき、
# 不足があれば適切にエラーハンドリング可能
```

### バージョン互換性の確認

古いバージョンのDockerがインストールされている場合：

```bash
> /sandbox

Sandbox Dependency Check:
  ⚠ Docker: Installed (v19.03.0)
    WARNING: Minimum recommended version is 20.10.0

Sandbox will work but some features may be unavailable.

To upgrade Docker:
  macOS: brew upgrade docker
  Linux: Follow instructions at https://docs.docker.com/engine/install/

Current limitations with v19.03.0:
  - BuildKit features unavailable
  - Some networking modes not supported
```

### トラブルシューティング情報の表示

Docker がインストールされているが動作していない場合：

```bash
> /sandbox

Sandbox Dependency Check:
  ✓ Docker: Installed (v24.0.7)
  ✗ Docker daemon: Not running

Docker is installed but the daemon is not running.

To start Docker:
  macOS:
    - Open Docker Desktop from Applications
    - Or run: open -a Docker

  Linux:
    - systemctl: sudo systemctl start docker
    - Or service: sudo service docker start

  Check daemon status:
    docker info

# 改善により、問題の診断と解決策が明確に
```

## 注意点

- この改善は `/sandbox` コマンドの出力にのみ影響します
- インストール手順は、検出されたOSに基づいて自動的にカスタマイズされます
- すべての依存関係が満たされている場合、簡潔なステータス表示になります
- 複数の選択肢がある場合（DockerとPodman）、両方のインストール方法が表示されます
- CI/CD環境では、より詳細なステータス情報が提供されます

## 関連情報

- [Sandbox Mode](https://code.claude.com/docs/en/sandbox/overview)
- [Docker Installation](https://docs.docker.com/get-docker/)
- [Podman Installation](https://podman.io/getting-started/installation)
- [Troubleshooting Sandbox](https://code.claude.com/docs/en/sandbox/troubleshooting)
- [Changelog v2.1.20](https://github.com/anthropics/claude-code/releases/tag/v2.1.20)
