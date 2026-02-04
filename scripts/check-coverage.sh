#!/bin/bash

# Claude Code Changelog記事カバレッジチェックスクリプト
# 各changelogバージョンの項目数と記事数を比較し、不足があれば警告する

set -e

CHANGELOG_FILE="data/last-known-changelog.md"
DOCS_DIR="docs/updates"

# 色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Claude Code Changelog Coverage Check ===${NC}"
echo ""

# チェック対象のバージョンを取得（v2.1.x系のみ）
VERSIONS=$(grep "^## " "$CHANGELOG_FILE" | grep "2\.1\." | sed 's/^## //' | head -10)

TOTAL_MISSING=0
TOTAL_VERSIONS=0

for VERSION in $VERSIONS; do
    TOTAL_VERSIONS=$((TOTAL_VERSIONS + 1))

    # changelogから次のバージョンまでの範囲を取得
    NEXT_VERSION=$(grep "^## " "$CHANGELOG_FILE" | grep -A1 "^## $VERSION$" | tail -1 | sed 's/^## //')

    # changelog項目数をカウント
    if [ "$VERSION" = "$NEXT_VERSION" ]; then
        # 最後のバージョンの場合
        CHANGELOG_COUNT=$(sed -n "/^## $VERSION$/,\$p" "$CHANGELOG_FILE" | grep "^- " | wc -l | tr -d ' ')
    else
        CHANGELOG_COUNT=$(sed -n "/^## $VERSION$/,/^## $NEXT_VERSION$/p" "$CHANGELOG_FILE" | grep "^- " | wc -l | tr -d ' ')
    fi

    # 記事数をカウント
    ARTICLE_COUNT=$(ls -1 $DOCS_DIR/$VERSION-*.md 2>/dev/null | wc -l | tr -d ' ')

    # 結果表示
    echo -e "${BLUE}Version $VERSION:${NC}"
    echo "  Changelog items: $CHANGELOG_COUNT"
    echo "  Articles:        $ARTICLE_COUNT"

    # 不足をチェック
    MISSING=$((CHANGELOG_COUNT - ARTICLE_COUNT))

    if [ $MISSING -gt 0 ]; then
        echo -e "  ${RED}✗ Missing: $MISSING article(s)${NC}"
        TOTAL_MISSING=$((TOTAL_MISSING + MISSING))

        # 不足している項目を表示
        echo -e "${YELLOW}  Missing changelog items:${NC}"

        # changelogの全項目を取得
        if [ "$VERSION" = "$NEXT_VERSION" ]; then
            CHANGELOG_ITEMS=$(sed -n "/^## $VERSION$/,\$p" "$CHANGELOG_FILE" | grep "^- " | sed 's/^- //')
        else
            CHANGELOG_ITEMS=$(sed -n "/^## $VERSION$/,/^## $NEXT_VERSION$/p" "$CHANGELOG_FILE" | grep "^- " | sed 's/^- //')
        fi

        # 既存の記事から項目を抽出（原文英語から）
        EXISTING_ITEMS=""
        for ARTICLE in $DOCS_DIR/$VERSION-*.md; do
            if [ -f "$ARTICLE" ]; then
                ITEM=$(grep "^## 原文（英語）" "$ARTICLE" -A1 | tail -1 | sed 's/^[[:space:]]*//')
                EXISTING_ITEMS="$EXISTING_ITEMS
$ITEM"
            fi
        done

        # 不足している項目を表示（簡易版）
        echo "$CHANGELOG_ITEMS" | while IFS= read -r item; do
            # 記事が存在するか簡易チェック（先頭50文字でマッチング）
            ITEM_PREFIX=$(echo "$item" | cut -c1-50)
            if ! echo "$EXISTING_ITEMS" | grep -q "$ITEM_PREFIX"; then
                echo -e "    ${YELLOW}- $item${NC}"
            fi
        done

    elif [ $MISSING -eq 0 ]; then
        echo -e "  ${GREEN}✓ Complete coverage${NC}"
    else
        echo -e "  ${YELLOW}⚠ Extra articles: $((-MISSING))${NC}"
    fi

    echo ""
done

# サマリー
echo -e "${BLUE}=== Summary ===${NC}"
echo "Versions checked: $TOTAL_VERSIONS"

if [ $TOTAL_MISSING -eq 0 ]; then
    echo -e "${GREEN}✓ All changelog items have corresponding articles!${NC}"
    exit 0
else
    echo -e "${RED}✗ Total missing articles: $TOTAL_MISSING${NC}"
    echo ""
    echo -e "${YELLOW}To generate missing articles, run:${NC}"
    echo "  python scripts/generate_articles.py"
    echo ""
    echo -e "${YELLOW}Or create them manually following the guidelines in CLAUDE.md${NC}"
    exit 1
fi
