---
title: "スピナー表示テキストのカスタマイズ設定（spinnerVerbs）"
date: 2026-01-29
tags: ['新機能', '設定', 'UI']
---

## 原文（日本語に翻訳）

カスタマイズ可能なスピナー動詞設定（`spinnerVerbs`）を追加

## 原文（英語）

Added customizable spinner verbs setting (`spinnerVerbs`)

## 概要

Claude Codeの実行中に表示されるスピナー（ローディングアニメーション）のテキストをカスタマイズできる新しい設定が追加されました。各ツール実行時に表示される動詞（「読み込み中」「検索中」など）を、ユーザーの好みに合わせて変更できます。これにより、より親しみやすい表現や、チーム内で統一された用語を使用することが可能になります。

## 基本的な使い方

設定ファイル（`~/.claude/settings.json`）に`spinnerVerbs`オブジェクトを追加して、各ツールの動詞をカスタマイズします。

```json
{
  "spinnerVerbs": {
    "Read": "読み込み中",
    "Write": "書き込み中",
    "Edit": "編集中",
    "Bash": "実行中"
  }
}
```

設定を保存後、Claude Codeを再起動すると変更が反映されます。

## 実践例

### 日本語でのカスタマイズ

```json
{
  "spinnerVerbs": {
    "Read": "ファイル読込",
    "Write": "ファイル作成",
    "Edit": "ファイル編集",
    "Bash": "コマンド実行",
    "Grep": "検索",
    "Glob": "ファイル検索",
    "WebFetch": "Web取得"
  }
}
```

### カジュアルな表現

```json
{
  "spinnerVerbs": {
    "Read": "覗いてます",
    "Write": "書いてます",
    "Edit": "いじってます",
    "Bash": "走らせてます",
    "Grep": "探してます"
  }
}
```

### 簡潔な表現

```json
{
  "spinnerVerbs": {
    "Read": "読取",
    "Write": "書込",
    "Edit": "編集",
    "Bash": "実行",
    "Grep": "検索"
  }
}
```

### チーム用語に合わせたカスタマイズ

開発チームで使用している用語に統一することで、チームメンバー間での理解を深めることができます。

```json
{
  "spinnerVerbs": {
    "Read": "コンテンツ取得",
    "Write": "アセット作成",
    "Edit": "リソース更新",
    "Bash": "スクリプト実行"
  }
}
```

## 注意点

- すべてのツール名に対して動詞を設定する必要はありません。設定していないツールはデフォルトの表現が使用されます
- 設定変更後は、Claude Codeの再起動が必要です
- 絵文字を含む文字列も使用可能ですが、ターミナルの表示環境によっては正しく表示されない場合があります
- 長すぎるテキストを設定すると、ターミナルの表示が崩れる可能性があるため、簡潔な表現を推奨します

## 関連情報

- [Claude Code 設定ファイルガイド](https://code.claude.com/docs/)
- [Changelog v2.1.23](https://github.com/anthropics/claude-code/releases/tag/v2.1.23)
- Claude Codeの設定ファイルは通常`~/.claude/settings.json`に配置されます
