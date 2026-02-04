#!/usr/bin/env python3
"""
changelogから個別記事を生成するスクリプト
"""

import re
import os
from pathlib import Path
from typing import Dict, List, Tuple
from datetime import datetime

# リリース日マッピング（既知のバージョンのみ）
RELEASE_DATES = {
    "2.1.0": "2026-01-07",
    "2.1.2": "2026-01-09",
    "2.1.3": "2026-01-09",
    "2.1.4": "2026-01-11",
    "2.1.5": "2026-01-12",
    "2.1.6": "2026-01-13",
    "2.1.7": "2026-01-14",
    "2.1.9": "2026-01-16",
    "2.1.10": "2026-01-16",
    "2.1.11": "2026-01-17",
    "2.1.12": "2026-01-17",
    "2.1.14": "2026-01-20",
    "2.1.15": "2026-01-21",
    "2.1.16": "2026-01-22",
    "2.1.17": "2026-01-22",
    "2.1.18": "2026-01-23",
    "2.1.19": "2026-01-23",
    "2.1.20": "2026-01-27",
    "2.1.21": "2026-01-28",
    "2.1.22": "2026-01-28",
    "2.1.23": "2026-01-29",
    "2.1.25": "2026-01-29",
    "2.1.27": "2026-01-30",
    "2.1.29": "2026-02-03",
    "2.1.30": "2026-02-03",
    "2.1.31": "2026-02-04",
}


def get_release_date(version: str) -> str:
    """
    バージョンのリリース日を取得する。
    マッピングにない場合は今日の日付を返す。
    """
    if version in RELEASE_DATES:
        return RELEASE_DATES[version]
    else:
        # マッピングにない場合は今日の日付を使用
        today = datetime.now().strftime("%Y-%m-%d")
        print(f"Warning: No release date for version {version}, using today's date: {today}")
        return today


def parse_changelog(changelog_path: str) -> List[Tuple[str, str, int, str]]:
    """
    changelogを解析してエントリのリストを返す

    Returns:
        List of (version, release_date, index, entry_text)
    """
    entries = []
    current_version = None
    entry_index = 0
    in_v21_section = False

    with open(changelog_path, 'r', encoding='utf-8') as f:
        for line in f:
            line = line.rstrip()

            # バージョン行をチェック
            version_match = re.match(r'^## (2\.\d+\.\d+)', line)
            if version_match:
                version = version_match.group(1)

                # v2.1.xセクション判定
                if version.startswith('2.1.'):
                    in_v21_section = True
                    current_version = version
                    entry_index = 0
                elif version.startswith('2.0.'):
                    in_v21_section = False
                    current_version = None
                continue

            # エントリ行をチェック
            if in_v21_section and current_version:
                entry_match = re.match(r'^- (.+)$', line)
                if entry_match:
                    entry_text = entry_match.group(1)
                    release_date = get_release_date(current_version)
                    entries.append((current_version, release_date, entry_index, entry_text))
                    entry_index += 1

    return entries


def generate_feature_name(entry_text: str, version: str, index: int) -> str:
    """エントリテキストからfeature-nameを生成"""
    # プレフィックスを削除
    text = re.sub(r'^(Added|Fixed|Improved|Changed|Removed|Deprecated) ', '', entry_text)

    # 最初の50文字程度を取得
    keywords = text[:60]

    # kebab-caseに変換
    feature_name = keywords.lower()
    feature_name = re.sub(r'[^a-z0-9]+', '-', feature_name)
    feature_name = re.sub(r'-+', '-', feature_name)
    feature_name = feature_name.strip('-')

    # バージョンとインデックスを追加
    version_slug = version.replace('.', '-')
    return f"v{version_slug}-{index}-{feature_name}"


def translate_to_japanese(entry_text: str) -> str:
    """エントリテキストを日本語に翻訳（簡易版）"""
    # この関数は後でClaude APIを使って翻訳する
    # 今は簡易的なマッピングのみ
    translations = {
        'Added': '追加',
        'Fixed': '修正',
        'Improved': '改善',
        'Changed': '変更',
        'Removed': '削除',
        'Deprecated': '非推奨化',
    }

    for en, ja in translations.items():
        if entry_text.startswith(en + ' '):
            return entry_text.replace(en, ja, 1)

    return entry_text


