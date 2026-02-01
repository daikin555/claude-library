---
title: "ダイアログ内のタブを左右矢印キーで切り替え可能に"
date: 2026-01-31
tags: ['改善', 'UX', 'キーボード']
---

## 原文（日本語に翻訳）

ダイアログ内のタブを左右矢印キーで切り替えるナビゲーション機能を追加しました

## 原文（英語）

Added left/right arrow key navigation for cycling through tabs in dialogs

## 概要

Claude Code v2.1.0で導入された、ダイアログUIの操作性向上機能です。バックグラウンドタスク詳細、設定画面、ヘルプダイアログなど、タブを持つダイアログで、マウスを使わずに左右矢印キー（`←` / `→`）でタブを素早く切り替えられるようになりました。これにより、キーボード中心のワークフローが強化され、マウスとキーボード間の手の移動が不要になります。

## 基本的な使い方

タブ付きダイアログが表示されているときに、左右矢印キーでタブを切り替えます。

```bash
# バックグラウンドタスク詳細を表示（Ctrl+B → タスク選択）
# タブが表示される: [Output] [Details] [Environment]

# 右矢印キーでタブ移動
→ キー: Output → Details
→ キー: Details → Environment
→ キー: Environment → Output（ループ）

# 左矢印キーで逆方向
← キー: Output → Environment
← キー: Environment → Details
```

## 実践例

### バックグラウンドタスクの詳細確認

実行中のタスクの出力、詳細、環境変数を素早く確認します。

```bash
# タスクをバックグラウンド実行
> npm test
# Ctrl+B でバックグラウンド化

# タスク一覧を表示
# Ctrl+B

# タスクを選択してEnter
# [Output] タブが表示される

# 右矢印で [Details] タブに移動
→ キー
# タスクID、開始時刻、コマンドなどを確認

# さらに右矢印で [Environment] タブに移動
→ キー
# 環境変数を確認

# 左矢印で [Output] に戻る
← ← キー
```

### 設定画面のナビゲーション

設定ダイアログで異なるカテゴリを素早く切り替えます。

```bash
# 設定を開く（仮想的なコマンド）
> /settings

# タブ: [General] [Permissions] [Hooks] [Plugins]

# 右矢印でナビゲート
→ キー: General → Permissions
→ キー: Permissions → Hooks
→ キー: Hooks → Plugins

# 左矢印で戻る
← キー: Plugins → Hooks
```

### ヘルプダイアログの参照

複数セクションのヘルプを素早く閲覧します。

```bash
> /help

# タブ: [Commands] [Shortcuts] [Tools] [FAQ]

# 矢印キーで目的のセクションを探す
→ キー: Commands → Shortcuts
→ キー: Shortcuts → Tools

# 目的のタブで内容を確認
# ← キーで前のセクションに戻る
```

### コンテキスト表示（Ctrl+O）でのタブ切り替え

トランスクリプト表示で異なるビューを切り替えます。

```bash
# トランスクリプトを表示
Ctrl+O

# タブ: [Messages] [Context] [Thinking]

# 右矢印で切り替え
→ キー: Messages → Context（現在のコンテキスト表示）
→ キー: Context → Thinking（思考プロセス表示）

# 左矢印で戻る
← キー: Thinking → Context
```

## 注意点

- この機能は Claude Code v2.1.0（2026年1月7日リリース）で導入されました
- 対象のダイアログ:
  - **バックグラウンドタスク詳細**（Ctrl+B → タスク選択）
  - **設定画面**（存在する場合）
  - **ヘルプダイアログ**（存在する場合）
  - **コンテキスト表示**（Ctrl+O）
  - その他のタブ付きダイアログ
- キーバインド:
  - `→`（右矢印）: 次のタブに移動（最後のタブから最初のタブへループ）
  - `←`（左矢印）: 前のタブに移動（最初のタブから最後のタブへループ）
- 他の操作との併用:
  - 上下矢印キー: タブ内のコンテンツをスクロール
  - Tab/Shift+Tab: フォーカス可能な要素間を移動
  - Enter: アクション実行（ボタンなど）
  - Esc: ダイアログを閉じる
- ダイアログの種類による違い:
  - モーダルダイアログ: 矢印キーは常にタブ切り替えに使用
  - インライン表示: コンテンツ内でフォーカスがある場合、上下矢印はスクロールに使用
- Vimモードとの関係:
  - Vimモードが有効でも、ダイアログ内では矢印キーがタブ切り替えに使用される
  - `h`/`l`（Vimの左右移動）はタブ切り替えには使用されない
- アクセシビリティ:
  - スクリーンリーダー使用時、タブ切り替えが適切にアナウンスされる
  - キーボードのみで完全な操作が可能
- マウス操作:
  - マウスクリックでのタブ切り替えも引き続き可能
  - 矢印キーとマウスを併用できる
- ループ動作:
  - 最後のタブで右矢印を押すと、最初のタブに戻る
  - 最初のタブで左矢印を押すと、最後のタブに移動
- パフォーマンス:
  - タブ切り替えは即座に実行される（遅延なし）
  - 大量のコンテンツがあるタブでも、切り替えはスムーズ

## 関連情報

- [Interactive mode - Claude Code Docs](https://code.claude.com/docs/en/interactive-mode)
- [Keyboard shortcuts](https://code.claude.com/docs/en/keyboard-shortcuts)
- [Background tasks](https://code.claude.com/docs/en/background-tasks)
