---
title: "アカウント情報を隠すCLAUDE_CODE_HIDE_ACCOUNT_INFO環境変数を追加"
date: 2026-01-31
tags: ['新機能', 'プライバシー', 'デモ']
---

## 原文（日本語に翻訳）

**注**: changelogには`IS_DEMO`と記載されていますが、実際の環境変数名は`CLAUDE_CODE_HIDE_ACCOUNT_INFO`です。

UIからメールアドレスと組織名を非表示にする環境変数を追加しました。ストリーミングや録画セッションに便利です。

## 原文（英語）

Added `IS_DEMO` environment variable to hide email and organization from the UI, useful for streaming or recording sessions

## 概要

Claude Code v2.1.0で導入された、アカウント情報非表示機能です。環境変数 `CLAUDE_CODE_HIDE_ACCOUNT_INFO=1` を設定することで、Claude Code UIに表示されるメールアドレスと組織名を非表示にできます。デモ、ストリーミング配信、スクリーンレコーディング、教育コンテンツ作成など、個人情報を公開したくない場合に有用です。

## 基本的な使い方

環境変数 `CLAUDE_CODE_HIDE_ACCOUNT_INFO=1` を設定してClaude Codeを起動します。

```bash
# 一時的に非表示にする
CLAUDE_CODE_HIDE_ACCOUNT_INFO=1 claude

# または.bashrc/.zshrcに追加して常に非表示
export CLAUDE_CODE_HIDE_ACCOUNT_INFO=1
```

この設定により、UIの起動時とセッション中に表示されるメールアドレスと組織名が非表示になります。

## 実践例

### ライブコーディング配信での使用

YouTubeやTwitchでのライブコーディング配信時にプライバシーを保護します。

```bash
# 配信用シェルスクリプト
#!/bin/bash
export CLAUDE_CODE_HIDE_ACCOUNT_INFO=1
claude
```

### スクリーンレコーディング

チュートリアルビデオや製品デモの録画時に使用します。

```bash
# 録画セッション開始前に設定
export CLAUDE_CODE_HIDE_ACCOUNT_INFO=1
# OBSなどの録画ソフトを起動
claude
```

### 教育・トレーニングセッション

ワークショップやトレーニングでスクリーンを共有する際に使用します。

```bash
# .zshrc または .bashrc に追加
# 常にアカウント情報を非表示にする場合
if [ -n "$PRESENTATION_MODE" ]; then
  export CLAUDE_CODE_HIDE_ACCOUNT_INFO=1
fi
```

### カンファレンスでのデモ

技術カンファレンスでのライブデモ時に使用します。

```bash
# デモ用の専用プロファイル
# ~/.bash_profile_demo
export CLAUDE_CODE_HIDE_ACCOUNT_INFO=1
export DEMO_MODE=1

# 使用時
source ~/.bash_profile_demo
claude
```

## 注意点

- この機能は Claude Code v2.1.0（2026年1月7日リリース）で導入されました
- **環境変数名の注意**: changelogには `IS_DEMO` と記載されていますが、実際の環境変数名は **`CLAUDE_CODE_HIDE_ACCOUNT_INFO`** です
- 値を `1` に設定することで機能が有効になります（`CLAUDE_CODE_HIDE_ACCOUNT_INFO=1`）
- **既知の問題**: 2026年1月時点で、Windows環境でこの環境変数が正しく機能しないバグが報告されています
  - アカウント情報（メールと組織名）が環境変数の設定に関わらず起動時に表示されてしまう
- macOSおよびLinuxでは正常に動作することが確認されています
- この設定はUIの表示のみに影響し、実際の認証や機能には影響しません
- セッション中にアカウント情報が必要になる操作（認証更新など）には影響しません

## 関連情報

- [How to Hide Org Name & Email in Claude Code](https://aiengineerguide.com/blog/hide-org-email-in-claude-code/)
- [GitHub Issue: CLAUDE_CODE_HIDE_ACCOUNT_INFO not working on Windows](https://github.com/anthropics/claude-code/issues/17573)
- [Claude Code Settings Documentation](https://code.claude.com/docs/en/settings)
