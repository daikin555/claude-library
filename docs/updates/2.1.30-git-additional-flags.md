---
title: "git logとgit showの追加フラグサポート - 読み取り専用モード"
date: 2026-02-03
tags: [git, read-only, version-control]
---

## 原文（日本語）
読み取り専用モードで追加の`git log`と`git show`フラグをサポートしました（例：`--topo-order`、`--cherry-pick`、`--format`、`--raw`）。

## 原文（英語）
Added support for additional `git log` and `git show` flags in read-only mode (e.g., `--topo-order`, `--cherry-pick`, `--format`, `--raw`).

## 概要
Claude Codeのサンドボックス化された読み取り専用モードで、より高度なgitコマンドのフラグが使用できるようになりました。コミット履歴の分析や差分の詳細表示に便利なオプションが追加され、リポジトリの調査がより柔軟になりました。

## 基本的な使い方

### トポロジカル順序でコミット履歴を表示
```bash
git log --topo-order
```

ブランチのマージ履歴を理解しやすい順序で表示します。

### カスタムフォーマットでログを表示
```bash
git log --format="%h - %an, %ar : %s"
```

コミットハッシュ、著者、相対時刻、コミットメッセージを簡潔に表示します。

### 生の差分情報を表示
```bash
git show --raw HEAD
```

最新コミットの詳細な変更情報を生の形式で表示します。

## 実践例

### ブランチ間の差分を分析
マージされていないコミットを特定する際に便利です。

```bash
git log --cherry-pick --oneline main...feature-branch
```

「feature-branchにあってmainにないコミットを教えてください」

このコマンドで、ブランチ間の差分コミットを明確に把握できます。

### コミット履歴を視覚的に整理
複雑なブランチ構造を持つプロジェクトで、コミットの流れを理解したい場合：

```bash
git log --topo-order --graph --oneline --all
```

トポロジカル順序でコミットグラフを表示し、ブランチのマージポイントが分かりやすくなります。

### カスタムフォーマットでレポート生成
リリースノートやチェンジログの作成に役立つフォーマット：

```bash
git log --format="* %s (%h) - %an" v1.0..v2.0
```

「v1.0からv2.0までの変更を一覧表示してください」

出力例：
```
* Add new feature X (a1b2c3d) - John Doe
* Fix bug in module Y (e4f5g6h) - Jane Smith
* Update documentation (i7j8k9l) - Bob Wilson
```

### ファイルごとの詳細な変更情報
どのファイルがどのように変更されたかを詳細に確認：

```bash
git show --raw --stat HEAD
```

統計情報と生の変更リストの両方を表示し、コミットの影響範囲を把握できます。

### マージコミットの詳細分析
マージコミットで実際に何が統合されたかを確認：

```bash
git show --format=full --raw <merge-commit-hash>
```

マージコミットの完全な情報と、変更されたファイルの詳細を表示します。

### リリース間の変更を追跡
特定のタグ間での変更を詳細に分析：

```bash
git log --format="%ai %an %s" --reverse v1.0..v2.0
```

「リリースv1.0からv2.0までの変更を時系列で表示してください」

## 注意点

- **読み取り専用モード限定**: これらのフラグは読み取り専用の操作でのみ使用できます。リポジトリを変更するコマンドには使用できません
- **安全性**: Claude Codeのサンドボックス環境内で実行されるため、リポジトリを破損するリスクはありません
- **パフォーマンス**: 大規模なリポジトリで複雑なフラグを使用すると、コマンドの実行に時間がかかる場合があります
- **組み合わせ可能**: 複数のフラグを組み合わせて、より詳細な分析が可能です

## サポートされている主なフラグ

### git log
- `--topo-order`: トポロジカル順序でコミットを表示
- `--cherry-pick`: マージされていないコミットを識別
- `--format=<format>`: カスタム出力フォーマット
- `--graph`: ブランチグラフを表示
- `--stat`: 変更統計を表示
- `--oneline`: 1行で簡潔に表示

### git show
- `--raw`: 生の差分形式で表示
- `--format=<format>`: カスタム出力フォーマット
- `--stat`: 変更統計を表示
- `--patch`: パッチ形式で表示

## 関連情報

- [Git公式ドキュメント - git log](https://git-scm.com/docs/git-log)
- [Git公式ドキュメント - git show](https://git-scm.com/docs/git-show)
- [Claude Code Git連携ガイド](https://docs.anthropic.com/claude/docs/git-integration)
- [Pretty Formats - Git Documentation](https://git-scm.com/docs/pretty-formats)
