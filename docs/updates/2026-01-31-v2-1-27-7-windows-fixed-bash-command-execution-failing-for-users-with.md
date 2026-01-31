---
title: "Windows：.bashrcファイルを持つユーザーでbashコマンド実行が失敗する問題を修正"
date: 2026-01-30
tags: ['バグ修正', 'Windows', 'Git Bash', '.bashrc']
---

## 原文（日本語に翻訳）

Windows: `.bashrc`ファイルを持つユーザーでbashコマンド実行が失敗する問題を修正

## 原文（英語）

Windows: Fixed bash command execution failing for users with `.bashrc` files

## 概要

Windows環境でGit Bashを使用し、`.bashrc`ファイルでカスタム設定を行っているユーザーがClaude Codeでbashコマンドを実行できない問題が修正されました。これにより、エイリアスや環境変数などの個人設定を持つユーザーでも、正常にClaude Codeを使用できるようになります。

## 問題の背景

v2.1.27以前、以下のような問題が発生していました：

- `.bashrc`ファイルでカスタム設定を行っているユーザーでbashコマンドが失敗
- エイリアスやPATH設定が読み込まれない
- 特定のツール（pnpm, npmなど）のラッパースクリプトが動作しない
- コマンドが正常に実行されても出力が取得できない（"(No content)"と表示される）

これらの問題は、Claude CodeがGit Bashを起動する際に`.bashrc`を適切に読み込まない、または読み込んだ設定が原因でプロセスが正しく動作しないことが原因でした。

## 修正内容

v2.1.27での改善点：

- `.bashrc`ファイルの適切な読み込み処理
- ユーザーのシェル環境設定との互換性向上
- ラッパースクリプト（exec使用）からの出力キャプチャ改善
- Git Bashパスの検出ロジック改善

## 実践例

### .bashrcでのカスタムエイリアス使用

```bash
# ~/.bashrc
alias ll='ls -alh'
alias gs='git status'
export PATH="$HOME/.local/bin:$PATH"
```

v2.1.27以降、これらの設定を持つユーザーでもClaude Codeが正常に動作します。

### pnpm/npmラッパースクリプトの実行

```bash
# Claude Codeからpnpmコマンドを実行
claude "pnpmでパッケージをインストール"
# → pnpm install が正常に実行される
```

以前は"(No content)"と表示されていたコマンドも、正しく出力が表示されます。

### カスタムPATH設定の活用

```bash
# ~/.bashrc
export PATH="/c/custom/tools:$PATH"
export NODE_ENV=development
```

Claude Codeは`.bashrc`で設定されたPATHを認識し、カスタムツールも実行できます。

### 開発ツールの設定読み込み

```bash
# ~/.bashrc
# Node.js version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Python virtual environment
source ~/venvs/myproject/bin/activate
```

これらの設定も正しく読み込まれます。

## トラブルシューティング

もしまだ問題が発生する場合：

1. **Git Bashパスの明示的設定：**
   ```powershell
   # PowerShellで環境変数を設定
   $env:CLAUDE_CODE_GIT_BASH_PATH="C:\Program Files\Git\bin\bash.exe"
   ```

   または、システム環境変数として恒久的に設定：
   ```
   CLAUDE_CODE_GIT_BASH_PATH=C:\Program Files\Git\bin\bash.exe
   ```

2. **.bashrcの確認：**
   ```bash
   # .bashrcにエラーがないか確認
   bash -c "source ~/.bashrc && echo 'OK'"
   ```

3. **Claude Codeの診断：**
   ```bash
   claude doctor
   ```

4. **デバッグモードでの実行：**
   ```bash
   claude --debug
   ```

## Windows環境での推奨設定

### Git for Windowsのインストール確認

```powershell
# Git Bashがインストールされているか確認
where.exe bash.exe
# 期待される出力: C:\Program Files\Git\bin\bash.exe
```

### .bashrcの推奨設定

```bash
# ~/.bashrc
# Claude Code との互換性を保つための設定

# エラーで停止しない（デバッグ用）
set +e

# エイリアス設定
alias ll='ls -alh'

# PATH設定（Windowsパスとの共存）
export PATH="$HOME/.local/bin:$PATH"

# Node.js設定
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
```

## 注意点

- Git for Windowsがインストールされている必要があります
- 非標準のパスにGit Bashをインストールしている場合は、環境変数`CLAUDE_CODE_GIT_BASH_PATH`で指定してください
- `.bashrc`内で対話的なプロンプトを使用している場合、Claude Codeの実行に影響を与える可能性があります
- 複雑なシェルスクリプトや特殊な設定は、WSL環境での使用を推奨します
- Windows PowerShellネイティブ環境では、`.bashrc`は使用されません

## WSLとの比較

Windows上でClaude Codeを使用する選択肢：

1. **Git Bash（ネイティブWindows）：**
   - 軽量で起動が速い
   - .bashrcサポート（v2.1.27以降）
   - Windows アプリケーションとの統合が容易

2. **WSL（Windows Subsystem for Linux）：**
   - 完全なLinux環境
   - より高度なシェル機能
   - ファイルシステムパフォーマンスに注意

## 関連Issue

この修正により解決されたIssue：

- [Bash command failing with no output when run from claude](https://github.com/anthropics/claude-code/issues/21143)
- [Bash tool produces no output on Windows](https://github.com/anthropics/claude-code/issues/21915)
- [Bash output shows "(No content)" on Windows native](https://github.com/anthropics/claude-code/issues/18856)

## 関連情報

- [Troubleshooting - Claude Code Docs](https://code.claude.com/docs/en/troubleshooting)
- [Windows installation issues - Claude Code Docs](https://code.claude.com/docs/en/troubleshooting#windows-installation-issues-errors-in-wsl)
- [Changelog v2.1.27](https://github.com/anthropics/claude-code/releases/tag/v2.1.27)
