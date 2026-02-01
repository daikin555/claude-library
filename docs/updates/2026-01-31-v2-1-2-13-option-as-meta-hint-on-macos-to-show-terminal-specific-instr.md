---
title: "macOSでのOption-as-Metaヒント表示をターミナル別に最適化"
date: 2026-01-09
tags: ['改善', 'macOS', 'UI', 'iTerm2', 'Kitty', 'WezTerm']
---

## 原文（日本語に翻訳）

macOSでのOption-as-Metaのヒント表示を改善し、iTerm2、Kitty、WezTermなどのネイティブCSIu対応ターミナル向けに、ターミナル固有の設定手順を表示するようにしました。

## 原文（英語）

Improved Option-as-Meta hint on macOS to show terminal-specific instructions for native CSIu terminals like iTerm2, Kitty, and WezTerm

## 概要

macOSでClaude Codeを使用する際、Optionキーをメタキーとして使用するための設定ヒントが、使用しているターミナルの種類（iTerm2、Kitty、WezTermなど）を自動検出し、そのターミナルに最適な設定手順を表示するようになりました。これにより、ユーザーは迷うことなく正しい設定ができます。

## 基本的な使い方

Claude Code起動時、必要に応じてターミナル固有の設定ヒントが自動的に表示されます。

### 自動検出と表示

```bash
# iTerm2でClaude Codeを起動
claude

# iTerm2固有のヒントが表示される:
# "For better keyboard support in iTerm2:
#  Preferences > Profiles > Keys > General >
#  Set 'Left Option key' to 'Esc+'"
```

## 実践例

### iTerm2での設定

```bash
# Claude Code起動時のヒント:
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# iTerm2でOption-as-Metaを有効にする:
# 1. iTerm2 > Preferences (⌘,)
# 2. Profiles タブを選択
# 3. 使用中のプロファイルを選択
# 4. Keys サブタブを選択
# 5. General セクションで:
#    Left Option key: "Esc+" を選択
#    Right Option key: "Esc+" を選択
# 6. ターミナルを再起動
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# 設定後、Alt+矢印キーなどが正しく動作
```

### Kittyでの設定

```bash
# Kittyを検出した場合のヒント:
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# KittyでOption-as-Metaを有効にする:
# ~/.config/kitty/kitty.conf に以下を追加:
#
# macos_option_as_alt yes
#
# その後、Kittyを再起動してください
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# 設定ファイルを編集
vim ~/.config/kitty/kitty.conf

# 追加する内容:
macos_option_as_alt yes

# Kittyを再起動
```

### WezTermでの設定

```bash
# WezTerm固有のヒント:
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# WezTermでOption-as-Metaを有効にする:
# ~/.wezterm.lua に以下を追加:
#
# return {
#   send_composed_key_when_left_alt_is_pressed = false,
#   send_composed_key_when_right_alt_is_pressed = false,
# }
#
# WezTermを再起動してください
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# 設定ファイルを編集
vim ~/.wezterm.lua

# 追加する内容:
return {
  send_composed_key_when_left_alt_is_pressed = false,
  send_composed_key_when_right_alt_is_pressed = false,
}
```

### 標準Terminal.appでの表示

```bash
# macOS標準のTerminal.appの場合:
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Terminal.appでOption-as-Metaを有効にする:
# 1. Terminal > Preferences (⌘,)
# 2. Profiles タブを選択
# 3. 使用中のプロファイルを選択
# 4. Keyboard タブを選択
# 5. "Use Option as Meta key" にチェック
# 6. ターミナルウィンドウを再起動
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## 注意点

- **自動検出**: Claude Codeは使用中のターミナルを自動的に検出し、適切な手順を表示します
- **CSIu対応**: iTerm2、Kitty、WezTermはCSIu（extended keyboard protocol）をネイティブサポートしています
- **設定は一度だけ**: 設定は永続的なので、一度設定すれば毎回行う必要はありません
- **再起動が必要**: ほとんどの場合、設定変更後はターミナルの再起動が必要です
- **日本語入力**: Option-as-Metaを有効にすると、一部の日本語入力特殊文字（´、`など）が入力できなくなる場合があります

## 関連情報

- [Claude Code 公式ドキュメント](https://code.claude.com/docs/)
- [Changelog v2.1.2](https://github.com/anthropics/claude-code/releases/tag/v2.1.2)
- [iTerm2 ドキュメント](https://iterm2.com/documentation.html)
- [Kitty ドキュメント](https://sw.kovidgoyal.net/kitty/)
- [WezTerm ドキュメント](https://wezfurlong.org/wezterm/)
