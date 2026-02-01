---
title: "@メンションメニューのフォルダクリック動作の改善"
date: 2026-01-20
tags: ['バグ修正', 'UI/UX', '@メンション']
---

## 原文（日本語に翻訳）

`@`メンションメニューでフォルダをクリックした際、選択ではなくディレクトリ内に移動するように動作を修正

## 原文（英語）

Fixed `@`-mention menu folder click behavior to navigate into directories instead of selecting them

## 概要

Claude Codeの `@` メンション機能において、フォルダをクリックした際の動作を改善しました。以前はフォルダをクリックするとそのフォルダ自体が選択されていましたが、修正後はフォルダ内に移動して中のファイルを閲覧できるようになりました。これにより、深い階層のファイルへのアクセスがより直感的になり、ユーザーエクスペリエンスが大幅に向上しました。

## 基本的な使い方

`@` を入力してメンションメニューを表示した後、フォルダをクリックまたは選択すると、そのフォルダ内に移動します。

```
# メンションメニューを開く
@

# フォルダをクリック → フォルダ内に移動
src/ (クリック)
  → src/ 内のファイルとフォルダが表示される

# さらに深い階層に移動
components/ (クリック)
  → src/components/ 内のファイルが表示される
```

## 実践例

### プロジェクトのソースコードを探索

深い階層にあるファイルを段階的に探索できます。

```
# 手順:
1. @ を入力
2. src/ をクリック → src内に移動
3. components/ をクリック → src/components内に移動
4. Button.tsx を選択 → ファイルを参照に追加

# 結果: @src/components/Button.tsx が選択される
```

### 複数階層のファイルを参照

複数のディレクトリから関連ファイルを選択する場合も簡単です。

```
# バックエンドとフロントエンドのファイルを参照
@backend/api/users.py
@frontend/components/UserProfile.tsx

# それぞれのフォルダを経由して選択
1. @ → backend/ → api/ → users.py
2. @ → frontend/ → components/ → UserProfile.tsx
```

### テストファイルの選択

テストディレクトリ内のファイルを探索する際にも便利です。

```
# テストファイルへのアクセス
@ → tests/ → unit/ → services/ → auth.test.js

# 以前: tests/unit/services/ 全体が選択されてしまう
# 修正後: 段階的にフォルダ内を移動できる
```

### 設定ファイルの選択

プロジェクトルートから深い階層の設定ファイルにアクセス。

```
# 設定ファイルの例
@ → .github/ → workflows/ → ci.yml
@ → config/ → environments/ → production.json

# フォルダをクリックするたびに次の階層へ移動
```

## 注意点

- この改善は Claude Code v2.1.14 で適用されました
- フォルダ自体をコンテキストに追加したい場合は、フォルダを選択後にEnterキーを押すか、明示的に選択オプションを使用してください
- キーボードナビゲーション（矢印キー + Enter）でも同様の動作をします
- 上位階層に戻る場合は、`../` または Escキーで戻ることができます
- この変更により、大規模プロジェクトでのファイル探索が格段にスムーズになりました

## 関連情報

- [Claude Code 公式ドキュメント](https://code.claude.com/docs/)
- [Changelog v2.1.14](https://github.com/anthropics/claude-code/releases/tag/v2.1.14)
- [@メンション機能の詳細](https://code.claude.com/docs/mentions)
- [ファイル参照のベストプラクティス](https://code.claude.com/docs/best-practices/file-references)
