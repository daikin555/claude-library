---
title: "Windows: .bashrcファイルがあるユーザーのBashコマンド実行失敗を修正"
date: 2025-01-27
tags: [bugfix, windows, bash]
---

## 原文（日本語訳）

Windows: `.bashrc` ファイルを持つユーザーでBashコマンドの実行が失敗する問題を修正

## 原文（英語）

Windows: Fixed bash command execution failing for users with `.bashrc` files

## 概要

Windows版のClaude Codeで、ホームディレクトリに `.bashrc` ファイルが存在する場合にBashコマンドの実行が失敗する問題が修正されました。これにより、Git Bashなどのカスタマイズされたシェル環境でも正常に動作するようになります。

## 基本的な使い方

修正後は、`.bashrc` があっても特別な設定なしで動作します。

```bash
# Windows上でClaude Codeを起動
claude

# Bashコマンドが正常に実行される
> "Run npm install"
> "Run git status"
```

## 実践例

### Git Bash環境での開発

Git Bashでカスタマイズした環境設定がある場合でも、問題なく動作します。

```powershell
# .bashrcにエイリアスや環境変数を設定している場合
# C:\Users\YourName\.bashrc
# export PATH="$PATH:/custom/path"
# alias ll='ls -la'

# Claude Codeでコマンドを実行
> "Run ll command to list files"
# エイリアスが正しく認識される
```

### Node.js開発環境での利用

nvmやnvm-windowsで複数のNode.jsバージョンを管理している場合。

```bash
# .bashrcでnvmを初期化している場合
# source ~/.nvm/nvm.sh

# Claude CodeでNode.jsコマンドが実行できる
> "Check Node.js version and install dependencies"
# npmコマンドが正常に動作
```

### Python開発環境での利用

`.bashrc` でPython仮想環境を自動アクティベートしている場合。

```bash
# .bashrcの設定例
# source ~/venv/bin/activate

# Claude CodeでPythonコマンドを実行
> "Run pytest tests/"
# 仮想環境が正しく認識される
```

### カスタムプロンプト設定の保持

`.bashrc` でPS1などのプロンプトをカスタマイズしている場合も影響なし。

```bash
# .bashrcでプロンプトをカスタマイズ
# export PS1="\[\e[32m\]\u@\h:\w\$ \[\e[0m\]"

# Claude Codeは影響を受けずに動作
# Bashツールが正常にコマンドを実行
```

## 注意点

- この修正はWindows版のClaude Codeにのみ適用されます
- Git for Windowsがインストールされている必要があります
- `.bashrc` の内容によっては、起動時間が若干長くなる可能性があります
- 無限ループを含む `.bashrc` は避けてください

## 関連情報

- [Windows版Claude Code インストールガイド](https://code.claude.com/docs/en/getting-started#windows)
- [Bashツールの使い方](https://code.claude.com/docs/en/tools#bash)
- [シェル環境のカスタマイズ](https://code.claude.com/docs/en/shell-configuration)
- [トラブルシューティング](https://code.claude.com/docs/en/troubleshooting#windows)
