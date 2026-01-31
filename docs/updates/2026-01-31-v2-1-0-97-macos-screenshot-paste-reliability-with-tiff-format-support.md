---
title: "macOSスクリーンショット貼り付けの信頼性を改善 - TIFF形式サポート"
date: 2026-01-31
tags: ['改善', 'macOS', 'スクリーンショット', 'TIFF']
---

## 原文（日本語に翻訳）

macOSでのスクリーンショット貼り付けの信頼性を改善し、TIFF形式をサポートしました

## 原文（英語）

Improved macOS screenshot paste reliability with TIFF format support

## 概要

Claude Code v2.1.0で改善された、macOSにおけるスクリーンショット貼り付け機能です。以前のバージョンでは、macOSのネイティブスクリーンショット（Cmd+Shift+4など）をClaude Codeに貼り付けると、TIFF形式のサポート不足により失敗したり、画像が正しく認識されないことがありました。この改善により、macOS標準のTIFF形式スクリーンショットが確実に認識され、スムーズに画像解析ができるようになりました。

## 改善前の動作

### 貼り付けが失敗

```bash
# macOSでスクリーンショットを撮影
# Cmd+Shift+4 → 領域選択

# Claude Codeで貼り付け
claude

> Cmd+V

# 修正前:
Error: Unsupported image format
# または
[Clipboard contains binary data]
# または
# 何も貼り付けられない

# 問題点:
# - TIFF形式が認識されない
# - スクリーンショットが使えない
# - 手動で変換が必要
```

## 改善後の動作

### スムーズな貼り付け

```bash
# macOSでスクリーンショットを撮影
# Cmd+Shift+4 → 領域選択

# Claude Codeで貼り付け
claude

> Cmd+V

# 修正後:
✓ Screenshot pasted (1920x1080, TIFF)
[Image preview displayed]

> "What's in this screenshot?"

# Claudeが画像を解析:
This screenshot shows a code editor with...
[詳細な説明]

# ✓ TIFF形式を自動認識
# ✓ 画像として正しく処理
# ✓ 即座に解析可能
```

## 実践例

### UIバグの報告

画面キャプチャでバグを説明。

```bash
# バグのあるUIをスクリーンショット
# Cmd+Shift+4 → ボタンの領域を選択

# Claude Codeで貼り付け
claude

> Cmd+V
✓ Screenshot pasted

> "This button is misaligned. How can I fix it?"

# Claudeが画像を分析:
I can see the button is 5px too far to the right.
To fix this, update the CSS:

```css
.button {
  margin-left: -5px;
}
```

# ✓ 視覚的な問題を即座に共有
# ✓ 正確な修正提案
```

### デザイン実装

デザインモックを参照。

```bash
# デザインツールからスクリーンショット
# Cmd+Shift+4 → デザイン全体を選択

# Claude Codeで貼り付け
claude

> Cmd+V
✓ Screenshot pasted (design mockup)

> "Implement this design in React"

# Claudeがデザインを解析して実装:
Based on the design, here's the React component:

```jsx
export function Header() {
  return (
    <header className="bg-blue-500 h-16 flex items-center">
      <Logo />
      <Nav />
    </header>
  );
}
```

# ✓ デザインを見ながら実装
# ✓ 正確な再現
```

### エラーメッセージの共有

エラー画面をキャプチャ。

```bash
# ブラウザのエラー画面をスクリーンショット
# Cmd+Shift+4 → エラーメッセージ全体

# Claude Codeで貼り付け
claude

> Cmd+V
✓ Screenshot pasted (error message)

> "Why am I getting this error?"

# Claudeがエラーを読み取って説明:
The error "Cannot read property 'map' of undefined"
indicates that `users` is undefined. Check if the API
call completed before rendering:

```jsx
if (!users) return <Loading />;
return users.map(user => ...);
```

# ✓ エラーを視覚的に共有
# ✓ 即座に解決策を提案
```

### 複数スクリーンショットの比較

変更前後を比較。

