---
title: "Kitty キーボードプロトコルでのテンキー入力を修正"
date: 2026-01-13
tags: ['バグ修正', 'Kitty', 'キーボード', 'テンキー']
---

## 原文（日本語に翻訳）

Kitty キーボードプロトコル端末でテンキーがエスケープシーケンスを出力する代わりに文字を出力していなかった問題を修正

## 原文（英語）

Fixed numpad keys outputting escape sequences instead of characters in Kitty keyboard protocol terminals

## 概要

Claude Code v2.1.6 では、Kitty キーボードプロトコルを使用する端末でのテンキー入力の問題が修正されました。以前のバージョンでは、テンキーで数字を入力すると、数字の代わりにエスケープシーケンスが出力されてしまう問題がありました。この修正により、Kitty、WezTerm、その他の最新端末でテンキーが正常に動作するようになりました。

## 基本的な使い方

この修正は自動的に適用され、ユーザー側での設定変更は不要です。

Kitty プロトコル対応端末での使用:
1. Claude Code を起動
2. テンキーで数字を入力
3. 正しく数字が表示される

## 実践例

### 修正前の問題（v2.1.5以前）

Kitty プロトコル端末でテンキーを使用すると:

```bash
# テンキーで "123" と入力したい
[NumPad 1] [NumPad 2] [NumPad 3]

# しかし、以下のようなエスケープシーケンスが出力される
^[[1~^[[2~^[[3~

# または
\x1b[1~\x1b[2~\x1b[3~

# 正しい数字が入力されない
```

これにより、以下の作業が困難でした:
- 数値の入力（ポート番号、設定値など）
- 計算機的な使用
- データ入力

### 修正後の動作（v2.1.6以降）

v2.1.6 では、テンキーが正常に動作します:

```bash
# テンキーで "123" と入力
[NumPad 1] [NumPad 2] [NumPad 3]

# 正しく表示される
123

# 他のキーと同様に使用可能
```

### 対応端末

この修正が適用される端末:

1. **Kitty**
   ```bash
   # Kitty 端末で確認
   $ echo $TERM
   xterm-kitty

   # テンキーが正常に動作
   ```

2. **WezTerm**
   ```bash
   # WezTerm の Kitty プロトコルモードで動作
   $ echo $TERM
   wezterm

   # テンキー入力が正常
   ```

3. **その他の Kitty プロトコル対応端末**
   - Alacritty（Kitty モード有効時）
   - Ghostty
   - Rio

### テンキーでの数値入力

ポート番号の入力:

```bash
# サーバーを起動
Run server on port: 8080  ← テンキーで入力可能

# データベース接続
Database port: 5432  ← テンキーで正確に入力
```

### 設定値の入力

設定値をテンキーで入力:

```bash
/config

# timeout 設定を変更
timeout: 30  ← テンキーで入力

# maxTokens 設定
maxTokens: 4096  ← テンキーで入力
```

### 計算やデータ入力

数値計算を含む質問:

```
Claude に質問:
"Calculate: 123 + 456"
         ↑ テンキーで入力可能

# v2.1.6 以降は正常に入力できる
```

### キーボードレイアウトの確認

テンキーの動作を確認:

```bash
# テンキーの各キーをテスト
NumPad 0: 0 ✓
NumPad 1: 1 ✓
NumPad 2: 2 ✓
NumPad 3: 3 ✓
NumPad 4: 4 ✓
NumPad 5: 5 ✓
NumPad 6: 6 ✓
NumPad 7: 7 ✓
NumPad 8: 8 ✓
NumPad 9: 9 ✓
NumPad .: . ✓
NumPad +: + ✓
NumPad -: - ✓
NumPad *: * ✓
NumPad /: / ✓
```

### Kitty プロトコルの確認

使用中の端末が Kitty プロトコルをサポートしているか確認:

```bash
# Kitty 端末の場合
$ kitty +kitten show_key -m kitty

# キーボードプロトコルバージョンを確認
# バージョン 1 以上であれば対応
```

### 代替手段（修正前の回避策）

v2.1.5 以前で回避する方法（既に不要）:

```bash
# テンキーではなく、通常の数字キーを使用
# または、Kitty プロトコルを無効化
# ~/.config/kitty/kitty.conf
# keyboard_protocol legacy  # 非推奨
```

## 注意点

- この修正は Claude Code v2.1.6 で導入されました
- Kitty キーボードプロトコルをサポートする端末でのみ関連します
- 従来の端末エミュレータ（非Kittyプロトコル）では元々正常に動作していました
- NumLock がオンになっている必要があります（OS標準の動作）
- この修正により、最新の端末エミュレータでの UX が大幅に改善されました
- テンキーの Enter キーや他の特殊キーも正常に動作します
- この問題は Kitty プロトコルの拡張キーコード処理の誤りにより発生していました

## 関連情報

- [Changelog v2.1.6](https://github.com/anthropics/claude-code/releases/tag/v2.1.6)
- [Kitty keyboard protocol](https://sw.kovidgoyal.net/kitty/keyboard-protocol/)
- [Changelog v2.1.6 - Option+Return fix](https://github.com/anthropics/claude-code/releases/tag/v2.1.6) - 関連する Kitty プロトコルの修正
