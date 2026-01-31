---
title: "Windows：子プロセス生成時のコンソールウィンドウのフラッシュ（点滅）を修正"
date: 2026-01-30
tags: ['バグ修正', 'Windows', 'UI', 'パフォーマンス']
---

## 原文（日本語に翻訳）

Windows: 子プロセス生成時にコンソールウィンドウがフラッシュ（点滅）する問題を修正

## 原文（英語）

Windows: Fixed console windows flashing when spawning child processes

## 概要

Windows環境でClaude Codeがツール（Bash、Grep、Glob、Readなど）を実行するたびに、黒いコンソールウィンドウが一瞬表示されてすぐに消える（フラッシュ/点滅する）問題が修正されました。この修正により、作業中の視覚的な煩わしさが解消され、よりスムーズなユーザー体験が実現します。

## 問題の背景

v2.1.27以前、Windows環境で以下の問題が発生していました：

- Claude Codeがツールを実行するたびに黒いコンソールウィンドウが瞬間的に表示される
- 画面全体がフラッシュ（点滅）する
- 特にWindows Terminalやエディタの統合ターミナル使用時に目立つ
- 頻繁なツール実行により視覚的な疲労が増加
- 画面録画や配信時に問題が顕著に

## 技術的な原因

この問題は、Node.jsの`child_process.spawn()`を使用する際に、`windowsHide: true`オプションを指定していなかったことが原因でした。Windows環境では、子プロセスを生成する際にデフォルトで新しいコンソールウィンドウが作成されます。

## 修正内容

v2.1.27での改善：

- すべての子プロセス生成時に`windowsHide: true`オプションを追加
- `CREATE_NO_WINDOW`フラグの使用
- `STARTUPINFO.dwFlags = STARTF_USESHOWWINDOW`と`wShowWindow = SW_HIDE`の設定

これにより、バックグラウンドで子プロセスが実行され、ウィンドウが表示されなくなります。

## 実践例

### 通常の開発ワークフロー

v2.1.27以降、以下の操作でもウィンドウのフラッシュが発生しません：

```bash
# Claude Codeを起動
claude

# ファイル検索（Grepツール使用）
> "このプロジェクトでAPIエンドポイントを検索"
# → コンソールウィンドウのフラッシュなし

# ファイル読み取り（Readツール使用）
> "src/index.jsを読んで"
# → スムーズな実行

# Bashコマンド実行
> "テストを実行して"
# → フラッシュなしで実行
```

### 頻繁なツール使用シナリオ

複数のツールを連続使用する場合も快適に：

```bash
# コードレビュータスク
claude "このPRをレビュー"

# 内部で以下が実行される：
# 1. Glob - ファイル一覧取得
# 2. Read - 複数ファイルの読み取り
# 3. Grep - パターン検索
# 4. Bash - テスト実行
# → すべてのステップでフラッシュなし
```

### VS CodeやCursor統合ターミナルでの使用

エディタの統合ターミナルでも快適に：

```bash
# VS Codeのターミナルで
claude

# 作業中にコンソールウィンドウが邪魔をしない
# エディタの表示領域も影響を受けない
```

### 画面録画や配信時

デモやチュートリアル動画作成時も問題なし：

```bash
# 画面録画中
claude "新しいReactコンポーネントを作成"

# 視聴者に煩わしいフラッシュが表示されない
# プロフェッショナルな外観を維持
```

## v2.1.27以前の動作との違い

**v2.1.26以前：**
- ツール実行のたびに黒いコンソールウィンドウが一瞬表示
- 画面全体がフラッシュ
- 作業の集中を妨げる視覚的なノイズ

**v2.1.27以降：**
- すべてのツールがバックグラウンドで実行
- ウィンドウのフラッシュなし
- スムーズでシームレスな体験

## 影響を受けるツール

以下のすべてのツールでフラッシュが解消されます：

- **Bash** - コマンド実行
- **Grep** - コード検索
- **Glob** - ファイルパターンマッチング
- **Read** - ファイル読み取り
- **Edit** - ファイル編集
- **Write** - ファイル書き込み
- **LSP** - Language Server Protocol操作
- その他すべての内部ツール

## パフォーマンスへの影響

この修正によるパフォーマンスへの影響：

- **CPU使用率**: 若干の改善（ウィンドウ生成オーバーヘッドの削減）
- **メモリ使用量**: 変化なし
- **実行速度**: ウィンドウ生成が不要になり、わずかに高速化
- **視覚的な快適性**: 大幅に改善

## トラブルシューティング

もしまだフラッシュが発生する場合：

1. **バージョン確認：**
   ```bash
   claude --version
   # v2.1.27以降であることを確認
   ```

2. **更新：**
   ```bash
   claude update
   ```

3. **他のアプリケーションの確認：**
   - Claude Code以外のアプリケーションがコンソールウィンドウを生成していないか確認
   - タスクマネージャーでプロセスを監視

4. **Windows Terminalの設定確認：**
   ```json
   // settings.json
   {
     "profiles": {
       "defaults": {
         "suppressApplicationTitle": true
       }
     }
   }
   ```

## 注意点

- この修正はWindows環境に特化したものです
- macOSやLinuxでは元々この問題は発生しません
- 一部の古いWindowsバージョン（Windows 7など）では、完全には解消されない可能性があります
- Windows 10/11で最適な動作を保証します
- サードパーティのターミナルエミュレータ（ConEmu, Cmderなど）では、追加の設定が必要な場合があります

## 開発者向け情報

カスタムツールやMCPサーバーを開発している場合、同様の修正を適用できます：

```typescript
// Node.jsでの子プロセス生成時
import { spawn } from 'child_process';

const child = spawn('command', ['args'], {
  windowsHide: true,  // Windowsでウィンドウを非表示
  stdio: 'pipe'
});
```

## 関連Issue

この修正により解決されたIssue：

- [Windows: Console window flashing when executing tools](https://github.com/anthropics/claude-code/issues/14828)
- [Windows: Console windows flash when running Bash commands](https://github.com/anthropics/claude-code/issues/15572)
- [Severe screen flickering in VS Code/Cursor integrated terminal on Windows](https://github.com/anthropics/claude-code/issues/18084)

## 関連情報

- [Troubleshooting - Claude Code Docs](https://code.claude.com/docs/en/troubleshooting)
- [Changelog v2.1.27](https://github.com/anthropics/claude-code/releases/tag/v2.1.27)