```bash
# 変更前のUIをスクリーンショット
# Cmd+Shift+4 → Before

claude

> Cmd+V
✓ Screenshot 1 pasted

> "This is the before state"

# 変更後のUIをスクリーンショット
# Cmd+Shift+4 → After

> Cmd+V
✓ Screenshot 2 pasted

> "And this is after. Did I improve it?"

# Claudeが両方の画像を比較:
Comparing the two screenshots:
- Before: Button was hard to see (low contrast)
- After: Much better visibility with darker background
- Suggestion: Consider adding a subtle shadow for depth

# ✓ 複数画像の比較が可能
```

## 注意点

- Claude Code v2.1.0（2026年1月7日リリース）で実装
- macOS固有の改善
- サポートされる形式:
  - **TIFF**: macOSネイティブスクリーンショット形式
  - **PNG**: 従来から対応
  - **JPEG**: 従来から対応
  - **WebP**: 追加サポート
- macOSスクリーンショットの種類:
  - **Cmd+Shift+3**: 全画面スクリーンショット
  - **Cmd+Shift+4**: 領域選択スクリーンショット
  - **Cmd+Shift+4 → Space**: ウィンドウスクリーンショット
  - **Cmd+Shift+5**: スクリーンショットツール
- クリップボード処理:
  - macOSはデフォルトでTIFF形式をクリップボードに保存
  - Claude CodeがTIFFを自動検知
  - 内部でPNGに変換（必要に応じて）
  - Claudeに送信
- 画像サイズ制限:
  - 最大: 20MB（圧縮前）
  - 推奨: 5MB以下
  - 大きな画像は自動的に圧縮
- 画像解像度:
  - Retinaディスプレイ: 自動的に適切な解像度に調整
  - 高DPI画像も正しく処理
- ファイル保存:
  ```bash
  # スクリーンショットを自動保存
  # ~/.claude/screenshots/
  # screenshot-YYYYMMDD-HHMMSS.png

  # 設定で無効化可能:
  # ~/.claude/settings.json
  {
    "screenshots": {
      "autoSave": false
    }
  }
  ```
- 画像プレビュー:
  - 貼り付け後、ターミナルでプレビュー表示（iTerm2、Kitty対応）
  - サムネイル + メタデータ（サイズ、形式）
  - 詳細表示: スペースキーで拡大
- パフォーマンス:
  - TIFF → PNG変換: 100ms以下
  - 大きな画像でも高速処理
- エラーハンドリング:
  ```bash
  # 形式が不明な場合
  Error: Unrecognized image format
  Supported: TIFF, PNG, JPEG, WebP

  # サイズが大きすぎる場合
  Warning: Image too large (25MB)
  Compressing to 5MB...
  ✓ Image compressed and pasted
  ```
- 他の形式のサポート:
  - **PDF**: 最初のページを画像として抽出
  - **GIF**: 最初のフレームを使用
  - **BMP**: 自動変換
- Windowsとの互換性:
  - Windows: PNG形式がデフォルト
  - 既存のPNGサポートで動作
  - この改善はmacOS固有
- デバッグ:
  ```bash
  claude --debug

  # 画像処理の詳細ログ:
  # [DEBUG] Clipboard contains image data
  # [DEBUG] Format detected: TIFF
  # [DEBUG] Size: 1920x1080 (2.5MB)
  # [DEBUG] Converting TIFF to PNG
  # [DEBUG] Conversion complete (150ms)
  # [DEBUG] Image ready for Claude
  ```
- トラブルシューティング:
  - 貼り付けが失敗する場合:
    - スクリーンショットを一旦ファイルとして保存
    - ファイルをドラッグ&ドロップ
  - 画像が認識されない場合:
    - `file` コマンドで形式確認
    - 手動でPNGに変換

## 関連情報

- [Image support - Claude Code Docs](https://code.claude.com/docs/en/images)
- [Screenshot integration](https://code.claude.com/docs/en/screenshots)
- [macOS integration](https://code.claude.com/docs/en/macos)
