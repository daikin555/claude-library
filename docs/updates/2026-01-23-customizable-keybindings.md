---
title: "キーバインドのカスタマイズ：日本語IME対応とVimキー操作"
date: 2026-01-23
tags: [keybindings, ime, vim, customization]
---

# キーバインドのカスタマイズ：日本語IME対応とVimキー操作

## 概要

Claude Codeのキーバインドがカスタマイズ可能になりました。`/keybindings` コマンドで設定ファイルを開き、`~/.claude/keybindings.json` にキーマッピングを定義できます。日本語IME（Input Method Editor）のフルサポートも追加され、漢字変換中のキー競合問題が解消されています。Shift+Enterによる改行入力も、主要ターミナルで設定なしに使えるようになりました。

## 使い方

### 設定ファイルの作成・編集

```
/keybindings
```

このコマンドで `~/.claude/keybindings.json` が作成（または既存ファイルが開かれ）ます。

### keybindings.json の構造

```json
{
  "bindings": [
    {
      "key": "ctrl+k",
      "command": "clear",
      "context": "input"
    },
    {
      "key": "ctrl+j",
      "command": "submit",
      "context": "input"
    }
  ]
}
```

各バインディングのフィールド：

| フィールド | 説明 |
|-----------|------|
| `key` | キーの組み合わせ（例: `ctrl+k`, `shift+enter`, `alt+p`） |
| `command` | 実行するコマンド |
| `context` | バインディングが有効なコンテキスト |

### Shift+Enter での改行

v2.1.0から、iTerm2、WezTerm、Ghostty、Kittyでターミナル設定を変更せずにShift+Enterが使えるようになりました。

```
Shift+Enter → 入力欄で改行（プロンプトを送信せずに複数行入力）
Enter       → プロンプトを送信
```

## 活用シーン

- **日本語IMEとの競合解消**: Ctrl+NやCtrl+Pなどの日本語変換で使用するキーが、Claude Code側のショートカットと競合する問題を回避
- **Vimユーザー向けカスタマイズ**: Vim風のキー操作で履歴移動やコマンド実行
- **効率的なワークフロー**: よく使う操作にショートカットを割り当てて操作を高速化
- **チームでの統一設定**: keybindings.jsonをチームで共有して操作方法を統一

## コード例

### 日本語IME対応の設定例

日本語入力時のCtrl+N（次の変換候補）やCtrl+P（前の変換候補）がClaude Codeのショートカットと競合する場合：

```json
{
  "bindings": [
    {
      "key": "ctrl+n",
      "command": "noop",
      "context": "input",
      "when": "composing"
    }
  ]
}
```

### Vim風キーバインドの設定例

```json
{
  "bindings": [
    {
      "key": "ctrl+k",
      "command": "history_prev",
      "context": "input"
    },
    {
      "key": "ctrl+j",
      "command": "history_next",
      "context": "input"
    },
    {
      "key": "ctrl+l",
      "command": "clear",
      "context": "input"
    }
  ]
}
```

### マルチキー（コード）バインドの設定例

```json
{
  "bindings": [
    {
      "key": "ctrl+x ctrl+s",
      "command": "submit",
      "context": "input"
    },
    {
      "key": "ctrl+x ctrl+c",
      "command": "quit",
      "context": "input"
    }
  ]
}
```

## 注意点・Tips

- **IMEの改善**: Claude Codeは中国語、日本語、韓国語向けにIMEサポートを修正し、変換ウィンドウがカーソル位置に正しく配置されるようになりました。
- **SSH環境での制限**: SSH接続経由ではShift+Enterが正しく認識されない場合があります。その場合は `/terminal-setup` コマンドを実行して自動設定を試みてください。
- **設定の即時反映**: keybindings.jsonを保存すると、次回のClaude Code起動時に反映されます。
- **デフォルトキーバインドの確認**: カスタムキーバインドを設定する前に、デフォルトのキーバインドを確認して競合を避けてください。`/keybindings` コマンドで現在の設定を確認できます。
- **VS Code拡張機能との違い**: VS Code拡張機能を使用する場合、VS Code自体のキーバインド設定とClaude Code CLIのキーバインド設定は独立しています。VS Code側の設定は通常の「キーボードショートカット」設定で管理してください。
