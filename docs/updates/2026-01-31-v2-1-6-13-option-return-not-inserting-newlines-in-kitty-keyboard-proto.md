---
title: "Kitty キーボードプロトコルでの Option+Return の改行入力を修正"
date: 2026-01-13
tags: ['バグ修正', 'Kitty', 'キーボード', 'macOS', '改行']
---

## 原文（日本語に翻訳）

Kitty キーボードプロトコル端末で Option+Return が改行を挿入しなかった問題を修正

## 原文（英語）

Fixed Option+Return not inserting newlines in Kitty keyboard protocol terminals

## 概要

Claude Code v2.1.6 では、Kitty キーボードプロトコルを使用する端末での Option+Return（macOS）/ Alt+Return（Linux/Windows）の動作が修正されました。以前のバージョンでは、このキーの組み合わせで改行を挿入できず、複数行の入力が困難でした。この修正により、テキスト入力時に Enter を押さずに改行を挿入できるようになりました。

## 基本的な使い方

複数行のテキストを入力する方法:

1. Claude Code の入力欄でテキストを入力
2. 改行したい位置で `Option+Return`（macOS）または `Alt+Return`（Linux/Windows）を押す
3. 送信せずに改行が挿入される
4. 複数行のテキストを入力後、単独で `Return` を押して送信

## 実践例

### 修正前の問題（v2.1.5以前）

Kitty プロトコル端末で Option+Return を押しても:

```bash
# 複数行のコードを入力したい
def hello():  [Option+Return]
# ← 改行されず、何も起こらない

# または、予期しない動作が発生
def hello():◆  # 特殊文字が入力される
```

このため、複数行の入力には以下の回避策が必要でした:
- 外部エディタ（Ctrl+G）を使用
- 1行ずつ送信して継続を依頼
- Kitty プロトコルを無効化

### 修正後の動作（v2.1.6以降）

v2.1.6 では、Option+Return で正常に改行が挿入されます:

```bash
# 複数行のコードを入力
def hello():  [Option+Return]
    print("Hello, World!")  [Option+Return]
    return True

# 完成したら Return で送信
```

### 複数行コードの入力

Python 関数の入力:

```python
# Option+Return で改行しながら入力
def calculate_sum(numbers):  [Option+Return]
    total = 0  [Option+Return]
    for num in numbers:  [Option+Return]
        total += num  [Option+Return]
    return total

# 最後に Return を押して送信
```

### 長い質問の作成

複数行の質問を整形:

```
# Option+Return で段落を分ける
Claude に質問:  [Option+Return]
[Option+Return]
以下の要件を満たすコードを作成してください:  [Option+Return]
1. ファイルを読み込む  [Option+Return]
2. データを解析する  [Option+Return]
3. 結果を保存する

# 送信は最後の Return のみ
```

### Markdown の入力

複数行の Markdown テキスト:

```markdown
# Option+Return で Markdown を整形
## 見出し  [Option+Return]
[Option+Return]
これは段落です。  [Option+Return]
[Option+Return]
- リスト項目1  [Option+Return]
- リスト項目2

# Return で送信
```

### JSON/YAML の入力

構造化データの入力:

```json
# Option+Return で整形された JSON を入力
{  [Option+Return]
  "name": "example",  [Option+Return]
  "version": "1.0.0",  [Option+Return]
  "dependencies": {  [Option+Return]
    "package": "^2.0.0"  [Option+Return]
  }  [Option+Return]
}

# Return で送信
```

### コマンドのマルチライン入力

複雑なシェルコマンド:

```bash
# Option+Return でコマンドを複数行に
docker run \  [Option+Return]
  --name myapp \  [Option+Return]
  --port 8080:8080 \  [Option+Return]
  -v /data:/app/data \  [Option+Return]
  myimage:latest

# Return で送信
```

### 対応端末の確認

Option+Return が動作する端末:

1. **Kitty（macOS）**
   ```bash
   # Option+Return で改行
   ```

2. **WezTerm（macOS）**
   ```bash
   # Option+Return または Alt+Return
   ```

3. **Kitty（Linux）**
   ```bash
   # Alt+Return で改行
   ```

4. **その他の Kitty プロトコル対応端末**
   - Ghostty
   - Rio
   - Alacritty（Kitty モード）

### キーバインドの確認

使用中の端末でのキーバインド:

```bash
# macOS の場合
Option+Return → 改行挿入（送信しない）
Return → メッセージ送信

# Linux/Windows の場合
Alt+Return → 改行挿入（送信しない）
Return → メッセージ送信

# Shift+Return も動作する場合がある（端末依存）
```

### 代替方法

Option+Return が使えない環境での対処:

```bash
# 1. 外部エディタを使用（推奨）
Ctrl+G  # エディタを開く

# 2. 複数メッセージに分割
# メッセージ1: "以下のコードの続きを書いてください:"
# メッセージ2: 続きの内容

# 3. ファイルからペースト
# 別のエディタで作成してコピー&ペースト
```

## 注意点

- この修正は Claude Code v2.1.6 で導入されました
- Kitty キーボードプロトコルをサポートする端末でのみ関連します
- macOS では `Option+Return`、Linux/Windows では `Alt+Return` を使用します
- 端末エミュレータの設定によっては、Option/Alt キーの動作が異なる場合があります
- Kitty の設定で `macos_option_as_alt` が有効になっている必要がある場合があります
- 従来の端末では元々動作していた機能です（Kitty プロトコル特有の問題）
- この修正により、Kitty ユーザーの入力体験が大幅に改善されました

## 関連情報

- [Changelog v2.1.6](https://github.com/anthropics/claude-code/releases/tag/v2.1.6)
- [Kitty keyboard protocol](https://sw.kovidgoyal.net/kitty/keyboard-protocol/)
- [Changelog v2.1.6 - Numpad keys fix](https://github.com/anthropics/claude-code/releases/tag/v2.1.6) - 関連する Kitty プロトコルの修正
