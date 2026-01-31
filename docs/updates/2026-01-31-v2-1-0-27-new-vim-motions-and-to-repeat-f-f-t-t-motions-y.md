---
title: "Vimモーション大幅拡張 - yank/paste/text-object/indentなど11種類の操作を追加"
date: 2026-01-31
tags: ['新機能', 'Vim', 'UX']
---

## 原文（日本語に翻訳）

新しいVimモーションを追加: f/F/t/Tモーションの繰り返し用`;`と`,`、yank操作用`y`（`yy`/`Y`付き）、paste用`p`/`P`、テキストオブジェクト（`iw`, `aw`, `iW`, `aW`, `i"`, `a"`, `i'`, `a'`, `i(`, `a(`, `i[`, `a[`, `i{`, `a{`）、インデント/アンインデント用`>>`と`<<`、行結合用`J`

## 原文（英語）

Added new Vim motions: `;` and `,` to repeat f/F/t/T motions, `y` operator for yank with `yy`/`Y`, `p`/`P` for paste, text objects (`iw`, `aw`, `iW`, `aW`, `i"`, `a"`, `i'`, `a'`, `i(`, `a(`, `i[`, `a[`, `i{`, `a{`), `>>` and `<<` for indent/dedent, and `J` to join lines

## 概要

Claude Code v2.1.0で導入された、Vimモードの大幅な機能拡張です。従来のカーソル移動だけでなく、yank（コピー）、paste（貼り付け）、テキストオブジェクト選択、インデント操作、行結合など、Vimユーザーが日常的に使う重要な編集操作が追加されました。これにより、Claude Codeのインタラクティブモードでより効率的にテキスト編集ができるようになり、Vimの筋肉記憶を活かした高速な入力が可能になります。

## 基本的な使い方

Claude Codeのインタラクティブモードで、Vimモーションを有効にして使用します。

```bash
# Vimモードを有効化（settings.json）
{
  "vimMode": true
}

# Claude Code起動
claude

# ESCでノーマルモードに切り替え
# 以下のVimモーションが使用可能
```

## 実践例

### 検索モーションの繰り返し（`;` と `,`）

文字検索（`f`, `F`, `t`, `T`）を簡単に繰り返せます。

```
入力文字列: const result = calculate(a, b, c);

# 操作例:
f(    # 最初の ( に移動
;     # 次の ( に移動（繰り返し）
;     # さらに次の ( に移動
,     # 前の ( に戻る（逆方向）
```

### Yank（コピー）とPaste（貼り付け）

テキストをコピーして別の場所に貼り付けます。

```
# yy: 行全体をコピー
yy    # 現在行をコピー
j     # 下に移動
p     # カーソル下に貼り付け

# Y: 行末までコピー（yyと同じ動作）
Y     # 現在行をコピー

# p/P: 貼り付け
p     # カーソルの後ろに貼り付け
P     # カーソルの前に貼り付け

# モーションと組み合わせ
y3j   # 下3行をコピー
yw    # 単語をコピー
y$    # 行末までコピー
```

### テキストオブジェクト選択

括弧、引用符、単語の範囲を簡単に選択・操作できます。

```
入力文字列: const msg = "Hello, World!";

# 単語の操作
ciw   # 単語の中身を削除して挿入モード（change inner word）
diw   # 単語の中身を削除（delete inner word）
yiw   # 単語の中身をコピー（yank inner word）

# 単語+空白の操作
daw   # 単語と後続の空白を削除（delete a word）
caw   # 単語と後続の空白を変更（change a word）

# WORD（空白で区切られた塊）の操作
ciW   # WORDの中身を変更
daW   # WORDと空白を削除

# 引用符内の操作
ci"   # "..." の中身を変更（"Hello, World!" → "" + 挿入モード）
di"   # "..." の中身を削除
yi"   # "..." の中身をコピー
ca"   # "..." 全体を変更（引用符含む）
da"   # "..." 全体を削除（引用符含む）

# シングルクォート
ci'   # '...' の中身を変更
da'   # '...' 全体を削除

# 括弧内の操作
入力文字列: calculate(a, b, c)

ci(   # (a, b, c) の中身を変更 → () + 挿入モード
di(   # 括弧内を削除 → ()
da(   # 括弧ごと削除 → calculate

# 角括弧・波括弧も同様
ci[   # [...] の中身を変更
di{   # {...} の中身を削除
```

