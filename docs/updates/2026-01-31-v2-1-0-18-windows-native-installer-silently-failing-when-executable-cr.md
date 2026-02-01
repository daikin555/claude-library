---
title: "実行可能ファイル作成失敗時のWindowsインストーラー無言失敗を修正"
date: 2026-01-31
tags: ['バグ修正', 'Windows', 'インストール']
---

## 原文（日本語に翻訳）

実行可能ファイルの作成に失敗した際にWindowsネイティブインストーラーが無言で失敗する問題を修正しました

## 原文（英語）

Fixed Windows native installer silently failing when executable creation fails

## 概要

Claude Code v2.1.0で修正された、Windowsインストーラーのエラーハンドリングバグです。以前のバージョンでは、実行可能ファイルの作成に失敗してもエラーメッセージが表示されず、インストールが失敗したことに気付きにくい問題がありました。この修正により、インストール失敗時に適切なエラーメッセージが表示され、問題の診断と解決が容易になりました。

## 修正前の問題

```powershell
# Windowsでインストール実行
npm install -g @anthropic-ai/claude-code

# パーミッションエラーやパス問題で実行可能ファイル作成失敗
# しかし、エラーメッセージなし

# インストール完了と表示されるが...
claude --version

# エラー: 'claude' is not recognized as an internal or external command
# 実際にはインストール失敗していた
```

### 無言で失敗する原因

- 管理者権限不足
- パスの長さ制限
- ファイルシステムのパーミッション問題
- ウイルス対策ソフトによるブロック

## 修正後の動作

```powershell
# インストール実行
npm install -g @anthropic-ai/claude-code

# 実行可能ファイル作成失敗時
# ✓ 明確なエラーメッセージを表示:
# Error: Failed to create executable at C:\Users\...\claude.exe
# Reason: Permission denied
# Solution: Try running as Administrator

# または
# Error: Failed to create executable
# Reason: Path too long (exceeded 260 character limit)
# Solution: Install to a shorter path using --prefix
```

## 実践例

### 管理者権限不足の診断

```powershell
# 通常ユーザーでインストール
npm install -g @anthropic-ai/claude-code

# 修正前: 無言で失敗
# 修正後: エラーメッセージ表示
# Error: Permission denied when creating claude.exe
# Solution: Run PowerShell as Administrator
```

### パス長制限の診断

```powershell
# 深いディレクトリ構造でインストール
npm install -g @anthropic-ai/claude-code

# 修正後: エラーメッセージ表示
# Error: Path too long
# Current path: C:\Users\VeryLongUserName\AppData\Roaming\npm\node_modules\...
# Solution: Use --prefix to install to a shorter path
```

### ウイルス対策ソフトブロックの診断

```powershell
# ウイルス対策ソフトが実行可能ファイル作成をブロック
npm install -g @anthropic-ai/claude-code

# 修正後: エラーメッセージ表示
# Error: Failed to create executable
# Reason: Access denied (possible antivirus block)
# Solution: Temporarily disable antivirus or add exception
```

## トラブルシューティング

### 管理者権限で実行

```powershell
# PowerShellを管理者として起動
# 右クリック → "管理者として実行"

npm install -g @anthropic-ai/claude-code
```

### 短いパスにインストール

```powershell
# カスタムプレフィックスを指定
npm install -g @anthropic-ai/claude-code --prefix C:\claude
```

### Git Bash経由でインストール（推奨）

```bash
# Git Bashを使用（推奨方法）
npm install -g @anthropic-ai/claude-code
```

## 注意点

- この修正は Claude Code v2.1.0（2026年1月7日リリース）で実装されました
- Windows固有の問題に対応しました
- エラーメッセージには以下が含まれます:
  - 失敗したファイルのパス
  - 失敗の理由
  - 推奨される解決策
- Windowsでの推奨インストール方法:
  1. **Git Bash経由**（最も推奨）
  2. PowerShell（管理者として実行）
  3. WSL（Windows Subsystem for Linux）
- Windows特有の問題:
  - パスの長さ制限（260文字）
  - 管理者権限の要件
  - ウイルス対策ソフトの干渉
  - ファイルロック
- トラブルシューティングコマンド:
  ```powershell
  # インストールパスを確認
  npm config get prefix

  # グローバルパッケージ一覧を確認
  npm list -g --depth=0
  ```

## 関連情報

- [Set up Claude Code - Official Docs](https://code.claude.com/docs/en/setup)
- [Claude Code Windows Native Installation](https://smartscope.blog/en/generative-ai/claude/claude-code-windows-native-installation/)
- [How to install Claude Code on Windows](https://claudelog.com/faqs/how-to-install-claude-code-on-windows/)
