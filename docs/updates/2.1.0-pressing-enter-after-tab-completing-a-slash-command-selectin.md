---
title: "Tab補完後のEnterキーで別コマンドが選択される問題を修正"
date: 2026-01-31
tags: ['バグ修正', 'UX', 'オートコンプリート']
---

## 原文（日本語に翻訳）

スラッシュコマンドのTab補完後にEnterキーを押すと、補完したコマンドを送信する代わりに別のコマンドが選択される問題を修正しました

## 原文（英語）

Fixed pressing Enter after Tab-completing a slash command selecting a different command instead of submitting the completed one

## 概要

Claude Code v2.1.0で修正された、スラッシュコマンド補完のキーバインドバグです。以前のバージョンでは、スラッシュコマンドをTabキーで補完した直後にEnterキーを押すと、補完したコマンドが送信される代わりに、補完候補リストの別のコマンドが選択されていました。この修正により、Tab補完後のEnterキーが期待通りに動作し、補完したコマンドがそのまま実行されるようになりました。

## 修正前の問題

### 症状

```bash
claude

# "/com" と入力してTab補完
> /com<Tab>

# 補完候補が表示される:
# - /commit
# - /community-pr-specialist

# Tabで /commit が補完される
> /commit

# Enterキーを押す
<Enter>

# 修正前: 別のコマンドが選択される
> /community-pr-specialist

# 意図しないコマンドが実行される
```

### 発生条件

- スラッシュコマンドの一部を入力
- Tabキーで補完
- 即座にEnterキーを押す
- 複数の候補がある場合に発生

## 修正後の動作

### 期待通りの補完と実行

```bash
claude

# "/com" と入力してTab補完
> /com<Tab>

# /commit が補完される
> /commit

# Enterキーを押す
<Enter>

# 修正後: 補完したコマンドがそのまま実行される
# ✓ /commit スキルが実行される
```

## 実践例

### コミットコマンドの素早い実行

最小限のキー入力でコミットを作成します。

```bash
> /com<Tab><Enter>

# 修正前: /community-pr-specialist が実行される
# 修正後: ✓ /commit が実行される

# より高速なワークフロー
```

### 類似名のコマンド選択

似た名前のコマンドを確実に実行します。

```bash
# /plan と /platform-engineer がある場合
> /pla<Tab>

# /plan が補完される
> /plan

<Enter>

# 修正後: ✓ /plan が実行される
# /platform-engineer ではない
```

### 長いコマンド名の入力効率化

長いコマンド名を素早く入力します。

```bash
# /feature-dev:code-architect を実行したい
> /fea<Tab>

# /feature-dev が補完される
> /feature-dev

# さらに入力
> /feature-dev:co<Tab>

# /feature-dev:code-architect が補完される
> /feature-dev:code-architect

<Enter>

# 修正後: ✓ 補完したコマンドが実行される
```

### 頻繁に使うコマンドの効率化

よく使うコマンドを筋肉記憶で入力します。

```bash
# 毎回同じパターン
> /rev<Tab><Enter>

# /review-pr が実行される
# 修正前: ランダムに別のコマンドが実行される可能性
# 修正後: ✓ 常に期待通り /review-pr が実行される
```

## 注意点

- この修正は Claude Code v2.1.0（2026年1月7日リリース）で実装されました
- Tab補完の動作:
  - **単一マッチ**: 自動的に補完される
  - **複数マッチ**: 候補リストが表示される
  - **Tab連打**: 候補を順に選択
  - **Enter**: 現在の入力/選択を確定
- 修正前の動作（バグ）:
  1. Tab補完で `/commit` が入力される
  2. Enterキーを押す
  3. 内部的に補完候補リストが残っている
  4. Enterが「次の候補を選択」として解釈される
  5. 別のコマンド（例: `/community-pr-specialist`）が選択される
- 修正後の動作:
  1. Tab補完で `/commit` が入力される
  2. Enterキーを押す
  3. 補完候補リストがクリアされている
  4. Enterが「コマンド実行」として解釈される
  5. `/commit` が実行される
- 他のキーバインド:
  - **Tab**: 補完/次の候補
  - **Shift+Tab**: 前の候補
  - **Esc**: 補完キャンセル
  - **Enter**: 確定/実行
  - **矢印キー**: 候補リスト内を移動（修正後も正常動作）
- 補完候補の表示:
  - 候補が2つ以上ある場合、リストが表示される
  - リスト表示中も修正後は正常に動作
- デバッグ:
  - `--debug` フラグで補完処理のログを確認
  - ログに「Autocomplete committed: /commit」が表示される
- 関連する改善:
  - index 29: スラッシュコマンド自動補完が入力のどこでも動作
  - より一貫性のある補完体験
- パフォーマンスへの影響:
  - 修正による影響なし
  - 補完の応答性は変わらず
- トラブルシューティング:
  - Tab補完が動作しない場合:
    1. スラッシュコマンドが有効か確認
    2. コマンド名のスペルを確認
    3. インタラクティブモードで使用しているか確認

## 関連情報

- [Slash commands - Claude Code Docs](https://code.claude.com/docs/en/slash-commands)
- [Interactive mode](https://code.claude.com/docs/en/interactive-mode)
- [Keyboard shortcuts](https://code.claude.com/docs/en/keyboard-shortcuts)
