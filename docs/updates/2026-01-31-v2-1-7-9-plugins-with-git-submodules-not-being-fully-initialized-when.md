---
title: "Gitサブモジュールを含むプラグインの初期化問題を修正"
date: 2026-01-14
tags: ['バグ修正', 'プラグイン', 'Git']
---

## 原文（日本語に翻訳）

インストール時にGitサブモジュールを含むプラグインが完全に初期化されない問題を修正しました。

## 原文（英語）

Fixed plugins with git submodules not being fully initialized when installed

## 概要

Claude Codeのプラグインシステムで、Gitサブモジュールを含むプラグインをインストールした際、サブモジュールが正しく初期化されず、プラグインが正常に動作しない問題が修正されました。v2.1.7以降、`git submodule update --init --recursive`が自動的に実行され、すべてのサブモジュールが適切に初期化されます。

## 問題の詳細

### 修正前の動作

プラグインをインストールする際、基本的な`git clone`のみが実行されていました：

```bash
git clone https://github.com/user/plugin-with-submodules.git
# サブモジュールは初期化されない
```

結果として、プラグインのディレクトリ構造：
```
plugin-with-submodules/
├── src/
├── lib/           # サブモジュールディレクトリ（空）
│   └── dependency/  # 内容がダウンロードされていない
└── package.json
```

プラグイン実行時にエラー：
```
Error: Cannot find module './lib/dependency'
Plugin failed to load
```

### 修正後の動作

v2.1.7以降、以下が自動的に実行されます：

```bash
git clone https://github.com/user/plugin-with-submodules.git
cd plugin-with-submodules
git submodule update --init --recursive
```

すべてのサブモジュールが正しくダウンロードされ、プラグインが正常に動作します。

## 実践例

### サブモジュールを含むプラグインのインストール

多くの高度なプラグインは、共有ライブラリやヘルパーモジュールをGitサブモジュールとして管理しています。

**修正前:**
```bash
$ claude plugin install user/advanced-plugin

Installing advanced-plugin...
✓ Cloned repository
❌ Error: Plugin failed to load
   Missing dependencies in lib/
```

**修正後（v2.1.7）:**
```bash
$ claude plugin install user/advanced-plugin

Installing advanced-plugin...
✓ Cloned repository
✓ Initialized 3 submodules
✓ Plugin loaded successfully
```

### 複数階層のサブモジュール

サブモジュールがさらにサブモジュールを含む場合。

```
plugin/
├── core/ (サブモジュール)
│   └── utils/ (ネストされたサブモジュール)
└── themes/ (サブモジュール)
```

**修正前:** coreはダウンロードされるが、core/utilsは空のまま
**修正後:** `--recursive`フラグにより、すべての階層が初期化される

### 実際のプラグイン例

```bash
# MCP serverプラグインをインストール
$ claude plugin install anthropics/mcp-server-example

# サブモジュールを含むテーマプラグイン
$ claude plugin install user/custom-theme

# 複雑な依存関係を持つツールプラグイン
$ claude plugin install user/advanced-tools
```

すべて正しく動作するようになります。

## 技術的な改善点

- **完全な初期化**: `--init`フラグでサブモジュールを初期化
- **再帰的処理**: `--recursive`フラグでネストされたサブモジュールにも対応
- **自動化**: ユーザーが手動でサブモジュールを初期化する必要がない
- **エラー削減**: プラグイン読み込みエラーが大幅に減少

## 注意点

- **ネットワーク使用量**: サブモジュールが多い場合、ダウンロード時間が長くなる可能性があります
- **ディスク容量**: サブモジュールを含むプラグインは、より多くのディスク容量を使用します
- **プライベートリポジトリ**: サブモジュールがプライベートリポジトリの場合、適切な認証情報が必要です
- **既存のプラグイン**: v2.1.7以前にインストールしたプラグインは、再インストールが必要な場合があります

## プラグイン開発者向け

プラグインにサブモジュールを使用する場合のベストプラクティス：

### .gitmodulesファイルの例

```ini
[submodule "lib/core"]
    path = lib/core
    url = https://github.com/org/core-library.git
[submodule "themes/default"]
    path = themes/default
    url = https://github.com/org/default-theme.git
```

### 推奨事項

- サブモジュールのURLは公開リポジトリを使用する（またはドキュメントに認証手順を記載）
- サブモジュールの特定のコミット/タグを指定して、バージョンを固定する
- READMEにサブモジュールの存在を明記する

## 既存プラグインの修正方法

v2.1.7以前にインストールしたプラグインでサブモジュールの問題が発生している場合：

```bash
# プラグインを再インストール
$ claude plugin uninstall plugin-name
$ claude plugin install plugin-name

# または手動で修正
$ cd ~/.claude/plugins/plugin-name
$ git submodule update --init --recursive
```

## 関連情報

- [Claude Code プラグインシステム](https://code.claude.com/docs/)
- [Git Submodulesの使い方](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
- [Changelog v2.1.7](https://github.com/anthropics/claude-code/releases/tag/v2.1.7)
