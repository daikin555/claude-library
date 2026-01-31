---
title: "iTerm2プログレスバーのクリーンアップ改善"
date: 2026-01-20
tags: ['バグ修正', 'iTerm2', 'ターミナル統合', 'UI/UX']
---

## 原文（日本語に翻訳）

iTerm2のプログレスバーが終了時に適切にクリアされず、インジケータやベル音が残り続ける問題を修正

## 原文（英語）

Fixed iTerm2 progress bar not clearing properly on exit, preventing lingering indicators and bell sounds

## 概要

macOSのiTerm2ターミナルでClaude Codeを使用する際、処理の進捗を示すプログレスバーが終了後も表示され続けたり、完了音（ベル）が鳴り続ける問題を修正しました。この修正により、Claude Codeの操作完了後にターミナルが正常な状態に戻るようになり、次の作業にスムーズに移行できるようになりました。iTerm2特有の機能を活用しながら、クリーンな使用体験を提供します。

## 基本的な使い方

iTerm2でClaude Codeを使用すると、長時間の処理中に自動的にプログレスバーが表示されます。

```bash
# iTerm2でClaude Codeを起動
claude

# 長時間の処理を実行（例: 大規模な検索）
Find all TODO comments in the entire project
```

処理完了後、プログレスバーとベル音が自動的にクリアされます。

## 実践例

### 大規模なコードベース検索

多数のファイルを検索する際のプログレスバー表示。

```bash
# Claude Codeで大規模検索を実行
> Search for all instances of "deprecated" in the codebase

# iTerm2のプログレスバー表示:
[████████████████░░░░] 78% Searching files...

# 以前の問題:
# - 検索完了後もバーが残る
# - ベル音が断続的に鳴り続ける
# - 次のコマンドを入力してもバーが消えない

# 修正後:
# - 検索完了時にバーが自動的に消える
# - ベル音は1回だけ鳴る
# - ターミナルがクリーンな状態に戻る
```

### ファイルの一括編集

複数ファイルを編集する際の進捗表示。

```bash
# 複数ファイルの一括リファクタリング
> Rename all instances of "oldFunction" to "newFunction" across all TypeScript files

# iTerm2のプログレスバー:
[██████████████████████] 100% Editing files...

# 修正前: バーが100%のまま残り続ける、ベルが鳴り続ける
# 修正後: 完了と同時にバーが消え、ベルが1回鳴って終了
```

### 大規模なGit操作

Git操作中の進捗表示とクリーンアップ。

```bash
# 大規模なGit操作
> Create a commit with all pending changes

# プログレスバーの表示:
[████████░░░░░░░░░░░░] 40% Analyzing changes...
[████████████████████] 80% Staging files...
[████████████████████████] 100% Creating commit...

# 修正後:
# - 各ステップでバーが更新される
# - 最終ステップ完了時にクリーンアップされる
# - 残留インジケータなし
```

### Claude Codeの終了時

アプリケーション終了時のクリーンアップ。

```bash
# Claude Codeを終了
/exit

# 以前の問題:
# - 終了後もiTerm2のタブに進捗インジケータが残る
# - 他のタブに切り替えてもベル音が鳴る
# - iTerm2を再起動するまで解消しない

# 修正後:
# - 終了時にすべてのインジケータがクリアされる
# - ベル音も停止する
# - ターミナルが完全にクリーンな状態になる
```

## 注意点

- この修正は Claude Code v2.1.14 で適用されました
- この問題はiTerm2固有のもので、他のターミナル（Terminal.app、Alacritty、Wezterm等）では発生しません
- iTerm2のプログレスバー機能を利用するには、iTerm2の設定で有効化されている必要があります:
  - Preferences → Profiles → Terminal → "Show progress indicators" をON
- ベル音の動作は、iTerm2の設定で変更できます:
  - Preferences → Profiles → Terminal → Notifications
- プログレスバーは以下の操作で表示されます:
  - 大規模なファイル検索
  - 複数ファイルの編集
  - Git操作
  - 長時間実行されるコマンド（30秒以上）
- この修正により、iTerm2のタブアイコンに表示される進捗インジケータも正しくクリアされます

## 関連情報

- [Claude Code 公式ドキュメント](https://code.claude.com/docs/)
- [Changelog v2.1.14](https://github.com/anthropics/claude-code/releases/tag/v2.1.14)
- [iTerm2統合について](https://code.claude.com/docs/terminal-integration/iterm2)
- [ターミナル設定ガイド](https://code.claude.com/docs/terminal-setup)
- [iTerm2公式ドキュメント](https://iterm2.com/documentation.html)
