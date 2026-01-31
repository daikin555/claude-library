---
title: "iTerm2/Ghostty/Kitty/WezTermでAlt+B/Alt+F単語ナビゲーションが動作しない問題を修正"
date: 2026-01-31
tags: ['バグ修正', 'キーボード', 'UX']
---

## 原文（日本語に翻訳）

iTerm2、Ghostty、Kitty、WezTermでAlt+BとAlt+F（単語ナビゲーション）が動作しない問題を修正しました

## 原文（英語）

Fixed Alt+B and Alt+F (word navigation) not working in iTerm2, Ghostty, Kitty, and WezTerm

## 概要

Claude Code v2.1.0で修正された、モダンターミナルでの単語移動キーバインドバグです。以前のバージョンでは、Emacsスタイルの単語ナビゲーション（`Alt+B` で前の単語へ、`Alt+F` で次の単語へ移動）が、iTerm2、Ghostty、Kitty、WezTermなどのターミナルエミュレータで動作しませんでした。この修正により、これらのターミナルでも標準的なEmacsキーバインドが使用できるようになり、長いコマンドやプロンプトの編集が効率化されます。

## 修正前の問題

### 症状

```bash
# iTerm2でClaude Code起動
claude

# 長いプロンプトを入力
> このファイルの中で authentication という単語を検索して

# カーソルを "authentication" に移動したい
# Alt+B を押す（前の単語に戻る）

# 修正前: 何も起こらない、または文字化け
# カーソルが動かない

# Alt+F を押す（次の単語に進む）
# 修正前: 何も起こらない
```

### 影響を受けるターミナル

- **iTerm2** (macOS)
- **Ghostty** (クロスプラットフォーム)
- **Kitty** (Linux/macOS)
- **WezTerm** (クロスプラットフォーム)

## 修正後の動作

### Emacsスタイル単語ナビゲーション

```bash
# Claude Code起動
claude

# 長いプロンプトを入力
> このファイルの中で authentication という単語を検索して
#                                         ↑ カーソル位置

# Alt+B: 前の単語に戻る
> このファイルの中で authentication という単語を検索して
#                  ↑ カーソルが "authentication" の先頭に移動

# Alt+B: さらに前へ
> このファイルの中で authentication という単語を検索して
#          ↑ カーソルが "中で" の先頭に移動

# Alt+F: 次の単語に進む
> このファイルの中で authentication という単語を検索して
#                                 ↑ カーソルが "という" の先頭に移動
```

## 実践例

### 長いプロンプトの素早い編集

複雑なリクエストを効率的に編集します。

```bash
> このプロジェクトの src/components ディレクトリにある React コンポーネントを分析して
#                                                            ↑ カーソル

# "React" を "Vue" に変更したい
# Alt+B で "React" に戻る
Alt+B  # → "コンポーネントを"
Alt+B  # → "React"

# 単語を削除して入力
Ctrl+W  # "React" を削除
Vue  # 入力

> このプロジェクトの src/components ディレクトリにある Vue コンポーネントを分析して
```

### パス編集の効率化

ファイルパスを素早く編集します。

```bash
> /Users/username/projects/myapp/src/utils/helper.js を読んで
#                                               ↑ カーソル

# "helper.js" を "validator.js" に変更したい
# Alt+B で戻る
Alt+B  # → "helper.js"

# 編集
Ctrl+W  # 削除
validator.js  # 入力
```

### コマンド修正の高速化

以前のコマンドを素早く修正します。

```bash
# ↑ キーで履歴を呼び出し
> この関数の performance を optimize して

# "performance" を "security" に変更
# Alt+B で "performance" に移動
Alt+B Alt+B  # 2回戻る

Ctrl+W  # 削除
security  # 入力

> この関数の security を optimize して
```

### 複数箇所の同時編集

長いテキストの複数箇所を効率的に編集します。

```bash
> src/components/Header.tsx と src/components/Footer.tsx を比較して
#                                               ↑ カーソル

# "Header" と "Footer" を両方変更したい
# Alt+B で最初の "Header" に戻る
Alt+B Alt+B Alt+B Alt+B  # 4回戻る

Ctrl+W  # "Header" 削除
Navigation  # 入力

# Alt+F で "Footer" に進む
Alt+F Alt+F Alt+F  # 3回進む

Ctrl+W  # "Footer" 削除
Sidebar  # 入力

> src/components/Navigation.tsx と src/components/Sidebar.tsx を比較して
```

## 注意点

- この修正は Claude Code v2.1.0（2026年1月7日リリース）で実装されました
- Emacsスタイルキーバインド:
  - `Alt+B` (または `Esc B`): 前の単語に移動（Backward）
  - `Alt+F` (または `Esc F`): 次の単語に移動（Forward）
  - Bashシェルと同じ動作
- macOSでのAltキー:
  - **iTerm2**: デフォルトでAltキーがEsc+として動作
  - **設定不要**: この修正により自動的に動作
  - オプション: iTerm2設定で "Use Option as Meta key" を有効化
- 単語の区切り:
  - 空白、記号で区切られた文字列を「単語」とみなす
  - 例: `src/utils/helper.js` → ["src", "utils", "helper", "js"]
- 他のEmacsキーバインド（引き続き動作）:
  - `Ctrl+A`: 行頭に移動
  - `Ctrl+E`: 行末に移動
  - `Ctrl+K`: カーソルから行末まで削除
  - `Ctrl+W`: 前の単語を削除
  - `Ctrl+U`: 行全体を削除
- Vimモードとの関係:
  - Vimモードが有効な場合、Alt+B/Fは動作しない
  - Vimモードでは `b`/`w` を使用
- 影響を受けないターミナル:
  - Terminal.app (macOS): 元々正常に動作
  - Alacritty: 別途設定が必要
- デバッグ:
  - `--debug` フラグでキー入力のログを確認
  - ログに「Received Alt+B」が表示されるか確認
- トラブルシューティング:
  - Alt+B/Fが動作しない場合:
    1. ターミナルの設定を確認（Optionキーの設定）
    2. Claude Codeを最新版に更新
    3. ターミナルを再起動
- iTerm2での設定確認:
  ```
  Preferences → Profiles → Keys → Left Option Key
  → "Esc+" に設定されているか確認
  ```
- Ghosttyでの設定:
  ```
  デフォルトでEsc+として動作
  設定変更不要
  ```
- 関連するキーバインド:
  - `Alt+D`: 次の単語を削除（Delete word forward）
  - `Alt+Backspace`: 前の単語を削除（Delete word backward）
  - これらも同様に修正されている

## 関連情報

- [Interactive mode - Claude Code Docs](https://code.claude.com/docs/en/interactive-mode)
- [Keyboard shortcuts](https://code.claude.com/docs/en/keyboard-shortcuts)
- [Emacs keybindings - Bash](https://www.gnu.org/software/bash/manual/html_node/Readline-Movement-Commands.html)
