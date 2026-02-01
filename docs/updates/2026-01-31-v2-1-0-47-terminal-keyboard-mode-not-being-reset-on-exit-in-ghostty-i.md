---
title: "Ghostty/iTerm2/Kitty/WezTerm終了時のターミナルキーボードモード未リセットを修正"
date: 2026-01-31
tags: ['バグ修正', 'ターミナル', 'UX']
---

## 原文（日本語に翻訳）

Ghostty、iTerm2、Kitty、WezTermでClaude Code終了時にターミナルキーボードモードがリセットされない問題を修正しました

## 原文（英語）

Fixed terminal keyboard mode not being reset on exit in Ghostty, iTerm2, Kitty, and WezTerm

## 概要

Claude Code v2.1.0で修正された、モダンターミナルエミュレータでのキーボードモードバグです。以前のバージョンでは、Claude Code終了時に拡張キーボードモード（modifyOtherKeys）が適切にリセットされず、終了後のシェルで特殊キーや修飾キーの組み合わせが正しく動作しませんでした。この修正により、Claude Code終了時にターミナルの状態が完全に復元されるようになりました。

## 修正前の問題

### 症状

```bash
# iTerm2でClaude Code起動
claude

# 通常使用後、終了
> exit

# シェルに戻るが、キーボードが正常に動作しない
$ ls -la
# 一部のキーが反応しない、または誤った文字が入力される

# Ctrl+C が動作しない
$ sleep 100
# Ctrl+C を押しても中断できない

# 矢印キーがエスケープシーケンスとして表示される
$ cd /
# ↑ キーを押すと: ^[[A と表示される
```

### 影響を受けるターミナル

- **Ghostty**: 新しい高速ターミナルエミュレータ
- **iTerm2**: macOS人気ターミナル
- **Kitty**: GPU加速ターミナル
- **WezTerm**: クロスプラットフォームターミナル

## 修正後の動作

### 正常な状態復元

```bash
# Claude Code起動
claude

# 使用後、終了
> exit

# 修正後: ターミナルが完全に復元される
$ ls -la
# ✓ すべてのキーが正常に動作

# Ctrl+C が正常に動作
$ sleep 100
# Ctrl+C で即座に中断

# 矢印キーが正常に動作
# ↑ でコマンド履歴を表示
```

## 実践例

### 長時間セッション後の復元

長時間Claude Codeを使用した後も、ターミナルが正常に復元されます。

```bash
# 数時間Claude Codeを使用
claude
# ... 作業 ...
> exit

# 修正前: ターミナルが不安定
# 修正後: 完全に正常な状態
$ git status  # ✓ 正常動作
$ vim file.js  # ✓ 正常動作
```

### Ctrl+C で中断後の復元

Claude Code をCtrl+Cで強制終了した場合も復元されます。

```bash
# Claude Code起動
claude

# 長時間処理中にCtrl+Cで中断
^C

# 修正前: ターミナルが壊れた状態
# 修正後: 正常に復元
$ echo "test"  # ✓ 正常動作
```

### スクリプトからの呼び出し

スクリプト内でClaude Codeを使用しても、終了後の処理が正常に動作します。

```bash
#!/bin/bash
# automation.sh

# Claude Codeで自動処理
claude --prompt "コードレビュー" --no-interactive

# Claude Code終了後の処理
# 修正前: キーボードモードが壊れて後続処理が失敗
# 修正後: 正常に継続
git add .
git commit -m "Review applied"
```

### tmux/screen内での使用

tmuxやscreen内でClaude Codeを使用しても、正常に復元されます。

```bash
# tmuxセッション内
tmux new -s work

# Claude Code使用
claude
> exit

# 修正後: tmuxのキーバインドが正常に動作
# Ctrl+B d  # ✓ デタッチが正常に動作
```

## 注意点

- この修正は Claude Code v2.1.0（2026年1月7日リリース）で実装されました
- 影響を受けるターミナル:
  - **Ghostty** (v0.x以降)
  - **iTerm2** (v3.x以降)
  - **Kitty** (v0.x以降)
  - **WezTerm** (v20220x以降)
- 拡張キーボードモード（modifyOtherKeys）:
  - ターミナルの高度なキー入力処理機能
  - Ctrl+文字、Alt+文字などの修飾キーを正確に識別
  - Claude CodeはVimモードなどでこの機能を使用
- 修正の詳細:
  - Claude Code起動時: 拡張キーボードモードを有効化
  - Claude Code終了時: 元のモードに復元
  - エスケープシーケンス: `\x1b[>4;0m` (リセット)
- 正常終了と異常終了の両方に対応:
  - 通常終了（`exit`, `quit`）: ✓ リセット
  - Ctrl+C: ✓ リセット
  - Ctrl+D: ✓ リセット
  - クラッシュ: ✓ リセット（シグナルハンドラ）
- Terminal.appへの影響:
  - macOSのTerminal.appは拡張キーボードモードをサポートしていない
  - この修正による影響なし
- Alacrittyへの影響:
  - Alacrittyも修正の対象
  - 同様にリセット処理が適用される
- 手動リセット（修正前の回避策）:
  ```bash
  # ターミナルがおかしくなった場合
  reset
  # または
  stty sane
  ```
- デバッグ:
  - `--debug` フラグでキーボードモードの設定/リセットログを確認
  - ログに「Resetting keyboard mode」が表示される
- 関連する改善:
  - Vimモードの安定性向上
  - キーバインドの信頼性向上
- トラブルシューティング:
  - 修正後もターミナルが不安定な場合:
    1. ターミナルアプリを最新版に更新
    2. Claude Codeを最新版に更新
    3. ターミナルの設定をリセット
- 環境変数の影響:
  - `TERM` 環境変数が正しく設定されているか確認
  - `echo $TERM` で確認（例: `xterm-256color`）

## 関連情報

- [Interactive mode - Claude Code Docs](https://code.claude.com/docs/en/interactive-mode)
- [Supported terminals](https://code.claude.com/docs/en/terminals)
- [modifyOtherKeys - XTerm documentation](https://invisible-island.net/xterm/ctlseqs/ctlseqs.html)
