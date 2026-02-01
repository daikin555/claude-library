---
title: "Windows Package Manager (winget) でのインストールに対応"
date: 2026-01-09
tags: ['新機能', 'Windows', 'インストール', 'winget']
---

## 原文（日本語に翻訳）

Windows Package Manager (winget) を使用したインストールのサポートを追加し、自動検出とアップデート手順が利用可能になりました。

## 原文（英語）

Added support for Windows Package Manager (winget) installations with automatic detection and update instructions

## 概要

Windows 11やWindows 10の最新版に標準搭載されているパッケージマネージャー「winget」を使って、Claude Codeを簡単にインストールできるようになりました。また、winget経由でインストールされた場合の自動検出機能と、アップデート時の適切な手順案内も実装されています。

## 基本的な使い方

### インストール

PowerShellまたはコマンドプロンプトを開き、以下のコマンドを実行します。

```powershell
winget install anthropic.claude-code
```

### アップグレード

```powershell
winget upgrade anthropic.claude-code
```

### インストール方法の確認

Claude Code起動時、winget経由でインストールされたことを自動検出し、アップデート時には適切なwingetコマンドを案内します。

## 実践例

### 初回インストール

```powershell
# PowerShellを管理者権限で起動

# Claude Codeをインストール
winget install anthropic.claude-code

# インストール確認
claude --version
```

### 新バージョンへのアップグレード

```powershell
# アップデート可能なパッケージを確認
winget upgrade

# Claude Codeのみアップグレード
winget upgrade anthropic.claude-code

# または、全てのパッケージをアップグレード
winget upgrade --all
```

### 複数マシンへの一括セットアップ

```powershell
# setup.ps1
# 開発環境のセットアップスクリプト

$packages = @(
    "Git.Git",
    "Microsoft.VisualStudioCode",
    "OpenJS.NodeJS",
    "anthropic.claude-code"
)

foreach ($package in $packages) {
    Write-Host "Installing $package..."
    winget install $package --silent
}

Write-Host "開発環境のセットアップが完了しました"
```

### CI/CD環境での自動インストール

```yaml
# GitHub Actions の例
name: Setup Environment
on: [push]
jobs:
  build:
    runs-on: windows-latest
    steps:
      - name: Install Claude Code
        run: winget install anthropic.claude-code --silent

      - name: Verify installation
        run: claude --version
```

## 注意点

- **Windows 10/11が必要**: wingetはWindows 10 1809以降、またはWindows 11で利用可能です
- **App Installerが必要**: wingetを使用するには「アプリ インストーラー」がインストールされている必要があります（通常は標準でインストール済み）
- **自動検出機能**: Claude Codeはwinget経由でのインストールを自動的に検出し、アップデート時に適切なコマンドを提示します
- **管理者権限**: 初回インストール時は管理者権限が必要な場合があります
- **パスの自動設定**: winget経由でインストールすると、自動的にPATHが設定されます

## 関連情報

- [Claude Code 公式ドキュメント](https://code.claude.com/docs/)
- [Changelog v2.1.2](https://github.com/anthropics/claude-code/releases/tag/v2.1.2)
- [Windows Package Manager (winget) 公式ドキュメント](https://learn.microsoft.com/windows/package-manager/)
