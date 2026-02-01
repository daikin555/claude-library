---
title: "saved_hook_contextを持つセッション再開時の起動パフォーマンス問題の修正"
date: 2026-02-01
tags: [パフォーマンス, バグ修正, フック, セッション管理]
---

## 原文（日本語に翻訳）

`saved_hook_context`を持つセッションを再開する際の起動パフォーマンスの問題を修正しました。

## 原文（英語）

Fixed startup performance issues when resuming sessions that have `saved_hook_context`

## 概要

Claude Code バージョン2.1.29では、フックコンテキストが保存されたセッションを再開する際に発生していた起動時のパフォーマンス問題が修正されました。この修正により、フック機能を活用している開発者が以前のセッションに戻る際のレスポンスが大幅に改善され、より快適な開発体験が実現します。

## 基本的な理解

### saved_hook_contextとは

`saved_hook_context`は、Claude Codeのフックシステムが生成したコンテキスト情報をセッションに保存する機能です。フックはClaude Codeの強力な自動化機能で、特定のイベント（セッション開始、ツール実行前後など）で自動的にスクリプトを実行できます。

### 問題の背景

バージョン2.1.29以前では、保存されたフックコンテキストを含むセッションを再開する際に、起動時間が著しく遅延する問題がありました。特に複数のフックを使用している場合や、フックが大量のコンテキストを生成している場合に顕著でした。

## 実践例

### SessionStartフックを使用している場合

SessionStartフックを活用してプロジェクト情報を自動読み込みしている開発者は、この修正の恩恵を最も受けます。

```yaml
# .claude/hooks/session-start.md の例
---
event: SessionStart
command: |
  # プロジェクトの状態を確認
  git status
  echo "Current branch: $(git branch --show-current)"
---
```

このようなフックを設定している場合、以前はセッション再開時にコンテキストの読み込みで遅延が発生していましたが、2.1.29では即座に再開できるようになります。

### 複数フックを組み合わせている場合

PostToolUseフックとPreCompactフックを組み合わせて、ログやコンテキストの保存を行っている場合も、パフォーマンスが改善されます。

```yaml
# .claude/hooks/post-tool-use.md の例
---
event: PostToolUse
command: |
  # ツール使用履歴を記録
  echo "Tool used: $TOOL_NAME" >> .claude/tool-history.log
---
```

これらのフックで生成されたコンテキストを持つセッションを再開する際、起動時間が大幅に短縮されます。

### セッション再開のワークフロー

```bash
# 以前のセッションを再開
claude --resume

# または名前付きセッションを再開
claude --resume my-project-session
```

フックコンテキストを保存したセッションを再開する場合でも、2.1.29ではスムーズに起動します。

## 注意点

### フックのパフォーマンスベストプラクティス

この修正により起動パフォーマンスは改善されましたが、フック自体のパフォーマンスにも注意を払うことが重要です。

- **SessionStartフックは高速に保つ**: SessionStartフックは毎回のセッション開始時に実行されるため、可能な限り高速に保つことが推奨されます
- **非同期処理の活用**: 重い処理は非同期フックとして実行し、バックグラウンドで完了させることを検討してください
- **コンテキストサイズの管理**: フックが生成するコンテキストのサイズが過大にならないよう注意してください

### フックコンテキストの確認

セッションに保存されているフックコンテキストを確認したい場合は、トランスクリプトモード（Ctrl+O）を使用できます。

### 関連する既知の問題

バージョン2.1.27では、セッション再開ロジックが完全な親チェーンをトラバースしない問題が報告されていました。2.1.29を使用することで、これらの問題も含めて改善されます。

## 関連情報

### 公式ドキュメント

- [Hooks reference - Claude Code Docs](https://code.claude.com/docs/en/hooks)
- [Claude Code Changelog](https://code.claude.com/docs/en/changelog)

### 関連記事とチュートリアル

- [Claude Code Hooks: A Practical Guide to Workflow Automation | DataCamp](https://www.datacamp.com/tutorial/claude-code-hooks)
- [Mother CLAUDE: Automating Everything with Hooks - DEV Community](https://dev.to/dorothyjb/mother-claude-automating-everything-with-hooks-12jh)
- [Supercharge Your Development with Claude Code Hooks](https://medium.com/@vignarajj/supercharge-your-development-with-claude-code-hooks-a-deep-dive-into-flutter-and-spring-boot-e330bbb69e47)

### コミュニティリソース

- [GitHub - disler/claude-code-hooks-mastery](https://github.com/disler/claude-code-hooks-mastery)
- [Claude Code Hook Development Skill](https://gist.github.com/alexfazio/653c5164d726987569ee8229a19f451f)

### 関連するGitHub Issue

- [BUG: 2.1.27 session resume logic is losing context](https://github.com/anthropics/claude-code/issues/22107)
- [Startup time regression in v2.1.9](https://github.com/anthropics/claude-code/issues/18479)
- [SessionStart hooks not working for new conversations](https://github.com/anthropics/claude-code/issues/10373)