def extract_tags(entry_text: str) -> List[str]:
    """エントリから適切なタグを抽出"""
    tags = []

    # カテゴリタグ
    if entry_text.startswith('Added'):
        tags.append('新機能')
    elif entry_text.startswith('Fixed'):
        tags.append('バグ修正')
    elif entry_text.startswith('Improved'):
        tags.append('改善')
    elif entry_text.startswith('Changed'):
        tags.append('変更')

    # プラットフォームタグ
    if 'Windows:' in entry_text or 'Windows' in entry_text:
        tags.append('Windows')
    if 'VSCode' in entry_text or '[VSCode]' in entry_text or '[IDE]' in entry_text:
        tags.append('VSCode')
    if 'MCP' in entry_text:
        tags.append('MCP')
    if 'Bedrock' in entry_text:
        tags.append('Bedrock')
    if 'Vertex' in entry_text:
        tags.append('Vertex')

    # 機能タグ
    if 'hook' in entry_text.lower():
        tags.append('hooks')
    if 'bash' in entry_text.lower() or 'Bash' in entry_text:
        tags.append('bash')
    if 'permission' in entry_text.lower():
        tags.append('パーミッション')
    if '/\w+' in entry_text or 'command' in entry_text.lower():
        tags.append('コマンド')

    return tags if tags else ['その他']


def generate_article_content(version: str, release_date: str, index: int, entry_text: str) -> str:
    """記事の内容を生成"""
    # 日本語タイトル生成
    title_ja = translate_to_japanese(entry_text)
    if len(title_ja) > 60:
        title_ja = title_ja[:57] + '...'

    # タグ抽出
    tags = extract_tags(entry_text)

    # frontmatter
    frontmatter = f"""---
title: "{title_ja}"
date: {release_date}
tags: {tags}
---

"""

    # 本文
    body = f"""## 原文（日本語に翻訳）

{translate_to_japanese(entry_text)}

## 原文（英語）

{entry_text}

## 概要

Claude Code v{version} でリリースされた機能です。

（詳細は調査中）

## 基本的な使い方

（調査中）

## 実践例

### 基本的な使用例

（調査中）

## 注意点

- この機能は Claude Code v{version} で導入されました
- 詳細なドキュメントは公式サイトを参照してください

## 関連情報

- [Claude Code 公式ドキュメント](https://code.claude.com/docs/)
- [Changelog v{version}](https://github.com/anthropics/claude-code/releases/tag/v{version})
"""

    return frontmatter + body


def main():
    # パス設定
    script_dir = Path(__file__).parent
    project_root = script_dir.parent
    changelog_path = project_root / 'data' / 'last-known-changelog.md'
    output_dir = project_root / 'docs' / 'updates'

    # changelogを解析
    print("Parsing changelog...")
    entries = parse_changelog(str(changelog_path))
    print(f"Found {len(entries)} entries in v2.1.x")

    # 出力ディレクトリの確認
    output_dir.mkdir(parents=True, exist_ok=True)

    # エントリごとに記事を生成
    generated_files = []
    for version, release_date, index, entry_text in entries:
        feature_name = generate_feature_name(entry_text, version, index)
        output_file = output_dir / f"2026-01-31-{feature_name}.md"

        # 記事内容を生成
        content = generate_article_content(version, release_date, index, entry_text)

        # ファイルに書き込み
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(content)

        generated_files.append(str(output_file))

        # 進捗表示（10件ごと）
        if (index + 1) % 10 == 0 or index == 0:
            print(f"  v{version}: Generated {index + 1} articles")

    print(f"\nTotal: Generated {len(generated_files)} articles")
    print(f"Output directory: {output_dir}")

    # サンプルファイルを表示
    if generated_files:
        print(f"\nSample file: {generated_files[0]}")


if __name__ == '__main__':
    main()
