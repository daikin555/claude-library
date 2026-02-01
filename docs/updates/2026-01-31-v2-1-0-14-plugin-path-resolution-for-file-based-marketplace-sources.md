---
title: "ファイルベースマーケットプレースのプラグインパス解決を修正"
date: 2026-01-31
tags: ['バグ修正', 'プラグイン', 'マーケットプレース']
---

## 原文（日本語に翻訳）

ファイルベースマーケットプレースソースのプラグインパス解決を修正しました

## 原文（英語）

Fixed plugin path resolution for file-based marketplace sources

## 概要

Claude Code v2.1.0で修正された、プラグインマーケットプレースのパス解決バグです。以前のバージョンでは、marketplace.jsonファイルパス全体（ファイル名を含む）をベースディレクトリとして使用していたため、プラグインインストールパスが不正になり、「Plugin directory not found」エラーが発生していました。この修正により、marketplace.jsonの親ディレクトリを正しくベースパスとして使用するようになりました。

## 修正前の問題

```bash
# プラグインをインストール
claude plugin install my-plugin

# エラー: Plugin directory not found
# 原因: installed_plugins.jsonに不正なパスが記録される
# /path/to/marketplace.json/plugins/my-plugin
#                          ^^^ ファイル名がディレクトリとして扱われる
```

### 不正なパス構造

```json
// installed_plugins.json（修正前）
{
  "my-plugin": {
    "source": "file",
    "path": "/path/to/marketplace.json/plugins/my-plugin"
  }
}
```

`marketplace.json` はファイルなので、ディレクトリとして扱うとエラーになります。

## 修正後の動作

```bash
# プラグインをインストール
claude plugin install my-plugin

# ✓ 成功: 正しいパスが使用される
# /path/to/plugins/my-plugin
```

### 正しいパス構造

```json
// installed_plugins.json（修正後）
{
  "my-plugin": {
    "source": "file",
    "path": "/path/to/plugins/my-plugin"
  }
}
```

## 実践例

### ローカルマーケットプレースの使用

```bash
# プロジェクト構造
myproject/
├── .claude-marketplace/
│   ├── marketplace.json
│   └── plugins/
│       ├── linter/
│       └── formatter/

# marketplace.jsonの場所
/path/to/myproject/.claude-marketplace/marketplace.json

# プラグインをインストール
claude plugin install linter

# 修正後: 正しいパス解決
# /path/to/myproject/.claude-marketplace/plugins/linter
```

### チームマーケットプレースの共有

```bash
# チーム共有マーケットプレース
/team/shared/claude-plugins/
├── marketplace.json
└── plugins/
    ├── code-review/
    ├── deploy/
    └── test-runner/

# インストール
claude plugin install code-review

# ✓ 正しく解決: /team/shared/claude-plugins/plugins/code-review
```

### 複数マーケットプレースの管理

```bash
# マーケットプレース1
~/personal-plugins/marketplace.json

# マーケットプレース2
~/work-plugins/marketplace.json

# どちらからインストールしても、
# パスが正しく解決されるようになった
```

## 注意点

- この修正は Claude Code v2.1.0（2026年1月7日リリース）で実装されました
- 修正前のバージョンでインストールしたプラグインは、再インストールが必要な場合があります
- ファイルベースマーケットプレースの構造:
  ```
  marketplace-dir/
  ├── marketplace.json
  └── plugins/
      ├── plugin1/
      └── plugin2/
  ```
- プラグインは`marketplace.json`の親ディレクトリからの相対パスで解決されます
- 共有ファイルの扱い:
  - プラグイン外のファイル参照（`../shared-utils`など）は機能しません
  - プラグインディレクトリのみがキャッシュにコピーされます
  - 共有が必要な場合は、シンボリックリンクを使用するか、プラグインソースパス内に配置してください
- GitHub Issue #11278で報告され、v2.1.0で修正されました

## 関連情報

- [Create and distribute a plugin marketplace](https://code.claude.com/docs/en/plugin-marketplaces)
- [GitHub Issue #11278: Plugin path resolution bug](https://github.com/anthropics/claude-code/issues/11278)
- [Official Claude Plugins](https://github.com/anthropics/claude-plugins-official)
