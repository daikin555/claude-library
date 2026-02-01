---
title: "[VSCode] Python仮想環境の自動アクティベーション機能を追加"
date: 2026-01-28
tags: ['VSCode', 'Python', '新機能', '仮想環境']
---

## 原文（日本語に翻訳）

[VSCode] Python仮想環境の自動アクティベーション機能を追加し、`python`および`pip`コマンドが正しいインタープリターを使用することを保証（`claudeCode.usePythonEnvironment`設定で設定可能）

## 原文（英語）

[VSCode] Added automatic Python virtual environment activation, ensuring `python` and `pip` commands use the correct interpreter (configurable via `claudeCode.usePythonEnvironment` setting)

## 概要

VS Code拡張でClaude Codeを使用する際、Python仮想環境が自動的にアクティベートされるようになりました。これにより、`python`や`pip`コマンドがプロジェクトで設定された仮想環境のインタープリターを正しく使用し、依存関係の管理やスクリプト実行が期待通りに動作します。この機能は`claudeCode.usePythonEnvironment`設定で制御でき、必要に応じてオン/オフを切り替えられます。

## 基本的な使い方

VS Codeで仮想環境を使用しているPythonプロジェクトを開いている場合、Claude Codeが自動的にその環境を使用します。

```bash
# VS CodeでClaude Codeを起動
> requirements.txtの依存関係をインストールして

# v2.1.21以降: 自動的に仮想環境がアクティベートされる
[Activating virtual environment: .venv]
[Running: pip install -r requirements.txt]
# → 仮想環境内にパッケージがインストールされる

# v2.1.20以前: システムのPythonが使用される可能性があった
```

**設定方法:**
VS Codeの設定（`.vscode/settings.json`または User Settings）で制御できます：

```json
{
  "claudeCode.usePythonEnvironment": true  // デフォルトはtrue
}
```

## 実践例

### 仮想環境内での依存関係管理

プロジェクトの依存関係をインストールする際、正しい環境に配置されます：

```
> numpy、pandas、matplotlibをインストールして

# 仮想環境が自動アクティベート
[Using Python environment: /path/to/project/.venv]
[Running: pip install numpy pandas matplotlib]
# → .venv/lib/python3.x/site-packages/ にインストールされる
```

### Pythonスクリプトの実行

スクリプトを実行する際、仮想環境のインタープリターが使用されます：

```
> scripts/analyze_data.pyを実行して

[Using Python from .venv: Python 3.11.5]
[Running: python scripts/analyze_data.py]
# → 仮想環境のパッケージが正しく読み込まれる
```

### バージョン確認とパッケージリスト

仮想環境の状態を確認する際も適切に動作します：

```
> インストール済みのPythonパッケージをリストアップして

[Python environment: .venv]
[Running: pip list]
# → 仮想環境内のパッケージのみが表示される（システム全体ではない）
```

### 複数の仮想環境を持つワークスペース

VS Codeで選択されている仮想環境が自動的に使用されます：

```
# VS Codeで .venv-dev を選択している場合
> pytest を実行して

[Using Python environment: .venv-dev]
[Running: pytest]
# → .venv-dev 内の pytest が使用される
```

### 設定の無効化

この機能を無効にしたい場合：

```json
{
  "claudeCode.usePythonEnvironment": false
}
```

無効にすると、システムのデフォルトPythonが使用されます。

## 注意点

- この機能はv2.1.21で追加されました
- VS Code拡張専用の機能です（CLI版には含まれません）
- `claudeCode.usePythonEnvironment`のデフォルト値は`true`です
- VS Codeで選択されているPythonインタープリターが自動的に使用されます
- 仮想環境は以下の場所から自動検出されます：
  - `.venv`
  - `venv`
  - `env`
  - VS Codeの設定で指定されたパス
- 仮想環境が見つからない場合、システムのPythonが使用されます
- `conda`環境もサポートされます
- この機能により、"ModuleNotFoundError"などの仮想環境関連のエラーが大幅に減少します

## 関連情報

- [Claude Code 公式ドキュメント](https://code.claude.com/docs/)
- [Changelog v2.1.21](https://github.com/anthropics/claude-code/releases/tag/v2.1.21)
- [VS Code拡張機能ガイド](https://code.claude.com/docs/vscode)
- [Python環境設定ガイド](https://code.claude.com/docs/python-environments)