### インデント操作（`>>` と `<<`）

行のインデントを調整します。

```
# >>: インデント追加
>>    # 現在行を右にインデント
3>>   # 3行を右にインデント

# <<: インデント削除
<<    # 現在行を左にアンインデント
2<<   # 2行を左にアンインデント

# ビジュアルモードと組み合わせ
V     # ビジュアルラインモード
jj    # 3行選択
>     # 選択範囲をインデント
```

### 行結合（`J`）

複数行を1行に結合します。

```
入力:
  const name = "Alice";
  const age = 30;
  const city = "Tokyo";

# カーソルを1行目に置く
J     # 2行を結合 → const name = "Alice"; const age = 30;
J     # さらに結合 → const name = "Alice"; const age = 30; const city = "Tokyo";

# 複数行を一度に結合
3J    # 3行を結合
```

### 実践的な編集ワークフロー

関数の引数を素早く編集します。

```
入力: function greet(name, age, city) {

# "name" を "userName" に変更
  ciw userName <ESC>

# カンマで次の引数に移動して変更
  f, w ciw userAge <ESC>

# さらに次の引数
  ; w ciw userCity <ESC>

結果: function greet(userName, userAge, userCity) {
```

## 注意点

- この機能は Claude Code v2.1.0（2026年1月7日リリース）で導入されました
- Vimモードの有効化:
  ```json
  // ~/.claude/settings.json
  {
    "vimMode": true
  }
  ```
- 新しく追加されたモーション一覧:
  - **検索繰り返し**: `;`（順方向）、`,`（逆方向）
  - **Yank**: `y`（オペレーター）、`yy`、`Y`
  - **Paste**: `p`（後ろ）、`P`（前）
  - **テキストオブジェクト**: `iw`, `aw`, `iW`, `aW`, `i"`, `a"`, `i'`, `a'`, `i(`, `a(`, `i[`, `a[`, `i{`, `a{`
  - **インデント**: `>>`、`<<`
  - **行結合**: `J`
- テキストオブジェクトの `i` と `a`:
  - `i` (inner): 区切り文字の中身のみ
  - `a` (around): 区切り文字を含む全体
- テキストオブジェクトの `w` と `W`:
  - `w` (word): 英数字と`_`で構成される単語
  - `W` (WORD): 空白で区切られた塊
- Yankとクリップボード:
  - Yankしたテキストは Claude Code の内部レジスタに保存
  - システムクリップボードとの連携は別途設定が必要
- 従来からサポートされているVimモーション:
  - 基本移動: `h`, `j`, `k`, `l`, `w`, `b`, `e`, `0`, `$`, `gg`, `G`
  - 検索: `f`, `F`, `t`, `T`
  - 削除: `d`, `dd`, `D`, `x`
  - 変更: `c`, `cc`, `C`
  - モード切替: `i`, `a`, `I`, `A`, `o`, `O`, `v`, `V`, `ESC`
- まだサポートされていない機能（2026年1月時点）:
  - マクロ記録（`q`）
  - マーク（`m`, `` ` ``）
  - レジスタ選択（`"a`）
  - ビジュアルブロックモード（`Ctrl+V`）

## 関連情報

- [Interactive mode - Claude Code Docs](https://code.claude.com/docs/en/interactive-mode)
- [Vim mode keybindings](https://code.claude.com/docs/en/vim-mode)
- [Vim Reference Manual - Text Objects](http://vimdoc.sourceforge.net/htmldoc/motion.html#text-objects)
