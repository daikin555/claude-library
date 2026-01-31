---
title: "ツール実行中に中断されたセッション再開時のAPIエラーを修正"
date: 2026-01-28
tags: ['バグ修正', 'セッション管理', 'API']
---

## 原文（日本語に翻訳）

ツール実行中に中断されたセッションを再開する際のAPIエラーを修正

## 原文（英語）

Fixed API errors when resuming sessions that were interrupted during tool execution

## 概要

Claude Codeがツール（Read、Edit、Bashなど）を実行している最中にセッションが中断され、その後セッションを再開しようとするとAPIエラーが発生する問題が修正されました。この問題により、作業の途中でネットワーク切断やアプリケーションのクラッシュが発生した場合、セッションの復元ができませんでした。v2.1.21では、中断されたツール実行の状態を適切に処理し、安全にセッションを再開できるようになりました。

## 基本的な使い方

セッションが中断された場合、通常通りセッションIDを指定して再開できます。

```bash
# セッション再開
claude code --resume <session-id>
```

v2.1.21以降は、ツール実行中に中断された場合でもエラーなく再開できます。

## 実践例

### ネットワーク切断からの復帰

大きなファイルを読み込んでいる最中にネットワークが切断された場合：

```bash
# 作業中にネットワーク切断が発生
$ claude code
> 大きなログファイルを分析して
[Reading large-log.txt...]  # ここで接続が切れる

# 再接続後、セッションを再開
$ claude code --resume abc123
# v2.1.21以降: 正常に再開され、前回の状態から継続
# v2.1.20以前: APIエラーが発生し、セッション再開不可
```

### 長時間実行中の中断

バックグラウンドでタスクを実行中、予期せぬ中断が発生した場合：

```bash
$ claude code
> プロジェクト全体のテストを実行して
[Task: Running tests in background...]  # ここでターミナルを誤って閉じる

# 新しいターミナルで再開
$ claude code --resume xyz789
# 中断されたタスクの状態が適切に処理され、再開可能
```

### 複数ツール実行中の中断

複数のツールを並行実行している際に中断された場合：

```bash
$ claude code
> 3つのファイルを同時に読み込んで比較して
[Reading file1.js, file2.js, file3.js in parallel...]  # 実行中に中断

$ claude code --resume def456
# すべてのツール実行状態が正しく復元される
```

## 注意点

- この修正はv2.1.21で適用されました
- セッション再開には `--resume` フラグとセッションIDが必要です
- セッションIDは `.claude/sessions/` ディレクトリで確認できます
- 非常に古いセッション（数日以上前）は自動的にクリーンアップされる場合があります
- ツール実行中にCtrl+Cで意図的に中断した場合も、このメカニズムにより安全に再開できます
- ローカルファイルへの書き込み途中で中断された場合、部分的な変更が残っている可能性があるため注意してください

## 関連情報

- [Claude Code 公式ドキュメント](https://code.claude.com/docs/)
- [Changelog v2.1.21](https://github.com/anthropics/claude-code/releases/tag/v2.1.21)
- [セッション管理ガイド](https://code.claude.com/docs/sessions)
