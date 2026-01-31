---
title: "カスタマイズ可能なキーボードショートカット機能の追加"
date: 2026-01-23
tags: ['新機能', 'キーボードショートカット', 'カスタマイズ', 'keybindings']
---

## 原文（日本語に翻訳）

カスタマイズ可能なキーボードショートカット機能を追加しました。コンテキストごとにキーバインドを設定し、チョードシーケンスを作成して、ワークフローをパーソナライズできます。`/keybindings` コマンドを実行して開始してください。詳細は https://code.claude.com/docs/en/keybindings をご覧ください。

## 原文（英語）

Added customizable keyboard shortcuts. Configure keybindings per context, create chord sequences, and personalize your workflow. Run `/keybindings` to get started. Learn more at https://code.claude.com/docs/en/keybindings

## 概要

Claude Code v2.1.18では、キーボードショートカットを自由にカスタマイズできる機能が導入されました。この機能により、コンテキスト（Chat、Autocomplete、Settingsなど）ごとに異なるキーバインドを設定でき、Vimスタイルのチョードシーケンス（連続したキー入力）も作成できます。設定ファイル（`~/.claude/keybindings.json`）を編集することで、自分の作業スタイルに合わせたショートカットを設定し、より効率的にClaude Codeを利用できます。

## 基本的な使い方

### 設定ファイルの作成と開き方

ターミナルで以下のコマンドを実行すると、設定ファイルが自動的に作成され、エディタで開きます。

```bash
/keybindings
```

設定ファイルのパス: `~/.claude/keybindings.json`

### 基本的な設定例

以下は、Chatコンテキストで `Ctrl+E` を外部エディタの起動に割り当て、`Ctrl+U` のバインドを解除する例です。

```json
{
  "$schema": "https://platform.claude.com/docs/schemas/claude-code/keybindings.json",
  "$docs": "https://code.claude.com/docs/en/keybindings",
  "bindings": [
    {
      "context": "Chat",
      "bindings": {
        "ctrl+e": "chat:externalEditor",
        "ctrl+u": null
      }
    }
  ]
}
```

**重要**: 設定ファイルの変更は自動的に検出され、Claude Codeを再起動する必要はありません。

## 実践例

### Vimスタイルのキーバインド設定

j/kキーを使った履歴ナビゲーションと、メッセージセレクタでのVimスタイル操作を設定する例です。

```json
{
  "bindings": [
    {
      "context": "Chat",
      "bindings": {
        "ctrl+k": "history:previous",
        "ctrl+j": "history:next"
      }
    },
    {
      "context": "MessageSelector",
      "bindings": {
        "j": "messageSelector:down",
        "k": "messageSelector:up",
        "shift+j": "messageSelector:bottom",
        "shift+k": "messageSelector:top"
      }
    }
  ]
}
```

### チョードシーケンスの設定

連続したキー入力（チョード）を使った設定例です。`Ctrl+K` → `Ctrl+S` でタスクリストを表示します。

```json
{
  "bindings": [
    {
      "context": "Global",
      "bindings": {
        "ctrl+k ctrl+s": "app:toggleTodos",
        "ctrl+k ctrl+t": "app:toggleTranscript"
      }
    }
  ]
}
```

### タブナビゲーションのカスタマイズ

タブナビゲーションを `Ctrl+Tab` と `Ctrl+Shift+Tab` に変更する例です。

```json
{
  "bindings": [
    {
      "context": "Tabs",
      "bindings": {
        "ctrl+tab": "tabs:next",
        "ctrl+shift+tab": "tabs:previous"
      }
    }
  ]
}
```

### 複数コンテキストでの統一設定

複数のコンテキストで同じキーバインドを設定する例です。

```json
{
  "bindings": [
    {
      "context": "Global",
      "bindings": {
        "ctrl+t": "app:toggleTodos",
        "ctrl+o": "app:toggleTranscript"
      }
    },
    {
      "context": "Chat",
      "bindings": {
        "ctrl+g": "chat:externalEditor",
        "ctrl+s": "chat:stash"
      }
    },
    {
      "context": "Autocomplete",
      "bindings": {
        "ctrl+y": "autocomplete:accept",
        "ctrl+e": "autocomplete:dismiss"
      }
    }
  ]
}
```

## 利用可能なコンテキスト

| コンテキスト | 説明 |
|------------|------|
| `Global` | アプリ全体に適用 |
| `Chat` | メインのチャット入力エリア |
| `Autocomplete` | オートコンプリートメニューが開いているとき |
| `Settings` | 設定メニュー |
| `Confirmation` | 確認ダイアログ |
| `Tabs` | タブナビゲーション |
| `Help` | ヘルプメニュー表示中 |
| `Transcript` | トランスクリプトビューア |
| `HistorySearch` | 履歴検索モード（Ctrl+R） |
| `Task` | バックグラウンドタスク実行中 |
| `MessageSelector` | 巻き戻しダイアログ |
| `DiffDialog` | Diffビューア |
| `ModelPicker` | モデルピッカー |
| `Plugin` | プラグインダイアログ |

## キーストローク構文

### 修飾キー

- `ctrl` または `control` - Controlキー
- `alt`, `opt`, `option` - Alt/Optionキー
- `shift` - Shiftキー
- `meta`, `cmd`, `command` - Meta/Commandキー（Mac）

### 特殊キー

- `escape` または `esc` - Escapeキー
- `enter` または `return` - Enterキー
- `tab` - Tabキー
- `space` - スペースバー
- `up`, `down`, `left`, `right` - 矢印キー
- `backspace`, `delete` - 削除キー

### 大文字の扱い

単独の大文字は自動的にShiftを含みます。例えば `K` は `shift+k` と同等です。これはVimスタイルのバインドに便利です。

ただし、修飾キーと組み合わせた場合（例: `ctrl+K`）は、スタイル的なものとして扱われ、Shiftは含まれません。

## 注意点

### 予約済みショートカット

以下のショートカットは変更できません。

- `Ctrl+C` - 割り込み/キャンセル（ハードコード）
- `Ctrl+D` - 終了（ハードコード）

### ターミナルマルチプレクサとの競合

一部のショートカットはターミナルマルチプレクサと競合する可能性があります。

- `Ctrl+B` - tmuxのプレフィックス（2回押すと送信）
- `Ctrl+A` - GNU screenのプレフィックス
- `Ctrl+Z` - Unixプロセスのサスペンド（SIGTSTP）

### Vimモードとの相互作用

Vimモード（`/vim`）が有効な場合、キーバインドとVimモードは独立して動作します。

- Vimモードはテキスト入力レベルで処理（カーソル移動、モード切替など）
- キーバインドはコンポーネントレベルで処理（タスク表示、送信など）
- VimモードでのEscapeキーはINSERTからNORMALモードへの切り替えに使用され、`chat:cancel` はトリガーされません
- ほとんどの `Ctrl+キー` ショートカットはVimモードを通過してキーバインドシステムに渡されます

### バリデーション

設定ファイルのバリデーションが自動的に行われ、以下の警告が表示されます。

- パースエラー（不正なJSONや構造）
- 無効なコンテキスト名
- 予約済みショートカットとの競合
- ターミナルマルチプレクサとの競合
- 同一コンテキスト内の重複バインド

`/doctor` コマンドを実行すると、キーバインドの警告を確認できます。

## 関連情報

- [Claude Code キーバインド公式ドキュメント](https://code.claude.com/docs/en/keybindings)
- [Claude Code 公式ドキュメント](https://code.claude.com/docs/)
- [JSONスキーマファイル](https://platform.claude.com/docs/schemas/claude-code/keybindings.json)
