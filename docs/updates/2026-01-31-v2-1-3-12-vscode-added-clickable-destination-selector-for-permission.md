---
title: "[VSCode] パーミッション設定の保存先選択機能"
date: 2026-01-09
tags: ['VSCode', 'パーミッション', '新機能', 'UI', 'チーム開発']
---

## 原文（日本語に翻訳）

[VSCode] パーミッションリクエストに対してクリック可能な保存先セレクターを追加し、設定の保存先（このプロジェクト、全プロジェクト、チームと共有、セッションのみ）を選択できるようにしました

## 原文（英語）

[VSCode] Added clickable destination selector for permission requests, allowing you to choose where settings are saved (this project, all projects, shared with team, or session only)

## 概要

Claude Code v2.1.3のVSCode拡張では、パーミッションを承認する際に、その設定をどこに保存するかを選択できるようになりました。プロジェクト固有、すべてのプロジェクト、チーム共有、またはセッションのみ（一時的）の4つのオプションから選択でき、より柔軟なパーミッション管理が可能になります。

## 基本的な使い方

パーミッションリクエストが表示されたときに、保存先を選択できます。

```bash
# Claude Codeがツール使用の許可を求める場合
# 例：Bashコマンドの実行許可

# VSCodeに表示される選択肢：
# 📁 This project only（このプロジェクトのみ）
# 🌐 All projects（すべてのプロジェクト）
# 👥 Shared with team（チームと共有）
# ⏱️ Session only（このセッションのみ）
```

## 実践例

### 保存先の選択肢

それぞれの保存先の特徴と使い分けです。

```bash
# 1. このプロジェクトのみ（This project only）
# 用途：プロジェクト固有の設定
# 保存先：.claude/settings.json（プロジェクトディレクトリ）
# 例：特定のプロジェクトでのみ npm install を許可

# 2. すべてのプロジェクト（All projects）
# 用途：グローバルな設定
# 保存先：~/.claude/settings.json（ホームディレクトリ）
# 例：すべてのプロジェクトで git status を許可

# 3. チームと共有（Shared with team）
# 用途：チーム全体で使う設定
# 保存先：.claude/settings.json（バージョン管理に含まれる）
# 例：チーム標準のlintコマンドを許可

# 4. セッションのみ（Session only）
# 用途：一時的な許可
# 保存先：保存されない（VSCodeを再起動すると消える）
# 例：実験的なコマンドを一度だけ試す
```

### プロジェクト固有の設定

特定のプロジェクトでのみ許可したいコマンドの場合です。

```bash
# シナリオ：特定のプロジェクトでのみnpm scriptを許可
#
# パーミッションリクエスト：
# "Allow Bash command: npm run deploy"
#
# 選択：📁 This project only
#
# 結果：
# - .claude/settings.json に保存される
# - 他のプロジェクトでは影響を受けない
# - プロジェクトチームで共有可能（.gitignoreで除外しない場合）
```

### グローバル設定

すべてのプロジェクトで共通して使うコマンドの場合です。

```bash
# シナリオ：すべてのプロジェクトでgitコマンドを許可
#
# パーミッションリクエスト：
# "Allow Bash command: git status"
#
# 選択：🌐 All projects
#
# 結果：
# - ~/.claude/settings.json に保存される
# - すべてのプロジェクトで有効
# - 個人的な設定として保持される
```

### チーム共有設定

チーム全体で統一したい設定の場合です。

```bash
# シナリオ：チーム標準のテストコマンドを許可
#
# パーミッションリクエスト：
# "Allow Bash command: npm test"
#
# 選択：👥 Shared with team
#
# 結果：
# - .claude/settings.json に保存される
# - Gitでコミット・プッシュされる
# - チームメンバー全員が同じ設定を共有
# - 新しいメンバーも自動的に同じ許可設定を使える
```

### 一時的な許可

一度だけ試したいコマンドの場合です。

```bash
# シナリオ：実験的なスクリプトを一度だけ実行
#
# パーミッションリクエスト：
# "Allow Bash command: ./experimental-script.sh"
#
# 選択：⏱️ Session only
#
# 結果：
# - 設定ファイルには保存されない
# - 現在のセッション中のみ有効
# - VSCodeを再起動すると許可がリセットされる
# - 危険な可能性のあるコマンドを試す際に安全
```

### チーム開発でのベストプラクティス

チーム全体での設定管理の例です。

```bash
# プロジェクトのセットアップ手順
#
# 1. 開発環境のセットアップコマンド
#    → 👥 Shared with team
#    npm install, npm run setup など
#
# 2. テスト・ビルドコマンド
#    → 👥 Shared with team
#    npm test, npm run build など
#
# 3. 個人的な設定
#    → 🌐 All projects または 📁 This project only
#    エディタ設定、個人用スクリプトなど
#
# 4. 一時的な調査コマンド
#    → ⏱️ Session only
#    デバッグコマンド、実験的なツール
```

### 保存先の切り替え

既存の設定を別の保存先に移動する場合です。

```bash
# 例：個人設定をチーム共有に変更
#
# 1. 現在の設定を確認
#    ~/.claude/settings.json（個人設定）
#
# 2. 新しいパーミッションリクエストで再承認
#    「👥 Shared with team」を選択
#
# 3. .claude/settings.json に保存される
#    チーム全体で共有可能
```

## 注意点

- この機能はVSCode拡張版のみで利用可能です（CLIでは異なる動作）
- 「チームと共有」を選択した場合、`.claude/settings.json`をGitにコミットする必要があります
- セキュリティ上重要な設定は、チーム共有を慎重に検討してください
- 「セッションのみ」は一時的な許可のため、頻繁に使うコマンドには適していません
- プロジェクト固有とチーム共有の違いは、Gitでの管理方法（.gitignore）によって変わります
- 既存の設定がある場合、新しい選択が優先されます

## 関連情報

- [Claude Code 公式ドキュメント](https://claude.ai/code)
- [Changelog v2.1.3](https://github.com/anthropics/claude-code/releases/tag/v2.1.3)
- [VSCode拡張の使い方](https://github.com/anthropics/claude-code)
- [パーミッション管理ガイド](https://github.com/anthropics/claude-code)
- [チーム開発のベストプラクティス](https://github.com/anthropics/claude-code)
