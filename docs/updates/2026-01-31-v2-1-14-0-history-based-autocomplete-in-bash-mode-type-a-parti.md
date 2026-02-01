---
title: "Bashモードに履歴ベースのオートコンプリート機能を追加"
date: 2026-01-20
tags: ['新機能', 'bash', 'オートコンプリート', 'CLI']
---

## 原文（日本語に翻訳）

Bashモード（`!`）に履歴ベースのオートコンプリート機能を追加 - コマンドの一部を入力してTabキーを押すと、Bashコマンド履歴から補完できるようになりました

## 原文（英語）

Added history-based autocomplete in bash mode (`!`) - type a partial command and press Tab to complete from your bash command history

## 概要

Claude Code v2.1.14では、Bashモード（`!`プレフィックス）に履歴ベースのオートコンプリート機能が追加されました。これにより、過去に実行したコマンドの一部を入力してTabキーを押すだけで、プロジェクトのBashコマンド履歴から自動補完できるようになります。頻繁に使用する長いコマンドを何度も入力する手間が省け、開発効率が大幅に向上します。

## 基本的な使い方

Bashモードで履歴オートコンプリートを使用するには：

1. Claude Code セッション内で `!` プレフィックスを使ってコマンドを入力
2. コマンドの最初の数文字を入力（例：`! npm`）
3. **Tabキー**を押す
4. 過去に実行したコマンド履歴から一致するコマンドが表示される
5. 表示されたコマンドを選択して実行

```bash
# 例: 過去に「npm run build:production」を実行したことがある場合
! npm ru<Tab>
# → "npm run build:production" が補完候補として表示される
```

## 実践例

### 長いテストコマンドの再実行

プロジェクトで複雑なテストコマンドを頻繁に実行する場合：

```bash
# 過去に実行したコマンド
! npm test -- --coverage --watchAll=false --verbose

# 次回以降は数文字入力してTabで補完
! npm te<Tab>
# → 履歴から「npm test -- --coverage --watchAll=false --verbose」が補完される
```

### Dockerコマンドの効率化

長いDockerコマンドも履歴から素早く呼び出せます：

```bash
# 初回実行
! docker run -it --rm -v $(pwd):/app -p 3000:3000 myapp:latest

# 2回目以降
! docker r<Tab>
# → 履歴から補完されるため、毎回フルコマンドを入力する必要がない
```

### Git操作の高速化

複雑なGitコマンドも履歴から簡単に再実行：

```bash
# 過去のコマンド
! git log --graph --pretty=format:'%h - %s (%an, %ar)'

# 再実行時
! git lo<Tab>
# → 履歴から該当コマンドが補完される
```

### ビルドスクリプトの再実行

プロジェクト固有のビルドコマンドを簡単に再実行：

```bash
# カスタムビルドコマンド
! ./scripts/build.sh --env production --optimize

# 次回
! ./scr<Tab>
# → 履歴から補完
```

## 注意点

- **履歴はプロジェクトごとに管理**：コマンド履歴は作業ディレクトリごとに保存されるため、プロジェクトAで実行したコマンドはプロジェクトBの履歴には表示されません
- **Bashモード（`!`）専用**：この機能はBashモードでのみ動作します。通常の会話モードでは使用できません
- **履歴のクリア**：`/clear`コマンドを実行すると、セッションの履歴もクリアされます
- **Tabキーで補完**：補完を呼び出すにはTabキーを使用します。Enterキーではありません
- **`Ctrl+R`との違い**：従来の`Ctrl+R`による逆順検索も引き続き使用可能です。Tabによる補完は、より直感的に履歴にアクセスできる追加の方法です

## 関連情報

- [Claude Code インタラクティブモード - Bashモード](https://code.claude.com/docs/en/interactive-mode#bash-mode-with--prefix)
- [Claude Code インタラクティブモード - コマンド履歴](https://code.claude.com/docs/en/interactive-mode#command-history)
- [Claude Code CLIリファレンス](https://code.claude.com/docs/en/cli-reference)
- [Changelog v2.1.14](https://github.com/anthropics/claude-code/releases/tag/v2.1.14)
